
#import "Parser.h"

@interface MParser ()
@property NSArray *tokens;
@property int pos;
@end

@implementation MParser

- (id)peek {
    if (self.pos >= self.tokens.count) return nil;
    return self.tokens[self.pos];
}

- (id)eat {
    return self.tokens[self.pos++];
}

- (MAssign *)parse:(NSArray *)tokens {
    self.tokens = tokens;
    self.pos = 0;

    NSString *target = [self eat][@"value"];
    [self eat]; // '='

    MBinOp *expr = [self expr];

    MAssign *assign = [MAssign new];
    assign.target = target;
    assign.value = expr;

    return assign;
}

- (MBinOp *)expr {
    MNode *left = [self term];

    while ([self peek] && [[self peek][@"value"] isEqualToString:@"+"]) {
        NSString *op = [self eat][@"value"];
        MNode *right = [self term];

        MBinOp *bin = [MBinOp new];
        bin.left = left;
        bin.op = op;
        bin.right = right;

        left = bin;
    }

    return (MBinOp *)left;
}

- (MVar *)term {
    NSDictionary *tok = [self eat];

    MVar *v = [MVar new];
    v.name = tok[@"value"];
    return v;
}

@end
