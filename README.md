# Megatron-MSL-Compiler

A custom Metal Shading Language (MSL) compiler written in Objective-C.

## Overview

Megatron is a lightweight compiler that translates a simplified shader language into Metal Shading Language (MSL).

Pipeline:

* Lexer → Tokenizes input
* Parser → Builds AST
* AST → Intermediate representation
* Codegen → Emits Metal shader code

## Example

Input:

```
out = a + b
```

Output:

```metal
kernel void compute(...) {
    out[id] = (a + b);
}
```

## Roadmap

* [ ] Operator precedence
* [ ] Type system (float, float2, etc.)
* [ ] File input support
* [ ] Metal runtime execution
* [ ] IR optimization layer

## Build

```
clang *.m -framework Foundation -o megatron
./megatron
```

## Vision

An alternative Metal shader compiler and experimental GPU language toolchain.
