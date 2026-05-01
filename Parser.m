#import "Parser.h"

@interface MParser ()
@property NSArray *tokens;
@property int pos;
@end

@implementation MParser

- (id)peek {
    if (self.pos >= (int)self.tokens.count) return nil;
    return self.tokens[self.pos];
}

- (id)eat {
    if (self.pos >= (int)self.tokens.count) return nil;
    return self.tokens[self.pos++];
}

- (MAssign *)parse:(NSArray *)tokens {
    self.tokens = tokens;
    self.pos = 0;

    NSDictionary *targetTok = [self eat];
    NSString *target = targetTok[@"value"];

    [self eat]; // consume '='

    MNode *expr = [self expr];

    MAssign *assign = [[MAssign alloc] initWithTarget:target value:expr];
    return assign;
}

// expr handles + and - (left-associative)
- (MNode *)expr {
    MNode *left = [self term];

    while ([self peek] != nil) {
        NSString *val = [self peek][@"value"];
        if (![val isEqualToString:@"+"] && ![val isEqualToString:@"-"]) break;

        NSString *op = [self eat][@"value"];
        MNode *right = [self term];

        left = [[MBinOp alloc] initWithLeft:left op:op right:right];
    }

    return left;
}

// term handles * and /
- (MNode *)term {
    MNode *left = [self factor];

    while ([self peek] != nil) {
        NSString *val = [self peek][@"value"];
        if (![val isEqualToString:@"*"] && ![val isEqualToString:@"/"]) break;

        NSString *op = [self eat][@"value"];
        MNode *right = [self factor];

        left = [[MBinOp alloc] initWithLeft:left op:op right:right];
    }

    return left;
}

// factor: a single identifier or number token
- (MNode *)factor {
    NSDictionary *tok = [self eat];
    if (!tok) return [[MVar alloc] initWithName:@"0"];

    return [[MVar alloc] initWithName:tok[@"value"]];
}

@end

