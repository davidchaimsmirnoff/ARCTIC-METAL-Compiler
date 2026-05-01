
#import <Foundation/Foundation.h>
#import "Lexer.h"
#import "Parser.h"
#import "Codegen.h"

int main() {

    NSString *source = @"out = a + b";

    MLexer *lexer = [MLexer new];
    NSArray *tokens = [lexer tokenize:source];

    MParser *parser = [MParser new];
    MAssign *ast = [parser parse:tokens];

    MCodegen *gen = [MCodegen new];
    NSString *metal = [gen generate:ast];

    NSLog(@"\n%@", metal);

    return 0;
}
