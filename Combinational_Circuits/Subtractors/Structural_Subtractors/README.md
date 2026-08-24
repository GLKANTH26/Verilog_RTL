# Structural Subtractors

This directory contains a **structural Verilog implementation of a Full Subtractor using Half Subtractor modules**.

The design demonstrates **hierarchical and reusable RTL design**, where a larger combinational circuit is constructed by instantiating previously developed smaller modules.

---

## 📂 Directory Structure

```text
Structural_Subtractors/
│
├── full_sub_using_half.v
├── full_using_half_tb.v
└── README.md
```

---

# 1. Full Subtractor Using Half Subtractors

A Full Subtractor performs the subtraction:

```text
A - B - Bin
```

where:

* `A` — Minuend
* `B` — Subtrahend
* `Bin` — Borrow-in

and produces:

* `Difference`
* `Borrow-out`

Instead of implementing the Full Subtractor directly using Boolean equations, this design constructs it using **two Half Subtractors and an OR gate**.

---

## 2. Structural Architecture

The implementation follows the same hierarchical principle used for constructing a Full Adder from Half Adders.

```text
                  ┌─────────────────┐
        a ───────►│                 │
                  │ Half Subtractor │────► w_diff
        b ───────►│      HS₁        │────► w_borrow1
                  └────────┬────────┘
                           │
                           │ w_diff
                           ▼
                  ┌─────────────────┐
   borrow-in ────►│                 │
                  │ Half Subtractor │────► Difference
       w_diff ───►│      HS₂        │────► w_borrow2
                  └────────┬────────┘
                           │
                           │
                  w_borrow1 ───┐
                               ▼
                              OR ─────► Borrow-out
                               ▲
                  w_borrow2 ───┘
```

The first Half Subtractor performs:

```text
w_diff    = a ⊕ b
w_borrow1 = a' · b
```

The second Half Subtractor performs:

```text
Difference = w_diff ⊕ Bin
w_borrow2  = w_diff' · Bin
```

The two borrow outputs are combined using an OR gate:

```text
Borrow-out = w_borrow1 + w_borrow2
```

Therefore, the resulting Full Subtractor implements:

```text
Difference = a ⊕ b ⊕ Bin
```

and:

```text
Borrow-out = a'b + (a ⊕ b)'Bin
```

---

# 3. Module Instantiation

The design reuses the previously developed Half Subtractor module rather than redefining its logic.

Conceptually:

```verilog
half_sub hs1(...);
half_sub hs2(...);
or       o1(...);
```

The two Half Subtractor instances operate sequentially from the perspective of the borrow chain:

```text
HS₁
 │
 ├── Difference ──► HS₂
 │
 └── Borrow₁ ─────┐
                  │
                  ▼
                 OR ──► Borrow-out
                  ▲
 ┌── Borrow₂ ─────┘
 │
HS₂
```

This demonstrates **module reuse and hierarchical hardware construction**.

---

# 4. Design Hierarchy

The complete design can be viewed as:

```text
Half Subtractor
       │
       ├──────────────┐
       │              │
       ▼              │
Half Subtractor       │
       │              │
       └──────┬───────┘
              ▼
             OR
              │
              ▼
         Full Subtractor
```

At the implementation level:

```text
Full Subtractor
      │
      ├── Half Subtractor 1
      │      ├── Difference₁
      │      └── Borrow₁
      │
      ├── Half Subtractor 2
      │      ├── Difference
      │      └── Borrow₂
      │
      └── OR Gate
             └── Borrow₁ + Borrow₂
```

---

# 5. Why Structural Design?

The structural implementation demonstrates an important RTL design methodology:

> **Build complex hardware by reusing smaller, independently designed modules.**

Instead of implementing the complete Full Subtractor from scratch, the already-developed Half Subtractor is reused.

### Advantages

* **Modularity** — Each circuit has a clearly defined function.
* **Reusability** — The Half Subtractor can be used in other arithmetic circuits.
* **Maintainability** — Changes to the Half Subtractor can propagate to higher-level designs.
* **Hierarchical Design** — Complex circuits can be constructed from verified blocks.
* **Verification Reuse** — Lower-level modules can be independently verified before integration.

---

# 6. Verification

The accompanying testbench verifies the structural Full Subtractor.

A Full Subtractor has three binary inputs:

```text
a
b
Bin
```

Therefore, the testbench covers all:

```text
2³ = 8
```

possible input combinations.

### Verification Flow

```text
Half Subtractor
       │
       ▼
Structural Full Subtractor
       │
       ▼
Testbench
       │
       ▼
Simulation
   ┌───┴────┐
   ▼        ▼
Console   Waveform
Output    Analysis
```

The testbench monitors the inputs and outputs and verifies the expected Difference and Borrow-out behavior.

---

# 7. Simulation and Waveform Analysis

The testbench can use:

```verilog
$fsdbDumpvars();
```

to generate **FSDB waveform data** for signal-level analysis.

The simulation allows the internal signals to be examined, including:

* Intermediate Difference
* First Borrow
* Second Borrow
* Final Difference
* Final Borrow-out

This is particularly useful for understanding how the two Half Subtractor stages combine to produce Full Subtractor behavior.

---

# 8. Files

### `full_sub_using_half.v`

Contains the structural implementation of the Full Subtractor using:

* Two Half Subtractor instances
* One OR gate

### `full_using_half_tb.v`

Contains the testbench for functional verification of the structural Full Subtractor.

---

# 9. Concepts Covered

* Structural Verilog
* Hierarchical RTL design
* Module instantiation
* Hardware reuse
* Half Subtractor
* Full Subtractor
* Borrow propagation
* Difference generation
* Combinational circuit composition
* Gate primitives
* Testbench development
* Exhaustive single-bit verification
* FSDB waveform generation
* Functional simulation

---

## Key Design Principle

The implementation demonstrates how a larger arithmetic circuit can be constructed from smaller reusable blocks:

```text
Logic Gates
     ↓
Half Subtractor
     ↓
Two Half Subtractors
     ↓
Borrow Combination
     ↓
Full Subtractor
     ↓
Larger Subtraction Circuits
```

This structural methodology forms the foundation for building **multi-bit subtractors, Add/Subtract units, ALUs, and larger arithmetic datapaths**.

