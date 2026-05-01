

#import <Foundation/Foundation.h>
#import "AST.h"

@interface MParser : NSObject
- (MAssign *)parse:(NSArray *)tokens;
@end

