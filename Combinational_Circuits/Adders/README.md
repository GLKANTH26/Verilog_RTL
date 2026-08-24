# Adders

This directory contains **Verilog implementations of binary addition circuits**, progressing from fundamental single-bit adders to hierarchical, CMOS transistor-level, and parameterized multi-bit implementations.

The designs are organized to demonstrate different approaches to constructing arithmetic hardware while maintaining **modularity, reusability, and functional verification**.

---

## 📂 Directory Structure

```text
Adders/
│
├── Basic_Adders/
│   ├── full_adder.v
│   ├── full_adder_tb.v
│   ├── half_adder.v
│   ├── half_adder_tb.v
│   └── README.md
│
├── Structural_Adders/
│   ├── full_using_half.v
│   ├── full_using_half_tb.v
│   └── README.md
│
├── CMOS_Adders/
│   ├── half_adder_cmos.v
│   ├── half_adder_cmos_tb.v
│   ├── full_adder_cmos.v
│   ├── full_adder_cmos_tb.v
│   └── README.md
│
├── N_Bit_Adders/
│   ├── full_adder.v
│   ├── full_adder_tb.v
│   ├── n_bit_fa.v
│   ├── n_bit_fa_tb.v
│   └── README.md
│
└── README.md
```

---

# 1. Basic Adders

The `Basic_Adders` directory contains the fundamental **single-bit binary addition circuits**.

### Implementations

* **Half Adder**
* **Full Adder**

The Half Adder adds two single-bit inputs and generates `sum` and `carry`.

The Full Adder adds three single-bit inputs (`a`, `b`, and `c_in`) and generates `sum` and `c_out`.

### Concepts

* Binary addition
* Sum generation
* Carry generation
* Boolean equations
* Combinational logic
* Verilog procedural modeling
* Gate-level logic

---

# 2. Structural Adders

The `Structural_Adders` directory demonstrates **hierarchical construction of arithmetic circuits using module instantiation**.

### Implementation

* **Full Adder using Half Adders**

The Full Adder is constructed using:

* Two Half Adder instances
* One OR gate

```text
Half Adder
     │
     ├──────────────┐
     ▼              │
Half Adder          │
     │              │
     └──────┬───────┘
            ▼
           OR
            │
            ▼
          c_out
```

The design demonstrates how a previously developed module can be reused as a **building block for a higher-level circuit**.

### Concepts

* Structural Verilog
* Module instantiation
* Hierarchical design
* Hardware reuse
* Combinational circuit composition
* Functional verification

---

# 3. CMOS Adders

The `CMOS_Adders` directory contains **transistor-level CMOS implementations of binary addition circuits using Verilog ****`pmos`**** and ****`nmos`**** primitives**.

The implementation first constructs CMOS logic primitives and then uses them to build arithmetic circuits.

### CMOS Logic Building Blocks

The implementation includes:

* CMOS NOT
* CMOS NAND
* CMOS NOR
* CMOS AND
* CMOS OR
* CMOS XOR

These are used to construct:

* CMOS Half Adder
* CMOS Full Adder

### Hierarchy

```text
NMOS / PMOS
     │
     ▼
CMOS Logic Gates
     │
     ▼
Half Adder
     │
     ▼
Full Adder
```

This implementation provides a connection between **digital logic design and transistor-level CMOS realization**.

### Concepts

* CMOS logic
* NMOS and PMOS transistor primitives
* Pull-up networks
* Pull-down networks
* Transistor-level modeling
* CMOS arithmetic circuits
* Hierarchical CMOS design
* FSDB waveform generation

---

# 4. N-Bit Adders

The `N_Bit_Adders` directory contains a **parameterized N-bit Full Adder** implemented using a ripple-carry architecture.

The design reuses the previously developed `full_adder` module and generates `N` Full Adder stages using a Verilog `generate` loop.

### Architecture

```text
c_in
  │
  ▼
┌──────┐    ┌──────┐    ┌──────┐             ┌─────────┐
│ FA₀  │───►│ FA₁  │───►│ FA₂  │───► ... ───►│ FA[N-1] │───► c_out
└──────┘    └──────┘    └──────┘             └─────────┘
   │           │           │                       │
 sum[0]      sum[1]      sum[2]                sum[N-1]
```

### Parameterization

The module uses:

```verilog
parameter N = 8
```

allowing the same design to be configured for different operand widths.

For example:

```verilog
n_bit_fa #(8)  ...
n_bit_fa #(16) ...
n_bit_fa #(32) ...
```

### Hierarchical Implementation

The N-bit adder reuses the existing Full Adder:

```verilog
`include "Full_adder.v"
```

and instantiates it inside a `generate` loop.

For `N = 8`, eight Full Adder instances are created during elaboration.

### Independent Implementation

The README in `N_Bit_Adders` also documents an alternative approach where the Full Adder is **not instantiated**.

Instead, the Full Adder equations are directly implemented for every bit:

```text
sum[i]     = a[i] ⊕ b[i] ⊕ carry[i]

carry[i+1] = a[i]b[i] + carry[i](a[i] ⊕ b[i])
```

This provides a comparison between:

* **Hierarchical module reuse**
* **Self-contained combinational implementation**

### Concepts

* Parameterized RTL
* Multi-bit binary addition
* Ripple-carry architecture
* Carry propagation
* Generate blocks
* `genvar`
* Hierarchical module instantiation
* Scalable RTL design
* Functional verification

---

# 5. Design Progression

The implementations in this directory demonstrate a progression from basic logic to scalable arithmetic hardware:

```text
                 Basic Logic
                     │
                     ▼
                Half Adder
                     │
                     ▼
                Full Adder
                     │
          ┌──────────┴──────────┐
          │                     │
          ▼                     ▼
  Structural Full Adder    CMOS Full Adder
          │                     │
          └──────────┬──────────┘
                     ▼
              N-Bit Full Adder
                     │
                     ▼
             Larger Arithmetic
                 Datapaths
```

This progression demonstrates how a fundamental arithmetic operation can be represented at different levels of abstraction:

```text
Boolean / Gate Logic
        ↓
Structural RTL
        ↓
CMOS / Transistor Level
        ↓
Parameterized Multi-Bit RTL
```

---

# 6. Verification

Each implementation is accompanied by a dedicated **Verilog testbench**.

The testbenches verify the functional behavior of the corresponding designs through simulation.

The CMOS and structural implementations additionally demonstrate waveform-based analysis using:

```verilog
$fsdbDumpvars();
```

### General Verification Flow

```text
RTL / Transistor-Level Design
             │
             ▼
          Testbench
             │
             ▼
          Simulation
         ┌────┴────┐
         ▼         ▼
     Console     Waveform
      Output      Analysis
```

For single-bit adders, the complete input space is verified.

For the parameterized N-bit implementation, representative multi-bit arithmetic cases are applied, including a case demonstrating final carry-out behavior.

---

# 7. Concepts Covered

This Adders section covers:

* Half Adder
* Full Adder
* Binary addition
* Sum and carry generation
* Gate-level implementation
* Structural Verilog
* Hierarchical RTL design
* Module instantiation
* CMOS transistor-level design
* NMOS and PMOS primitives
* Parameterized modules
* Multi-bit arithmetic
* Ripple-carry architecture
* Carry propagation
* `generate` and `genvar`
* Testbench development
* Functional simulation
* FSDB waveform analysis
* Hardware modularity and reuse

---

# 8. Learning Path

The implementations are organized to follow a natural progression:

| Stage | Implementation        | Primary Concept                    |
| ----- | --------------------- | ---------------------------------- |
| 1     | Half Adder            | Basic binary addition              |
| 2     | Full Adder            | Addition with carry-in             |
| 3     | Structural Full Adder | Hierarchical module reuse          |
| 4     | CMOS Half Adder       | Transistor-level arithmetic        |
| 5     | CMOS Full Adder       | CMOS hierarchical design           |
| 6     | N-Bit Full Adder      | Parameterized multi-bit arithmetic |

---

## Key Design Principle

The Adders section demonstrates an important digital-design methodology:

> **Build complex hardware from smaller, verified, reusable building blocks.**

```text
Logic Gates
    ↓
Half Adder
    ↓
Full Adder
    ↓
Structural / CMOS Full Adder
    ↓
N-Bit Full Adder
    ↓
Larger Arithmetic Units
```

This modular approach provides a foundation for implementing more complex digital blocks such as **ALUs, arithmetic datapaths, processors, and other RTL systems**.

