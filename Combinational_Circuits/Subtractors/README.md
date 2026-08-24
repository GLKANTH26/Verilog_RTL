# Subtractors

This directory contains **Verilog implementations of binary subtraction circuits**, progressing from fundamental single-bit subtractors to hierarchical designs and scalable **Add/Subtract arithmetic units**.

The implementations demonstrate different approaches to constructing subtraction hardware, including **basic combinational logic, structural module composition, controlled addition/subtraction, and parameterized multi-bit arithmetic**.

---

## 📂 Directory Structure

```text
Subtractors/
│
├── Basic_Subtractors/
│   ├── half_sub.v
│   ├── half_sub_tb.v
│   ├── full_sub.v
│   ├── full_sub_tb.v
│   └── README.md
│
├── Structural_Subtractors/
│   ├── full_sub_using_half.v
│   ├── full_using_half_tb.v
│   └── README.md
│
├── Add_Subtract_Unit/
│   ├── fa_fs.v
│   ├── fa_fs_tb.v
│   ├── ha_and_hs.v
│   ├── ha_and_hs_tb.v
│   └── README.md
│
├── N_Bit_Add_Sub_Unit/
│   ├── n_bit_fa_fs.v
│   ├── n_bit_fa_fs_tb.v
│   └── README.md
│
└── README.md
```

---

# 1. Basic Subtractors

The `Basic_Subtractors` directory contains the fundamental **single-bit binary subtraction circuits**.

### Implementations

* **Half Subtractor**
* **Full Subtractor**

The Half Subtractor subtracts one single-bit operand from another and generates:

* `Difference`
* `Borrow`

The Full Subtractor performs subtraction using:

* `a`
* `b`
* `c` — Borrow-in

and generates:

* `d` — Difference
* `bo` — Borrow-out

### Concepts

* Binary subtraction
* Difference generation
* Borrow generation
* Boolean equations
* Combinational logic
* Gate-level implementation
* Verilog primitives
* Functional verification

---

# 2. Structural Subtractors

The `Structural_Subtractors` directory demonstrates **hierarchical construction of a Full Subtractor using Half Subtractor modules**.

### Implementation

* **Full Subtractor using Half Subtractors**

The design instantiates two Half Subtractors and combines their borrow outputs using an OR gate.

```text
                  ┌──────────────┐
        a ───────►│ Half         │────► w1
        b ───────►│ Subtractor 1 │
                  └──────┬───────┘
                         │
                         │ w1
                         ▼
                  ┌──────────────┐
      borrow-in ─►│ Half         │────► Difference
                  │ Subtractor 2 │
                  └──────┬───────┘
                         │
                         │
                  Borrow Logic
                         │
                         ▼
                       Borrow-out
```

The implementation demonstrates how a previously designed **Half Subtractor can be reused as a building block for a Full Subtractor**.

### Concepts

* Structural Verilog
* Module instantiation
* Hierarchical design
* Hardware reuse
* Borrow propagation
* Combinational circuit composition
* Functional verification

---

# 3. Add/Subtract Unit

The `Add_Subtract_Unit` directory contains **single-bit arithmetic units capable of performing either addition or subtraction based on a control signal**.

The implementations include:

* `ha_and_hs`
* `fa_and_fs`

These circuits demonstrate how addition and subtraction functionality can be combined into a single configurable arithmetic block.

---

## 3.1 Half Adder / Half Subtractor Unit

The `ha_and_hs` module combines addition/subtraction-related logic using a control input.

The circuit accepts:

```text
a
b
x
```

and produces:

```text
res
cout
```

The control signal `x` influences the arithmetic operation.

The implementation demonstrates how XOR-based arithmetic logic can be manipulated to support different arithmetic functions.

---

## 3.2 Full Adder / Full Subtractor Unit

The `fa_and_fs` module provides a **single-bit arithmetic unit capable of supporting addition/subtraction behavior through a control input**.

Inputs:

* `a`
* `b`
* `c`
* `x` — Control

Outputs:

* `res`
* `cout`

The control signal determines the operating mode.

```text
             ┌────────────────────┐
      a ────►│                    │
      b ────►│   FA / FS Unit     │────► Result
      c ────►│                    │────► Carry / Borrow
      x ────►│   Mode Control     │
             └────────────────────┘
```

This design is useful for understanding the fundamental concept behind **combined arithmetic units**, where a single hardware structure can perform more than one arithmetic operation.

### Concepts

* Combined arithmetic circuits
* Addition/subtraction control
* Mode-controlled combinational logic
* XOR-based control
* Carry/Borrow behavior
* Structural gate-level design
* Functional verification

---

# 4. N-Bit Add/Subtract Unit

The `N_Bit_Add_Sub_Unit` directory contains a **parameterized N-bit arithmetic unit capable of performing both addition and subtraction**.

The implementation is based on a chain of controlled Full Adder/Full Subtractor stages.

### Module

```text
nbit_fa_fs
```

The module is parameterized using:

```verilog
parameter N = 8
```

allowing the same architecture to be configured for different operand widths.

---

## Architecture

```text
                         Control
                            │
                            ▼
a[0] ──┐              ┌─────────┐
b[0] ──┼─────────────►│ FA / FS │────► res[0]
c[0] ──┘              └────┬────┘
                           │
                           ▼
a[1] ──┐              ┌─────────┐
b[1] ──┼─────────────►│ FA / FS │────► res[1]
c[1] ──┘              └────┬────┘
                           │
                          ...
                           │
                           ▼
a[N-1] ─┐             ┌─────────┐
b[N-1] ─┼────────────►│ FA / FS │────► res[N-1]
c[N-1] ─┘             └────┬────┘
                           │
                           ▼
                         cout
```

The design uses a carry/borrow chain between consecutive stages.

---

## Mode Selection

The `sub` signal controls whether the unit operates in addition or subtraction mode.

Conceptually:

```text
sub = 0  → Addition
sub = 1  → Subtraction
```

The implementation uses the control signal to modify the second operand and initialize the carry chain:

```verilog
assign cc[0] = c | sub;
```

The operand-control logic allows the same chain of arithmetic stages to support both operations.

---

## Multi-Bit Arithmetic

For an `N`-bit configuration, the design creates `N` arithmetic stages using a Verilog `generate` loop.

```verilog
generate
    for(i = 0; i < N; i = i + 1) begin : fa_sub_stage
        fa_fs dut(
            a[i],
            b[i],
            cc[i],
            sub,
            res[i],
            cc[i+1]
        );
    end
endgenerate
```

For example, with:

```verilog
parameter N = 16
```

the design contains **16 arithmetic stages**.

This demonstrates scalable and parameterized RTL design.

---

# 5. Arithmetic Operation Flow

The overall progression of the subtraction designs is:

```text
                 Basic Subtraction
                       │
                       ▼
                Half Subtractor
                       │
                       ▼
                Full Subtractor
                       │
                       ▼
          Full Subtractor Using
             Half Subtractors
                       │
                       ▼
              Single-Bit FA/FS
                       │
                       ▼
             N-Bit Add/Sub Unit
```

This demonstrates the progression from fundamental subtraction logic to a reusable multi-bit arithmetic block.

---

# 6. Verification

Each implementation is accompanied by a dedicated **Verilog testbench**.

The testbenches apply the required input combinations and monitor the resulting difference, result, carry, or borrow outputs.

The simulations also use:

```verilog
$fsdbDumpvars();
```

for **FSDB waveform generation and analysis**.

### Basic Subtractor Verification

The Half Subtractor and Full Subtractor testbenches cover their complete input spaces.

### Structural Subtractor Verification

The Full Subtractor constructed using Half Subtractors is verified using all eight combinations of:

```text
a, b, borrow-in
```

### N-Bit Add/Sub Verification

The parameterized design is tested with representative multi-bit addition and subtraction operations, including cases involving:

* Normal addition
* Addition carry-out
* Normal subtraction
* Subtraction requiring borrow
* Boundary values

### Verification Flow

```text
RTL Design
    │
    ▼
Testbench
    │
    ▼
Simulation
    ├── Console Output
    └── FSDB Waveform
```

---

# 7. Concepts Covered

This Subtractors section covers:

* Half Subtractor
* Full Subtractor
* Difference generation
* Borrow generation
* Structural Verilog
* Hierarchical module design
* Module instantiation
* Hardware reuse
* Combined Add/Subtract logic
* Mode-controlled arithmetic
* Parameterized RTL
* Multi-bit subtraction
* Carry/Borrow propagation
* `generate` and `genvar`
* Combinational circuit design
* Testbench development
* Functional simulation
* FSDB waveform analysis

---

# 8. Learning Path

The implementations are organized in the following progression:

| Stage | Implementation               | Primary Concept                       |
| ----- | ---------------------------- | ------------------------------------- |
| 1     | Half Subtractor              | Basic binary subtraction              |
| 2     | Full Subtractor              | Subtraction with borrow-in            |
| 3     | Structural Full Subtractor   | Hierarchical module reuse             |
| 4     | Half Adder / Subtractor Unit | Combined arithmetic logic             |
| 5     | Full Adder / Subtractor Unit | Mode-controlled single-bit arithmetic |
| 6     | N-Bit Add/Sub Unit           | Parameterized multi-bit arithmetic    |

---

## Key Design Principle

The Subtractors section demonstrates how **fundamental subtraction blocks can be progressively combined into scalable arithmetic hardware**.

```text
Logic Gates
    ↓
Half Subtractor
    ↓
Full Subtractor
    ↓
Structural Full Subtractor
    ↓
Single-Bit Add/Sub Unit
    ↓
N-Bit Add/Sub Unit
    ↓
Larger Arithmetic Units
```

The overall design progression emphasizes **modularity, structural reuse, parameterization, and functional verification**, providing a foundation for more complex arithmetic blocks such as **ALUs and datapaths**.

