
#import "MKernelRegistry.h"

@implementation MKernelRegistry

- (instancetype)init {
    self = [super init];
    if (self) {
        _kernels = [NSMutableDictionary dictionary];
    }
    return self;
}

- (void)store:(MKernel *)kernel {
    self.kernels[kernel.name] = kernel;
}

- (MKernel *)get:(NSString *)name {
    return self.kernels[name];
}

@end

