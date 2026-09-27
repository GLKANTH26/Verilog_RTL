# Parameterized MUX

This folder contains **parameterized Multiplexer (MUX) implementations** designed to make the same RTL module reusable for different numbers of inputs and different data widths.

Unlike a fixed-size MUX, where the number of inputs and width are hard-coded, a parameterized MUX allows these properties to be controlled using **parameters**.

The current implementation focuses on a **parameterized bus MUX**, where an entire multi-bit data bus is selected rather than only a single bit.

---

# 1. What is a Parameterized MUX?

A parameterized MUX is a MUX whose architecture can be configured using parameters.

For example, instead of writing separate modules for:

```text
4 × 8-bit MUX
8 × 8-bit MUX
16 × 8-bit MUX
32 × 8-bit MUX
```

we can create one reusable parameterized module.

Conceptually:

```text
              ┌─────────────────────┐
Input 0 ─────►│                     │
Input 1 ─────►│                     │
Input 2 ─────►│  Parameterized MUX  ├────► Output
   ...        │                     │
Input N-1 ───►│                     │
              └─────────────────────┘
                       ▲
                       │
                     Select
```

The same RTL can therefore be configured for different applications.

---

# 2. Why Parameterization is Important

Consider designing a MUX for a processor datapath.

Initially, you may need:

```text
4 inputs × 8 bits
```

Later, the same architecture may require:

```text
8 inputs × 32 bits
```

or:

```text
16 inputs × 64 bits
```

Without parameterization, separate modules would have to be written.

With parameterization:

```text
             Parameters
                 │
        ┌────────┴────────┐
        │                 │
   Number of inputs    Data width
        │                 │
        └────────┬────────┘
                 ▼
        Parameterized MUX
```

The same RTL can be reused.

---

# 3. Directory Structure

```text
Parameterized_MUX/
├── n_bit_bus.v
├── n_bit_bus_tb.v
└── README.md
```

| File             | Description                             |
| ---------------- | --------------------------------------- |
| `n_bit_bus.v`    | Parameterized bus MUX implementation    |
| `n_bit_bus_tb.v` | Testbench for the parameterized MUX     |
| `README.md`      | Documentation for the parameterized MUX |

---

# 4. Parameterized Bus MUX

The current design represents a MUX where each input is a **multi-bit bus**.

For example, consider:

```text
N = 4
WIDTH = 8
```

The MUX has:

* 4 input buses
* Each input is 8 bits wide
* 2 select bits
* 1 output bus of 8 bits

```text
Input 0 ── 8 bits ──┐
Input 1 ── 8 bits ──┤
Input 2 ── 8 bits ──┤──► MUX ───► 8-bit Output
Input 3 ── 8 bits ──┘
                       ▲
                       │
                    Select
```

The select signal chooses **one complete bus**.

For example:

```text
sel = 2'b00 → output = input[0]

sel = 2'b01 → output = input[1]

sel = 2'b10 → output = input[2]

sel = 2'b11 → output = input[3]
```

---

# 5. Parameters

A parameterized MUX can be controlled using parameters such as:

```text
N     → Number of input buses
WIDTH → Width of each input bus
```

For example:

```text
N = 4
WIDTH = 8
```

means:

```text
4 input buses
×
8 bits per bus
```

Therefore:

```text
Input:
4 × 8-bit buses

Output:
1 × 8-bit bus
```

---

# 6. Select Width

For `N` input choices, the number of select bits required is:

$$
S = \lceil \log_2(N) \rceil
$$

For example:

|  N | Required Select Width |
| -: | --------------------: |
|  2 |                     1 |
|  4 |                     2 |
|  8 |                     3 |
| 16 |                     4 |
| 32 |                     5 |
| 64 |                     6 |

In SystemVerilog, this can be represented using:

```text
$clog2(N)
```

For example:

```text
N = 16

$clog2(16) = 4
```

Therefore, 4 select bits are required.

---

# 7. General Architecture

A parameterized N-to-1 bus MUX can be viewed as:

```text
                 ┌───────────────────┐
Input Bus 0 ────►│                   │
Input Bus 1 ────►│                   │
Input Bus 2 ────►│                   │
      ...        │ Parameterized MUX │────► Output Bus
Input Bus N-1 ──►│                   │
                 └───────────────────┘
                          ▲
                          │
                        Select
```

Each input has the same width.

If:

```text
WIDTH = 32
```

then every input bus and the output bus are 32 bits wide.

---

# 8. Example: 4 × 8-bit Parameterized MUX

Consider:

```text
N = 4
WIDTH = 8
```

The inputs can be represented as:

```text
Input 0 → 8 bits
Input 1 → 8 bits
Input 2 → 8 bits
Input 3 → 8 bits
```

The selection operation is:

```text
┌─────────┬───────────────┐
│  Select │    Output     │
├─────────┼───────────────┤
│   00    │   Input 0     │
│   01    │   Input 1     │
│   10    │   Input 2     │
│   11    │   Input 3     │
└─────────┴───────────────┘
```

The important point is that the MUX selects the **entire 8-bit bus**, not just one bit.

---

# 9. Example: 8 × 16-bit MUX

The same design can be configured as:

```text
N = 8
WIDTH = 16
```

Now:

```text
8 input buses
×
16 bits per bus
```

The select width becomes:

$$
\log_2(8)=3
$$

Therefore:

```text
Select → 3 bits

Output → 16 bits
```

The same module can perform:

```text
Input 0 → Output
Input 1 → Output
...
Input 7 → Output
```

No new MUX module is required.

---

# 10. Example: 16 × 32-bit MUX

Another configuration could be:

```text
N = 16
WIDTH = 32
```

Therefore:

```text
16 input buses
32 bits per bus
4 select bits
1 output bus of 32 bits
```

Conceptually:

```text
Input 0  ── 32 bits ──┐
Input 1  ── 32 bits ──┤
Input 2  ── 32 bits ──┤
...                    ├──► Parameterized MUX ───► 32-bit Output
Input 15 ── 32 bits ──┘
```

---

# 11. Why Bus MUXes are Important

Real digital systems rarely operate only on individual bits.

Processors and digital systems commonly work with:

* 8-bit data
* 16-bit data
* 32-bit data
* 64-bit data
* Larger buses

For example, a processor datapath may need to select between several 32-bit sources:

```text
ALU Result ────────┐
                   │
Register Data ─────┤
                   │
Immediate ─────────┼──► 32-bit MUX ───► Datapath
                   │
Memory Data ───────┤
                   │
                   ┘
```

A parameterized bus MUX is therefore much more reusable than a single-bit MUX.

---

# 12. Parameterization vs Fixed-Size MUX

### Fixed-Size MUX

A fixed-size design might specifically describe:

```text
4:1 MUX
```

and its ports are fixed accordingly.

If we later need an 8:1 MUX, another module would have to be written.

### Parameterized MUX

A parameterized design describes the general structure:

```text
N:1 MUX
```

and allows `N` to be changed.

Similarly, the bus width can be changed.

```text
Fixed:

4 × 8-bit

Parameterized:

N × WIDTH-bit
```

This is the main advantage of parameterized RTL.

---

# 13. Parameterization and Reusability

A parameterized module can be reused in different designs.

For example:

```text
Design A
N = 4
WIDTH = 8
      │
      ▼
Parameterized MUX
```

```text
Design B
N = 8
WIDTH = 32
      │
      ▼
Parameterized MUX
```

```text
Design C
N = 16
WIDTH = 64
      │
      ▼
Parameterized MUX
```

The underlying RTL remains the same.

---

# 14. Other Parameterized MUX Implementations to Practice

The current implementation focuses on a parameterized bus MUX.

There are several other useful parameterized MUX architectures that can be practiced.

---

## 14.1 Parameterized Single-Bit MUX

Create a general:

```text
N:1
```

single-bit MUX.

For example:

```text
N = 4 → 4:1 MUX

N = 8 → 8:1 MUX

N = 16 → 16:1 MUX

N = 32 → 32:1 MUX
```

The same module should support different values of `N`.

---

## 14.2 Parameterized Bus MUX

Generalize the design in two dimensions:

```text
N     → Number of inputs
WIDTH → Width of each input
```

Therefore:

$$
N \times WIDTH
$$

becomes the general architecture.

Examples:

```text
4 × 8
8 × 16
16 × 32
32 × 64
```

---

## 14.3 Parameterized MUX Using `case`

The number of inputs can be parameterized while the selection logic is described using a `case` statement.

This is useful for practicing:

* Parameters
* `$clog2`
* Combinational `case`
* Scalable RTL

---

## 14.4 Parameterized MUX Using Conditional Operator

Build a parameterized MUX using conditional expressions.

This can provide a compact RTL implementation.

---

## 14.5 Parameterized MUX Using `if-else`

Use a parameterized number of inputs while describing the selection behavior using procedural combinational logic.

This is useful for understanding how synthesis handles scalable procedural descriptions.

---

# 15. Parameterized MUX Using Arrays

A particularly useful SystemVerilog approach is to represent the inputs as an array.

Conceptually:

```text
input_data[0]
input_data[1]
input_data[2]
...
input_data[N-1]
```

Then the selected input can be routed to the output based on the select index.

```text
                    Select
                      │
                      ▼
input_data[0] ──┐
input_data[1] ──┤
input_data[2] ──┤
      ...       ├──► Selection ───► Output
input_data[N-1] ─┘
```

This is a useful SystemVerilog practice because arrays make parameterized designs much easier to express.

---

# 16. Parameterized MUX Using Generate

A parameterized MUX can also be constructed structurally using `generate`.

Conceptually:

```text
parameter N
     │
     ▼
generate loop
     │
     ├── MUX instance
     ├── MUX instance
     ├── MUX instance
     └── ...
```

This approach is useful when the objective is to generate an actual structural hierarchy rather than relying only on behavioral RTL.

---

# 17. Parameterized MUX Tree

A parameterized MUX can be constructed as a tree of 2:1 MUXes.

For example:

```text
N = 8
```

can produce:

```text
8 × inputs
     ↓
4 × 2:1
     ↓
2 × 2:1
     ↓
1 × 2:1
     ↓
Output
```

The number of MUXes required for an N-input binary MUX tree is:

$$
N-1
$$

For example:

| Inputs | 2:1 MUXes Required |
| -----: | -----------------: |
|      2 |                  1 |
|      4 |                  3 |
|      8 |                  7 |
|     16 |                 15 |
|     32 |                 31 |

This is an excellent exercise for combining **parameters + generate loops + hierarchical structure**.

---

# 18. Parameterized Hierarchical MUX

A more advanced implementation can combine this folder's concepts with the hierarchical MUX concepts.

For example:

```text
parameter N
      │
      ▼
Determine number of groups
      │
      ▼
Instantiate smaller MUXes
      │
      ▼
Generate intermediate outputs
      │
      ▼
Final selection stage
```

This allows the hierarchy itself to scale with the parameter values.

---

# 19. Parameterized MUX with Different Architectures

The same parameterized functionality can be implemented using different internal architectures.

For example:

```text
                 Parameterized N:1 MUX
                           │
          ┌────────────────┼────────────────┐
          │                │                │
          ▼                ▼                ▼
      Direct RTL       MUX Tree       Hierarchical
          │                │                │
       case/if         2:1 MUXes      Smaller MUXes
```

All three can provide the same logical behavior while having different internal structures.

This is important because **RTL functionality and hardware architecture are related but not necessarily identical**.

---

# 20. Parameterized One-Hot MUX

Instead of using binary select signals, a parameterized MUX can use one-hot selection.

For `N` inputs:

```text
Select width = N
```

Example for 8 inputs:

```text
00000001 → Input 0
00000010 → Input 1
00000100 → Input 2
00001000 → Input 3
00010000 → Input 4
00100000 → Input 5
01000000 → Input 6
10000000 → Input 7
```

This is useful for practicing parameterized control architectures.

---

# 21. Parameterized Decoder-Based MUX

Another advanced implementation is:

```text
Parameterized Decoder
        +
Selection Logic
        ↓
Parameterized MUX
```

Conceptually:

```text
             Select
                │
                ▼
        Parameterized
            Decoder
                │
        ┌───────┼───────┐
        ▼       ▼       ▼
       E0      E1      E2 ... EN
        │       │       │
        └───────┴───────┘
                │
                ▼
          Output Selection
                │
                ▼
                Y
```

This is useful for connecting parameterized MUX design with decoder-based architectures.

---

# 22. Parameterized MUX for Datapaths

A major real-world application is datapath selection.

For example, suppose a processor needs to select one of several 32-bit sources:

```text
Source 0 ── 32 bits ──┐
Source 1 ── 32 bits ──┤
Source 2 ── 32 bits ──┤
Source 3 ── 32 bits ──┤
Source 4 ── 32 bits ──┤──► Parameterized MUX ──► Datapath
Source 5 ── 32 bits ──┤
Source 6 ── 32 bits ──┤
Source 7 ── 32 bits ──┘
```

Changing:

```text
N
WIDTH
```

allows the same basic module to be reused for different datapath configurations.

---

# 23. Verification

The parameterized MUX should be verified for multiple parameter configurations.

For example:

```text
N = 4,  WIDTH = 8
N = 8,  WIDTH = 8
N = 8,  WIDTH = 16
N = 16, WIDTH = 32
```

For each configuration, verification should check:

1. Every valid select value.
2. Correct selection of the corresponding input.
3. Correct selection of every bit of the bus.
4. Different input data patterns.
5. Boundary configurations.
6. Different parameter values.

For an N-input MUX:

```text
sel = 0       → input[0]
sel = 1       → input[1]
...
sel = N-1     → input[N-1]
```

The testbench should ensure that:

$$
Y = Input[Select]
$$

for every valid selection.

---

# 24. Important Edge Case: Non-Power-of-2 Inputs

One important issue arises when `N` is **not a power of 2**.

For example:

```text
N = 5
```

Then:

$$
\lceil \log_2(5) \rceil = 3
$$

Therefore, 3 select bits are required.

But 3 bits provide:

$$
2^3 = 8
$$

possible select values:

```text
000 → 0
001 → 1
010 → 2
011 → 3
100 → 4
101 → 5
110 → 6
111 → 7
```

Only `0` through `4` are valid.

Therefore:

```text
0 - 4 → Valid
5 - 7 → Invalid / unused
```

A robust parameterized MUX should define what happens for these invalid selections.

Possible approaches include:

* Drive output to zero.
* Drive a known default value.
* Use a `default` branch.
* Assert that the select value is valid.

This is an important consideration when designing reusable RTL.

---

# 25. Parameterization Edge Cases

When creating reusable parameterized RTL, several edge cases should be considered.

### Number of Inputs

```text
N >= 2
```

should generally be enforced for a meaningful MUX.

### Width

```text
WIDTH >= 1
```

should be maintained.

### Non-Power-of-2 N

Handle unused select combinations explicitly.

### Select Width

Use:

```text
$clog2(N)
```

appropriately.

### Simulation vs Synthesis

The parameterized design should remain:

* Synthesizable
* Deterministic
* Combinational
* Free from unintended latches

---

# 26. Advantages of Parameterized MUX Design

### Reusability

One module can support many configurations.

### Scalability

Changing a parameter changes the design size without rewriting the architecture.

### Maintainability

A single source of RTL is easier to maintain.

### Reduced Code Duplication

Separate modules for every width and input count are unnecessary.

### Design Portability

The same parameterized module can be reused across different projects.

### Better RTL Abstraction

The designer describes the general hardware structure rather than a single fixed instance.

---

# 27. Parameterized vs Hierarchical MUX

| Feature      | Hierarchical MUX             | Parameterized MUX                 |
| ------------ | ---------------------------- | --------------------------------- |
| Main idea    | Reuse smaller modules        | Configure design using parameters |
| Size         | Usually fixed by hierarchy   | Can be scalable                   |
| Module reuse | Yes                          | Yes                               |
| Parameters   | Optional                     | Core concept                      |
| Generate     | Optional                     | Often useful                      |
| Example      | 16:1 from 4:1                | N:1 with configurable N           |
| Bus width    | Can be fixed or configurable | Easily configurable               |
| Scalability  | Depends on architecture      | High                              |

These two concepts can also be combined.

For example:

```text
Parameterized
      +
Hierarchical
      ↓
Parameterized Hierarchical MUX
```

---

# 28. Concepts Practiced

This folder provides practice in:

### SystemVerilog / RTL

* Parameters
* `parameter`
* `$clog2`
* Arrays
* Bus handling
* Combinational logic
* Scalable module design

### Digital Design

* MUX operation
* Select logic
* Bus selection
* Datapath selection
* Multi-input selection

### Structural Design

* Generate loops
* Hierarchical composition
* MUX trees
* Intermediate signals
* Reusable modules

### Verification

* Parameterized testbenches
* Multiple configurations
* Exhaustive select testing
* Boundary testing
* Invalid-select testing

---

# 29. Recommended Practice Progression

A useful progression for parameterized MUX practice is:

```text
Fixed 2:1 MUX
      ↓
Fixed 4:1 MUX
      ↓
Fixed 8:1 MUX
      ↓
Parameterized Single-Bit MUX
      ↓
Parameterized Bus MUX
      ↓
Parameterized MUX using case
      ↓
Parameterized MUX using arrays
      ↓
Parameterized MUX using generate
      ↓
Parameterized MUX Tree
      ↓
Parameterized Hierarchical MUX
      ↓
Parameterized One-Hot MUX
      ↓
Parameterized Decoder-Based MUX
```

---

# 30. Key Takeaways

* A parameterized MUX allows the **number of inputs and/or data width to be configured** without rewriting the module.
* `N` determines the number of input choices.
* `WIDTH` determines the width of each input bus.
* The select width is generally:

$$
\boxed{S=\lceil\log_2(N)\rceil}
$$

* Parameterized bus MUXes are highly useful for processor datapaths and other bus-based digital systems.
* `$clog2(N)` is commonly used to determine the required select width.
* Non-power-of-2 values of `N` require careful handling of unused select combinations.
* Parameterization can be combined with:

  * Hierarchical design
  * Generate loops
  * MUX trees
  * Arrays
  * One-hot selection
  * Decoder-based architectures

The central idea of this folder is:

> **Write the MUX once, parameterize it, and reuse it for different numbers of inputs and different data widths.**

