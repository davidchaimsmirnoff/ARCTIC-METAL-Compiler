
#import "Codegen.h"

@implementation MCodegen

- (NSString *)genExpr:(MNode *)node {
    if ([node isKindOfClass:[MBinOp class]]) {
        MBinOp *b = (MBinOp *)node;
        return [NSString stringWithFormat:@"(%@ %@ %@)",
                [self genExpr:b.left],
                b.op,
                [self genExpr:b.right]];
    }

    if ([node isKindOfClass:[MVar class]]) {
        return ((MVar *)node).name;
    }

    return @"";
}

- (NSString *)generate:(MAssign *)node {

    NSString *expr = [self genExpr:node.value];

    return [NSString stringWithFormat:
@"#include <metal_stdlib>\n"
"using namespace metal;\n\n"
"kernel void compute(device float* out [[buffer(0)]],\n"
"                    device float* a [[buffer(1)]],\n"
"                    device float* b [[buffer(2)]],\n"
"                    uint id [[thread_position_in_grid]]) {\n"
"    out[id] = %@;\n"
"}\n", expr];
}

@end
