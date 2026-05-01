
#import "MRuntime.h"

@implementation MRuntime

- (instancetype)init {
    self = [super init];
    if (self) {
        // MTLCreateSystemDefaultDevice returns nil on some Intel Macs running
        // macOS 13 command-line tools — fall back to MTLCopyAllDevices instead.
        _device = MTLCreateSystemDefaultDevice();
        if (!_device) {
            NSArray<id<MTLDevice>> *devices = MTLCopyAllDevices();
            _device = devices.firstObject;
        }
        if (!_device) {
            NSLog(@"❌ No Metal device found.");
            return nil;
        }
        NSLog(@"✅ Metal device: %@", _device.name);
        _queue = [_device newCommandQueue];
    }
    return self;
}

- (void)runKernel:(NSString *)source a:(float)a b:(float)b {

    NSError *error = nil;

    id<MTLLibrary> library =
        [_device newLibraryWithSource:source options:nil error:&error];

    if (!library) {
        NSLog(@"❌ Metal compile failed:");
        NSLog(@"%@", error.localizedDescription);
        NSLog(@"%@", error.userInfo);
        return;
    }

    id<MTLFunction> function = [library newFunctionWithName:@"compute"];
    if (!function) {
        NSLog(@"❌ Could not find function 'compute' in kernel source.");
        return;
    }

    id<MTLComputePipelineState> pipeline =
        [_device newComputePipelineStateWithFunction:function error:&error];
    if (!pipeline) {
        NSLog(@"❌ Pipeline creation failed: %@", error.localizedDescription);
        return;
    }

    id<MTLBuffer> bufA   = [_device newBufferWithBytes:&a length:sizeof(float) options:0];
    id<MTLBuffer> bufB   = [_device newBufferWithBytes:&b length:sizeof(float) options:0];
    id<MTLBuffer> bufOut = [_device newBufferWithLength:sizeof(float) options:0];

    id<MTLCommandBuffer> commandBuffer = [_queue commandBuffer];
    id<MTLComputeCommandEncoder> encoder = [commandBuffer computeCommandEncoder];

    [encoder setComputePipelineState:pipeline];
    [encoder setBuffer:bufOut offset:0 atIndex:0];
    [encoder setBuffer:bufA   offset:0 atIndex:1];
    [encoder setBuffer:bufB   offset:0 atIndex:2];

    MTLSize grid    = MTLSizeMake(1, 1, 1);
    MTLSize threads = MTLSizeMake(1, 1, 1);

    [encoder dispatchThreads:grid threadsPerThreadgroup:threads];
    [encoder endEncoding];

    [commandBuffer commit];
    [commandBuffer waitUntilCompleted];

    float result = 0;
    memcpy(&result, bufOut.contents, sizeof(float));

    NSLog(@"✅ Result: %f", result);
}

@end

