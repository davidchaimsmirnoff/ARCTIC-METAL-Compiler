
#import "AST.h"

@implementation MNode
@end

@implementation MVar

- (instancetype)initWithName:(NSString *)name {
    self = [super init];
    if (self) {
        _name = name;
    }
    return self;
}

@end

@implementation MBinOp

- (instancetype)initWithLeft:(MNode *)left
                          op:(NSString *)op
                       right:(MNode *)right {
    self = [super init];
    if (self) {
        _left = left;
        _op = op;
        _right = right;
    }
    return self;
}

@end

@implementation MAssign

- (instancetype)initWithTarget:(NSString *)target
                        value:(MNode *)value {
    self = [super init];
    if (self) {
        _target = target;
        _value = value;
    }
    return self;
}

@end


