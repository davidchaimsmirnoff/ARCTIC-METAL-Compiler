


#import <Foundation/Foundation.h>

@interface MNode : NSObject
@end

@interface MVar : MNode
@property NSString *name;
@end

@interface MBinOp : MNode
@property MNode *left;
@property NSString *op;
@property MNode *right;
@end

@interface MAssign : MNode
@property NSString *target;
@property MNode *value;
@end
