
#import <Foundation/Foundation.h>
#import "AST.h"

@interface MCodegen : NSObject

- (NSString *)generate:(MAssign *)node;

@end


