

#import <Foundation/Foundation.h>
#import "MKernel.h"

@interface MKernelRegistry : NSObject


@property (nonatomic, strong) NSMutableDictionary<NSString*, MKernel*> *kernels;


- (void)store:(MKernel *)kernel;
- (MKernel *)get:(NSString *)name;

@end

