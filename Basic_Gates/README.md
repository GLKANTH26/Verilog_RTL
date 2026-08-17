# Basic Gates

This directory contains **fundamental logic-gate implementations in Verilog**, organized according to different hardware description and implementation approaches.

The implementations demonstrate how basic digital logic can be described using **Verilog built-in gate primitives, bitwise operators, and CMOS/MOS transistor-level primitives**.

---

## 📂 Directory Structure

```text
Basic_Gates/
│
├── BUILTIN_REM/
│   ├── RTL
│   └── Testbench
│
├── CMOS_REM/
│   ├── RTL
│   └── Testbench
│
├── LOGICAL_REM/
│   ├── RTL
│   └── Testbench
│
├── NAND_MOS/
│   ├── RTL
│   └── Testbench
│
├── NOT_BUILTIN/
│   ├── RTL
│   └── Testbench
│
├── NOT_Logical/
│   ├── RTL
│   └── Testbench
│
├── NOT_MOS/
│   ├── RTL
│   └── Testbench
│
└── README.md
```

---

## 🔹 Implementation Approaches

### 1. Built-in Gate Modeling

Uses Verilog's **built-in gate primitives** to directly describe the corresponding logic gates.

Common primitives include:

```verilog
and
or
not
nand
nor
xor
xnor
```

This provides a direct gate-level representation of the intended digital logic.

---

### 2. Bitwise Operator Modeling

The logic functions are implemented using **Verilog bitwise operators**.

Common bitwise operators include:

```verilog
&
|
~
^
```

For single-bit signals, these operators directly represent the corresponding Boolean operations.

For example:

```verilog
assign y = a & b;
```

represents an AND operation.

This approach demonstrates how fundamental gates can be described using **Verilog expressions rather than explicit gate primitives**.

---

### 3. CMOS / MOS-Level Modeling

The CMOS implementations describe the logic using **MOS transistor primitives**, providing a lower-level representation of the hardware.

Typical primitives include:

```verilog
pmos
nmos
```

This approach connects Boolean logic to the underlying transistor-level implementation.

---

## 📁 Current Implementations

| Directory     | Implementation                                              |
| ------------- | ----------------------------------------------------------- |
| `BUILTIN_REM` | Logic implementation using Verilog built-in gate primitives |
| `LOGICAL_REM` | Logic implementation using Verilog bitwise operators        |
| `CMOS_REM`    | CMOS-level logic implementation                             |
| `NAND_MOS`    | NAND gate using MOS transistor primitives                   |
| `NOT_BUILTIN` | NOT gate using Verilog built-in primitive                   |
| `NOT_Logical` | NOT gate using Verilog bitwise NOT operator                 |
| `NOT_MOS`     | NOT gate using MOS transistor primitives                    |

Each implementation contains its corresponding **RTL design and testbench** for functional verification.

---

## 🧪 Verification

Each design is accompanied by a dedicated **Verilog testbench**.

The testbenches apply the required input combinations and verify the resulting outputs against the expected truth-table behavior.

For basic combinational gates, all possible input combinations are tested where applicable.

### Verification Flow

```text
RTL Design
    │
    ▼
Testbench
    │
    ▼
Simulation
    │
    ▼
Output Verification
```

---

## 🎯 Learning Objectives

This section provides a foundation in:

* Fundamental Boolean logic
* Basic logic-gate implementation
* Verilog gate primitives
* Bitwise operators
* CMOS logic implementation
* NMOS and PMOS transistor primitives
* RTL modeling
* Testbench development
* Functional verification
* Gate-level and transistor-level representation

---

## 🛠️ Tools & Technologies

* **Verilog HDL**
* **Gate-Level Modeling**
* **Bitwise Operator Modeling**
* **CMOS / MOS-Level Modeling**
* **Verilog Testbenches**
* **Simulation**
* **Git & GitHub**

---

## 🔗 Abstraction Levels

The implementations demonstrate the progression from Boolean logic to hardware-level representation:

```text
Boolean Logic
      │
      ▼
Bitwise Operator Representation
      │
      ▼
Verilog Gate Primitives
      │
      ▼
CMOS / MOS Transistor Implementation
```

This provides a practical connection between **Boolean expressions, Verilog descriptions, logic gates, and their underlying CMOS transistor structures**.

