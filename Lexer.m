#import "Lexer.h"

@implementation MLexer

- (NSArray *)tokenize:(NSString *)code {
    NSMutableArray *tokens = [NSMutableArray array];

    for (int i = 0; i < code.length; i++) {
        unichar c = [code characterAtIndex:i];

        if (c == ' ' || c == '\t') continue;

        if (c == '+' || c == '-' || c == '*' || c == '/' || c == '=') {
            [tokens addObject:@{@"type": @"OP", @"value": [NSString stringWithFormat:@"%c", c]}];
        }
        else if ([[NSCharacterSet letterCharacterSet] characterIsMember:c]) {
            NSMutableString *idstr = [NSMutableString string];
            while (i < code.length &&
                   [[NSCharacterSet alphanumericCharacterSet]
                    characterIsMember:[code characterAtIndex:i]]) {
                [idstr appendFormat:@"%c", [code characterAtIndex:i]];
                i++;
            }
            i--;
            [tokens addObject:@{@"type": @"ID", @"value": idstr}];
        }
    }

    return tokens;
}

@end

