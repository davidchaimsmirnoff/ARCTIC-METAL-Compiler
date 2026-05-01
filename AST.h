
#import <Foundation/Foundation.h>

#pragma mark - Base Node

@interface MNode : NSObject
@end

#pragma mark - Variable Node

@interface MVar : MNode

@property (nonatomic, strong) NSString *name;

- (instancetype)initWithName:(NSString *)name;

@end

#pragma mark - Binary Operation Node

@interface MBinOp : MNode

@property (nonatomic, strong) MNode *left;
@property (nonatomic, strong) NSString *op;
@property (nonatomic, strong) MNode *right;

- (instancetype)initWithLeft:(MNode *)left
                          op:(NSString *)op
                       right:(MNode *)right;

@end

#pragma mark - Assignment Node

@interface MAssign : MNode

@property (nonatomic, strong) NSString *target;
@property (nonatomic, strong) MNode *value;

- (instancetype)initWithTarget:(NSString *)target
                        value:(MNode *)value;

@end

