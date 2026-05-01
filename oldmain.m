
#import <Foundation/Foundation.h>
#import "MRuntime.h"

#pragma mark - Helpers

static NSArray<NSString *> *tokenize(NSString *input) {
    return [input componentsSeparatedByCharactersInSet:
            [NSCharacterSet whitespaceCharacterSet]];
}

#pragma mark - Command Handlers

static void handleKernel(NSArray<NSString *> *tokens) {
    // kernel add(a,b){ ... }
    NSLog(@"[kernel] received: %@", tokens);

    // TODO: pass into parser + AST + codegen
}



// Replaced HandleRun



static void handleRun(NSArray<NSString *> *tokens, MRuntime *runtime) {

    float a = [tokens[2] floatValue];
    float b = [tokens[3] floatValue];

    float result = [runtime runMetalWithInputs:_kernelRegistry[@"add"] a:a b:b];

    NSLog(@"Result: %f", result);
}



NSString *metal =
@"#include <metal_stdlib>\n"
"using namespace metal;\n"
"\n"
"kernel void compute(\n"
"    device float *out [[buffer(0)]],\n"
"    device float *a [[buffer(1)]],\n"
"    device float *b [[buffer(2)]],\n"
"    uint id [[thread_position_in_grid]])\n"
"{\n"
"    out[0] = a[0] + b[0];\n"
"}\n";

}




static void handleHelp(void) {
    NSLog(@"\nMegatron commands:\n"
          "  kernel <def>   define kernel\n"
          "  run <name>     execute kernel\n"
          "  exit            quit\n");
}

#pragma mark - Main

int main(int argc, const char * argv[]) {
    @autoreleasepool {

        MRuntime *runtime = [[MRuntime alloc] init];

        char buffer[1024];

        NSLog(@"Megatron GPU Compiler REPL v0.1");

        while (1) {

            printf("megatron > ");
            if (!fgets(buffer, sizeof(buffer), stdin)) {
                break;
            }

            NSString *input =
            [[NSString stringWithUTF8String:buffer]
             stringByTrimmingCharactersInSet:
             [NSCharacterSet newlineCharacterSet]];

            if (input.length == 0) {
                continue;
            }

            if ([input isEqualToString:@"exit"]) {
                break;
            }

            NSArray<NSString *> *tokens = tokenize(input);

            NSString *cmd = tokens.firstObject;

            if ([cmd isEqualToString:@"kernel"]) {
                handleKernel(tokens);
            }
            else if ([cmd isEqualToString:@"run"]) {
                handleRun(tokens, runtime);
            }
            else if ([cmd isEqualToString:@"help"]) {
                handleHelp();
            }
            else {
                NSLog(@"unknown command: %@", input);
            }
        }

        NSLog(@"bye.");
    }
    return 0;
}

