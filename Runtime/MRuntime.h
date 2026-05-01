
#import <Foundation/Foundation.h>
#import <Metal/Metal.h>
 
@interface MRuntime : NSObject
 
@property (nonatomic, strong) id<MTLDevice> device;
@property (nonatomic, strong) id<MTLCommandQueue> queue;
 
- (instancetype)init;
- (void)runKernel:(NSString *)source a:(float)a b:(float)b;
 
@end
 
