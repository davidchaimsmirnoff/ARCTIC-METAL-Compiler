
#import <Foundation/Foundation.h>
#import "MRuntime.h"
#import "Lexer.h"
#import "Parser.h"
#import "Codegen.h"

#pragma mark - Kernel Storage

// Maps kernel name -> compiled Metal source string
static NSMutableDictionary<NSString *, NSString *> *kernelRegistry;

#pragma mark - Helpers

static NSArray<NSString *> *splitInput(NSString *input) {
    // Split on first space only to separate command from body
    return [input componentsSeparatedByCharactersInSet:
            [NSCharacterSet whitespaceCharacterSet]];
}

#pragma mark - Commands

// Usage: kernel <name> <expression>
// Example: kernel add out = a + b
static void handleKernel(NSString *input) {

    // Input after "kernel" keyword: "add out = a + b"
    // Strip the leading "kernel " prefix
    NSString *body = [input substringFromIndex:[@"kernel " length]];

    // First token is the kernel name
    NSRange spaceRange = [body rangeOfString:@" "];
    if (spaceRange.location == NSNotFound) {
        NSLog(@"usage: kernel <name> <expression>\n"
               "  e.g. kernel add out = a + b");
        return;
    }

    NSString *name = [body substringToIndex:spaceRange.location];
    NSString *expr = [body substringFromIndex:spaceRange.location + 1];

    if (name.length == 0 || expr.length == 0) {
        NSLog(@"usage: kernel <name> <expression>\n"
               "  e.g. kernel add out = a + b");
        return;
    }

    // Run through the full compiler pipeline
    MLexer *lexer     = [[MLexer alloc] init];
    MParser *parser   = [[MParser alloc] init];
    MCodegen *codegen = [[MCodegen alloc] init];

    NSArray *tokens     = [lexer tokenize:expr];
    MAssign *ast        = [parser parse:tokens];
    NSString *metalSrc  = [codegen generate:ast];

    kernelRegistry[name] = metalSrc;

    NSLog(@"✅ Kernel '%@' compiled and stored.", name);
    NSLog(@"--- Generated MSL ---\n%@\n---------------------", metalSrc);
}

// Usage: run <name> <a> <b>
// Example: run add 3.0 4.0
static void handleRun(NSArray<NSString *> *tokens, MRuntime *runtime) {

    if (tokens.count < 4) {
        NSLog(@"usage: run <kernel> <a> <b>");
        return;
    }

    NSString *kernelName = tokens[1];
    float a = [tokens[2] floatValue];
    float b = [tokens[3] floatValue];

    NSString *source = kernelRegistry[kernelName];

    if (!source) {
        NSLog(@"❌ Unknown kernel: '%@'. Define it first with the kernel command.", kernelName);
        return;
    }

    [runtime runKernel:source a:a b:b];
}

static void handleHelp(void) {
    NSLog(@"\n🔥 Megatron GPU Compiler REPL v0.1\n"
           "\nCommands:\n"
           "  kernel <name> <expr>     compile and store a kernel\n"
           "    e.g.  kernel add out = a + b\n"
           "    e.g.  kernel mul out = a * b\n"
           "\n"
           "  run <name> <a> <b>       execute a stored kernel on the GPU\n"
           "    e.g.  run add 3.0 4.0\n"
           "\n"
           "  help                     show this message\n"
           "  exit                     quit\n");
}

#pragma mark - Main

int main(int argc, const char * argv[]) {
    @autoreleasepool {

        kernelRegistry = [NSMutableDictionary new];

        MRuntime *runtime = [[MRuntime alloc] init];
        if (!runtime) {
            NSLog(@"❌ Failed to initialize Metal runtime. Exiting.");
            return 1;
        }

        char buffer[2048];

        NSLog(@"🔥 Megatron GPU Compiler REPL v0.1");
        NSLog(@"Type 'help' for usage.");

        while (1) {

            printf("\nmegatron > ");
            fflush(stdout);

            if (!fgets(buffer, sizeof(buffer), stdin)) {
                break;
            }

            NSString *input =
                [[NSString stringWithUTF8String:buffer]
                 stringByTrimmingCharactersInSet:
                 [NSCharacterSet newlineCharacterSet]];

            if (input.length == 0) continue;

            if ([input isEqualToString:@"exit"]) {
                break;
            }

            if ([input isEqualToString:@"help"]) {
                handleHelp();
                continue;
            }

            // For 'kernel' we pass the full raw input so we can parse the expression
            if ([input hasPrefix:@"kernel "]) {
                handleKernel(input);
                continue;
            }

            // For other commands, split by whitespace
            NSArray<NSString *> *tokens =
                [input componentsSeparatedByCharactersInSet:
                 [NSCharacterSet whitespaceCharacterSet]];

            NSString *cmd = tokens.firstObject;

            if ([cmd isEqualToString:@"run"]) {
                handleRun(tokens, runtime);
            }
            else {
                NSLog(@"❓ Unknown command: '%@'. Type 'help' for usage.", input);
            }
        }

        NSLog(@"👋 bye.");
    }

    return 0;
}


