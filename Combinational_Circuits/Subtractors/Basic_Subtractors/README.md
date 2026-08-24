# Basic Subtractors

This directory contains the **fundamental single-bit binary subtraction circuits implemented in Verilog HDL**:

* **Half Subtractor**
* **Full Subtractor**

These circuits form the basic building blocks for larger subtraction and arithmetic units.

---

## 📂 Directory Structure

```text
Basic_Subtractors/
│
├── half_sub.v
├── half_sub_tb.v
├── full_sub.v
├── full_sub_tb.v
└── README.md
```

---

# 1. Half Subtractor

A **Half Subtractor** performs the subtraction of one single-bit binary input from another.

The circuit performs:

```text
A - B
```

and generates two outputs:

* `Difference`
* `Borrow`

### Inputs

* `a` — Minuend
* `b` — Subtrahend

### Outputs

* `d` — Difference
* `bo` — Borrow-out

### Boolean Equations

```text
d  = a ⊕ b

bo = a' · b
```

The Difference output is generated using an XOR operation, while the Borrow output becomes HIGH when `b = 1` and `a = 0`.

### Truth Table

|  a  |  b  | Difference (`d`) | Borrow (`bo`) |
| :-: | :-: | :--------------: | :-----------: |
|  0  |  0  |         0        |       0       |
|  0  |  1  |         1        |       1       |
|  1  |  0  |         1        |       0       |
|  1  |  1  |         0        |       0       |

### Logic

```text
        a ─────┬──────── XOR ─────► d
               │
        b ─────┘

        a ── NOT ──┐
                   ├──── AND ─────► bo
        b ─────────┘
```

---

# 2. Full Subtractor

A **Full Subtractor** performs subtraction of three single-bit inputs:

```text
A - B - Bin
```

where `Bin` represents the borrow received from the previous lower-order bit.

The circuit generates:

* `Difference`
* `Borrow-out`

### Inputs

* `a` — Minuend
* `b` — Subtrahend
* `c` — Borrow-in

### Outputs

* `d` — Difference
* `bo` — Borrow-out

### Boolean Equations

```text
d = a ⊕ b ⊕ c
```

The borrow-out can be expressed as:

```text
bo = a'b + a'c + bc
```

An equivalent form is:

```text
bo = a'b + c(a ⊕ b)'
```

### Truth Table

|  a  |  b  | c (Bin) |  d  |  bo |
| :-: | :-: | :-----: | :-: | :-: |
|  0  |  0  |    0    |  0  |  0  |
|  0  |  0  |    1    |  1  |  1  |
|  0  |  1  |    0    |  1  |  1  |
|  0  |  1  |    1    |  0  |  1  |
|  1  |  0  |    0    |  1  |  0  |
|  1  |  0  |    1    |  0  |  0  |
|  1  |  1  |    0    |  0  |  0  |
|  1  |  1  |    1    |  1  |  1  |

---

# 3. Half Subtractor vs Full Subtractor

The primary difference is the presence of a **borrow-in**.

| Feature            | Half Subtractor | Full Subtractor |
| ------------------ | --------------- | --------------- |
| Minuend            | `a`             | `a`             |
| Subtrahend         | `b`             | `b`             |
| Borrow-in          | —               | `c`             |
| Difference         | `d`             | `d`             |
| Borrow-out         | `bo`            | `bo`            |
| Input combinations | 4               | 8               |

Conceptually:

```text
Half Subtractor:

        a ──┐
            ├──► Subtraction ──► d
        b ──┘
                   │
                   └────────────► bo


Full Subtractor:

        a ──┐
        b ──┼──► Subtraction ──► d
        Bin ─┘
                   │
                   └────────────► bo
```

---

# 4. Verilog Implementation

The designs in this directory implement the subtraction logic using **combinational Verilog constructs**.

The Half Subtractor directly represents the required Difference and Borrow functions.

The Full Subtractor represents the three-input subtraction operation and generates the corresponding Difference and Borrow outputs.

---

# 5. Verification

Each design has a dedicated testbench:

```text
half_sub.v
     │
     ▼
half_sub_tb.v


full_sub.v
     │
     ▼
full_sub_tb.v
```

The testbenches apply the required input combinations and monitor the resulting outputs.

### Half Subtractor

All **4 possible input combinations** are tested:

```text
00
01
10
11
```

### Full Subtractor

All **8 possible input combinations** are tested:

```text
000
001
010
011
100
101
110
111
```

The outputs are compared against the expected Difference and Borrow behavior.

---

# 6. Simulation

The testbenches use simulation-based functional verification.

Where configured in the testbench,:

```verilog
$fsdbDumpvars();
```

is used to generate **FSDB waveform data** for detailed signal-level analysis.

### Verification Flow

```text
Subtractor RTL
      │
      ▼
Testbench
      │
      ▼
Simulation
   ┌──┴──┐
   ▼     ▼
Console FSDB
Output  Waveform
```

---

# 7. Files

### `half_sub.v`

Contains the **Half Subtractor** implementation.

### `half_sub_tb.v`

Contains the testbench used to verify the Half Subtractor.

### `full_sub.v`

Contains the **Full Subtractor** implementation.

### `full_sub_tb.v`

Contains the testbench used to verify the Full Subtractor.

---

# 8. Concepts Covered

* Binary subtraction
* Half Subtractor
* Full Subtractor
* Difference generation
* Borrow generation
* Borrow-in
* Borrow-out
* Boolean equations
* Truth tables
* Combinational logic
* Verilog RTL modeling
* Testbench development
* Functional simulation
* FSDB waveform analysis

---

## Key Design Principle

The Basic Subtractors provide the fundamental building blocks required for larger subtraction architectures:

```text
Logic Gates
    ↓
Half Subtractor
    ↓
Full Subtractor
    ↓
Structural Subtractor
    ↓
Multi-Bit Subtractor
    ↓
Add/Subtract Unit
```

These single-bit circuits establish the foundation for understanding **borrow propagation and multi-bit binary subtraction** in larger arithmetic datapaths.

