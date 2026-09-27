# Hierarchical MUX

This folder contains **hierarchical Multiplexer (MUX) implementations**, where larger MUXes are constructed by combining smaller, previously designed MUX modules.

The main purpose of hierarchical design is to demonstrate how a complex digital circuit can be built by **reusing smaller, verified building blocks** instead of designing everything as one large module.

The current implementations include:

* **16:1 MUX using 4:1 MUXes**
* **32:1 MUX using 8:1 MUXes**
* Dedicated testbenches for both designs

---

# 1. What is Hierarchical MUX Design?

A hierarchical MUX is a larger MUX constructed using smaller MUX modules.

For example, instead of directly designing a 16:1 MUX, we can construct it using:

```text
4 × 4:1 MUX
      +
1 × 4:1 MUX
      ↓
   16:1 MUX
```

Similarly, a 32:1 MUX can be constructed using:

```text
4 × 8:1 MUX
      +
1 × 4:1 MUX
      ↓
   32:1 MUX
```

This is called **hierarchical design** because the larger module is built from lower-level modules.

---

# 2. Why Use Hierarchical Design?

Suppose we already have a verified 4:1 MUX.

Instead of writing a completely new 16:1 MUX from scratch, we can reuse the 4:1 MUX multiple times.

This provides several advantages:

* Module reuse
* Reduced code duplication
* Easier verification
* Better code organization
* Easier debugging
* Scalable architecture
* Clear hardware hierarchy
* Easier maintenance

The basic idea is:

```text
Small Verified Module
          ↓
       Reuse
          ↓
   Larger Module
          ↓
       Reuse
          ↓
   Even Larger Module
```

This is an important concept in real RTL design.

---

# 3. Directory Structure

```text
Hierarchical_MUX/
├── 16by1_hier.v
├── 16by1_hier_tb.v
├── hier_32by1.v
├── hier_32by1_tb.v
└── README.md
```

| File              | Description                                        |
| ----------------- | -------------------------------------------------- |
| `16by1_hier.v`    | Hierarchical 16:1 MUX implementation               |
| `16by1_hier_tb.v` | Testbench for the 16:1 hierarchical MUX            |
| `hier_32by1.v`    | Hierarchical 32:1 MUX implementation               |
| `hier_32by1_tb.v` | Testbench for the 32:1 hierarchical MUX            |
| `README.md`       | Documentation for hierarchical MUX implementations |

---

# 4. 16:1 MUX Using 4:1 MUXes

The first implementation constructs a **16:1 MUX using 4:1 MUX modules**.

A 16:1 MUX has:

* 16 data inputs
* 4 select lines
* 1 output

```text
I0  ─────┐
I1  ─────┤
I2  ─────┤──► 4:1 ───► W0 ──┐
I3  ─────┘                  │
                             │
I4  ─────┐                  │
I5  ─────┤                  │
I6  ─────┤──► 4:1 ───► W1 ──┤
I7  ─────┘                  │
                             │
I8  ─────┐                  ├──► 4:1 ───► Y
I9  ─────┤                  │
I10 ─────┤──► 4:1 ───► W2 ──┤
I11 ─────┘                  │
                             │
I12 ─────┐                  │
I13 ─────┤                  │
I14 ─────┤──► 4:1 ───► W3 ──┘
I15 ─────┘
```

Therefore:

```text
4 × 4:1 MUX
      +
1 × 4:1 MUX
      ↓
   16:1 MUX
```

---

# 5. Select-Line Operation in the 16:1 MUX

The 16 inputs are divided into four groups:

```text
Group 0 → I0  - I3
Group 1 → I4  - I7
Group 2 → I8  - I11
Group 3 → I12 - I15
```

The four select bits are divided into two groups:

```text
S[1:0] → Select input within each group

S[3:2] → Select which group reaches the output
```

For example:

### First Stage

If:

```text
S[1:0] = 10
```

then every first-stage 4:1 MUX selects its third input.

Therefore:

```text
Group 0 → I2
Group 1 → I6
Group 2 → I10
Group 3 → I14
```

The outputs become:

```text
W0 = I2
W1 = I6
W2 = I10
W3 = I14
```

### Second Stage

Then:

```text
S[3:2]
```

selects one of:

```text
W0
W1
W2
W3
```

Therefore, the final output is the required input.

---

# 6. Example Selection

Suppose:

```text
S[3:0] = 0110
```

Separate the select bits:

```text
S[3:2] = 01
S[1:0] = 10
```

First stage:

```text
S[1:0] = 10
```

selects:

```text
I2
I6
I10
I14
```

Second stage:

```text
S[3:2] = 01
```

selects the second group output:

```text
W1 = I6
```

Therefore:

```text
Y = I6
```

This illustrates how the hierarchical MUX performs the same function as a direct 16:1 MUX.

---

# 7. 32:1 MUX Using 8:1 MUXes

The second implementation constructs a **32:1 MUX using 8:1 MUXes**.

A 32:1 MUX has:

* 32 data inputs
* 5 select lines
* 1 output

The architecture is:

```text
Inputs 0-7    ──► 8:1 ──► W0 ──┐
Inputs 8-15   ──► 8:1 ──► W1 ──┤
Inputs 16-23  ──► 8:1 ──► W2 ──┤──► 4:1 ───► Y
Inputs 24-31  ──► 8:1 ──► W3 ──┘
```

Therefore:

```text
4 × 8:1 MUX
      +
1 × 4:1 MUX
      ↓
   32:1 MUX
```

---

# 8. Select-Line Operation in the 32:1 MUX

The 32 inputs are divided into four groups:

```text
Group 0 → I0  - I7
Group 1 → I8  - I15
Group 2 → I16 - I23
Group 3 → I24 - I31
```

The five select bits are divided as:

```text
S[2:0] → Select input within each 8:1 MUX

S[4:3] → Select one of the four groups
```

For example:

```text
S[2:0] = 101
```

causes every first-stage 8:1 MUX to select its sixth input.

Therefore:

```text
W0 = I5
W1 = I13
W2 = I21
W3 = I29
```

Then:

```text
S[4:3]
```

selects one of these four intermediate outputs.

---

# 9. Example Selection

Suppose:

```text
S[4:0] = 10101
```

Separate the select bits:

```text
S[4:3] = 10
S[2:0] = 101
```

First stage:

```text
S[2:0] = 101
```

selects:

```text
I5
I13
I21
I29
```

Second stage:

```text
S[4:3] = 10
```

selects the third intermediate output:

```text
W2 = I21
```

Therefore:

```text
Y = I21
```

---

# 10. General Hierarchical MUX Concept

The same principle can be extended to much larger MUXes.

For example:

```text
4:1
 │
 ├──► 16:1
 │
 └──► 64:1
```

or:

```text
8:1
 │
 ├──► 64:1
 │
 └──► 512:1
```

The exact architecture depends on which smaller MUX blocks are available.

The general idea is:

```text
                 Large MUX
                    │
             ┌──────┴──────┐
             │             │
          Smaller        Smaller
           MUXes           MUXes
             │
             ▼
        Intermediate
          outputs
             │
             ▼
        Final MUX stage
```

---

# 11. Other Hierarchical MUX Implementations to Practice

The current folder contains:

```text
16:1 using 4:1
32:1 using 8:1
```

There are many other useful hierarchical architectures that can be practiced.

---

## 11.1 8:1 Using 2:1 MUXes

Construct an 8:1 MUX using only 2:1 MUXes.

An 8:1 MUX requires:

$$
8-1 = 7
$$

2:1 MUXes.

The architecture is a tree:

```text
I0 ──┐
     ├── 2:1 ──┐
I1 ──┘         │
               ├── 2:1 ──┐
I2 ──┐         │         │
     ├── 2:1 ──┘         │
I3 ──┘                   │
                         ├── 2:1 ──► Y
I4 ──┐                   │
     ├── 2:1 ──┐         │
I5 ──┘         │         │
               ├── 2:1 ──┘
I6 ──┐         │
     ├── 2:1 ──┘
I7 ──┘
```

This is an important hierarchical structure to practice.

---

# 12. 16:1 Using 2:1 MUXes

A 16:1 MUX can also be constructed entirely from 2:1 MUXes.

The number of 2:1 MUXes required is:

$$
16-1 = 15
$$

The architecture contains four stages:

```text
Stage 1 → 8 × 2:1
Stage 2 → 4 × 2:1
Stage 3 → 2 × 2:1
Stage 4 → 1 × 2:1
```

```text
16 inputs
   │
   ▼
8 × 2:1
   │
   ▼
4 × 2:1
   │
   ▼
2 × 2:1
   │
   ▼
1 × 2:1
   │
   ▼
Output
```

This is a classic **MUX tree**.

---

# 13. 32:1 Using 2:1 MUXes

Similarly, a 32:1 MUX can be constructed using:

$$
32-1 = 31
$$

2:1 MUXes.

The stages are:

```text
Stage 1 → 16 × 2:1
Stage 2 → 8 × 2:1
Stage 3 → 4 × 2:1
Stage 4 → 2 × 2:1
Stage 5 → 1 × 2:1
```

This demonstrates how a large MUX can be recursively constructed from a single basic building block.

---

# 14. Mixed-Size Hierarchical MUX

The smaller MUXes do not necessarily have to be identical.

For example, a 32:1 MUX can be constructed using a combination of:

```text
2:1
4:1
8:1
```

MUXes.

One possible architecture is:

```text
32 inputs
   │
   ▼
4 × 8:1
   │
   ▼
1 × 4:1
   │
   ▼
Output
```

Another architecture could use several levels of 2:1 and 4:1 MUXes.

This is useful for understanding that there can be **multiple valid structural implementations of the same logical function**.

---

# 15. Recursive Hierarchical MUX

A parameterized MUX can be recursively constructed from smaller MUXes.

Conceptually:

```text
N:1 MUX
   │
   ├── Smaller MUX
   ├── Smaller MUX
   ├── Smaller MUX
   └── Smaller MUX
          │
          ▼
      Final MUX
```

For example:

```text
16:1
 ↓
4 × 4:1
 ↓
1 × 4:1
```

This approach can be combined with SystemVerilog parameters and `generate` constructs to create reusable architectures.

---

# 16. Hierarchical MUX Using Different Basic Blocks

A larger MUX can also be constructed from different types of previously designed blocks.

For example:

```text
4:1 MUX
   +
2:1 MUX
   +
4:1 MUX
   ↓
Larger Selection Network
```

This is useful for practicing structural RTL and understanding how modules can be composed into larger datapaths.

---

# 17. Hierarchical MUX Using Decoder Blocks

Another architecture is to combine:

```text
Decoder
+
Selection MUX / Logic
```

Conceptually:

```text
              Select
                │
                ▼
             Decoder
                │
       ┌────────┼────────┐
       ▼        ▼        ▼
      E0       E1       E2 ...
       │        │        │
       └────────┴────────┘
                │
                ▼
          Selection Logic
                │
                ▼
                Y
```

This is useful for understanding how selection networks can be constructed from other combinational building blocks.

---

# 18. Hierarchical Bus MUX

The same hierarchical concept can be applied to **multi-bit buses**.

For example:

```text
4 × 32-bit inputs
        │
        ▼
   Hierarchical
      MUX
        │
        ▼
   32-bit output
```

Instead of selecting a single bit, each MUX stage selects an entire bus.

This is particularly important in processor datapaths.

---

# 19. Hierarchical MUX Using Arrays

SystemVerilog arrays can be used to organize intermediate signals.

Conceptually:

```text
input_data[0]
input_data[1]
...
input_data[N-1]

        │
        ▼
   First-stage MUXes
        │
        ▼
 intermediate[0]
 intermediate[1]
 ...
 intermediate[M-1]
        │
        ▼
    Final MUX
        │
        ▼
        Y
```

This provides useful practice with:

* Packed arrays
* Unpacked arrays
* Generate blocks
* Parameterized module instantiation

---

# 20. Hierarchical MUX Using `generate`

Instead of manually instantiating every smaller MUX, a `generate` loop can be used.

Conceptually:

```text
parameter N

      │
      ▼

generate
    for (...)
        instantiate MUX
endgenerate
```

This is especially useful when building large scalable MUX structures.

It allows the same architecture to be reused for different sizes.

---

# 21. Hierarchical Implementation Comparison

| Architecture     | Building Block              | Example                   |
| ---------------- | --------------------------- | ------------------------- |
| Simple Hierarchy | Same MUX size               | 16:1 from 4:1             |
| Simple Hierarchy | Same MUX size               | 32:1 from 8:1             |
| MUX Tree         | 2:1 MUX                     | 8:1, 16:1, 32:1           |
| Mixed Hierarchy  | Different MUX sizes         | 32:1 from 2:1 + 4:1 + 8:1 |
| Recursive        | Smaller MUX recursively     | N:1 from smaller MUXes    |
| Generate-Based   | Parameterized MUX instances | Scalable N:1              |
| Decoder-Based    | Decoder + selection logic   | Large selection networks  |
| Bus Hierarchy    | Multi-bit MUX blocks        | 32-bit/64-bit datapaths   |

---

# 22. Advantages of Hierarchical MUX Design

### 1. Reusability

A verified MUX module can be reused multiple times.

### 2. Modularity

Each block performs a clearly defined function.

### 3. Easier Verification

Smaller modules can be verified independently before being integrated.

### 4. Easier Debugging

If a large MUX fails, intermediate signals can be inspected.

### 5. Scalability

Larger circuits can be created from existing modules.

### 6. Better Design Organization

The RTL structure closely represents the hardware hierarchy.

### 7. Reduced Code Duplication

The same MUX implementation does not have to be rewritten repeatedly.

---

# 23. Verification

Each hierarchical MUX has a dedicated testbench.

```text
16by1_hier.v
      │
      └──► 16by1_hier_tb.v
```

```text
hier_32by1.v
      │
      └──► hier_32by1_tb.v
```

Verification should check:

* Every possible select combination
* Correct selection of every input
* Correct intermediate-stage outputs
* Correct final output
* Boundary input combinations
* Different input data patterns

For the 16:1 MUX:

```text
0000 → I0
0001 → I1
0010 → I2
...
1111 → I15
```

For the 32:1 MUX:

```text
00000 → I0
00001 → I1
...
11111 → I31
```

Testing every select combination provides exhaustive functional coverage for these fixed-size MUXes.

---

# 24. Important RTL Concepts Practiced

This folder provides practice in:

### Structural RTL

* Module instantiation
* Port connections
* Intermediate wires
* Hierarchical module composition

### MUX Architecture

* Multi-stage selection
* MUX trees
* Group selection
* Intermediate outputs
* Cascaded MUXes

### SystemVerilog / Verilog

* Module reuse
* Generate constructs
* Parameters
* Arrays
* Hierarchical design

### Verification

* Testbench development
* Exhaustive testing
* Intermediate-signal debugging
* Waveform analysis

---

# 25. Hierarchical MUX Learning Progression

A useful progression for practicing hierarchical MUX design is:

```text
2:1 MUX
   ↓
4:1 MUX
   ↓
8:1 using 2:1 MUXes
   ↓
16:1 using 4:1 MUXes
   ↓
32:1 using 8:1 MUXes
   ↓
16:1 using only 2:1 MUXes
   ↓
32:1 using only 2:1 MUXes
   ↓
Mixed-size hierarchical MUX
   ↓
Parameterized hierarchical MUX
   ↓
Generate-based hierarchical MUX
   ↓
Hierarchical bus MUX
```

---

# 26. Key Takeaways

* A hierarchical MUX is a **larger MUX constructed from smaller MUX modules**.
* Hierarchical design encourages **module reuse and modularity**.
* A 16:1 MUX can be built using four 4:1 MUXes followed by another 4:1 MUX.
* A 32:1 MUX can be built using four 8:1 MUXes followed by a 4:1 MUX.
* Large MUXes can also be constructed entirely from 2:1 MUXes.
* Different hierarchical architectures can implement the same logical function.
* `generate` constructs can be used to make hierarchical MUX designs scalable.
* The same concept can be extended from single-bit MUXes to multi-bit bus MUXes.

The key design principle demonstrated in this folder is:

> **Build large and complex hardware by reusing smaller, verified hardware blocks.**

