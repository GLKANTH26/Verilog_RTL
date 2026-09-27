# Basic MUX

This folder contains the **basic fixed-size Multiplexer (MUX) implementations** used to understand the fundamental operation of a MUX before moving to hierarchical and parameterized designs.

The current implementations cover:

* **4:1 Multiplexer**
* **8:1 Multiplexer**
* Corresponding **testbenches** for functional verification

---

## 1. What is a Multiplexer?

A **Multiplexer (MUX)** is a combinational digital circuit that selects **one input from multiple input lines** and connects the selected input to a single output.

It is therefore also called a:

> **Data Selector**

The selection is controlled using **select lines**.

For a MUX having `N` input lines, the number of select lines required is:

$$
S = \log_2(N)
$$

For example:

| MUX  | Data Inputs | Select Lines | Output |
| ---- | ----------: | -----------: | -----: |
| 2:1  |           2 |            1 |      1 |
| 4:1  |           4 |            2 |      1 |
| 8:1  |           8 |            3 |      1 |
| 16:1 |          16 |            4 |      1 |
| 32:1 |          32 |            5 |      1 |

---

# 2. Basic MUX Operation

The basic idea of a MUX is very simple:

```text
             ┌──────────────┐
 I0 ────────►│              │
 I1 ────────►│              │
 I2 ────────►│     MUX      ├────► Y
 I3 ────────►│              │
             │              │
 S1 ────────►│              │
 S0 ────────►│              │
             └──────────────┘
```

The select lines determine **which input is connected to the output**.

For example:

```text
S1 S0 = 00  →  Y = I0
S1 S0 = 01  →  Y = I1
S1 S0 = 10  →  Y = I2
S1 S0 = 11  →  Y = I3
```

---

# 3. 4:1 Multiplexer

A **4:1 MUX** has:

* 4 data inputs
* 2 select inputs
* 1 output

```text
       I0 ─────┐
       I1 ─────┤
       I2 ─────┤──► 4:1 MUX ───► Y
       I3 ─────┘
                 ▲
               S1 S0
```

## Selection Table

|  S1 |  S0 | Selected Input | Output |
| :-: | :-: | :------------: | :----: |
|  0  |  0  |       I0       |   I0   |
|  0  |  1  |       I1       |   I1   |
|  1  |  0  |       I2       |   I2   |
|  1  |  1  |       I3       |   I3   |

Therefore, the Boolean expression for a 4:1 MUX is:

$$
Y =
\overline{S_1}\overline{S_0}I_0
+
\overline{S_1}S_0I_1
+
S_1\overline{S_0}I_2
+
S_1S_0I_3
$$

Each input is enabled for exactly one select combination.

---

# 4. 8:1 Multiplexer

An **8:1 MUX** has:

* 8 data inputs
* 3 select inputs
* 1 output

```text
I0 ─────┐
I1 ─────┤
I2 ─────┤
I3 ─────┤
I4 ─────┤──► 8:1 MUX ───► Y
I5 ─────┤
I6 ─────┤
I7 ─────┘
          ▲
        S2 S1 S0
```

## Selection Table

|  S2 |  S1 |  S0 | Selected Input | Output |
| :-: | :-: | :-: | :------------: | :----: |
|  0  |  0  |  0  |       I0       |   I0   |
|  0  |  0  |  1  |       I1       |   I1   |
|  0  |  1  |  0  |       I2       |   I2   |
|  0  |  1  |  1  |       I3       |   I3   |
|  1  |  0  |  0  |       I4       |   I4   |
|  1  |  0  |  1  |       I5       |   I5   |
|  1  |  1  |  0  |       I6       |   I6   |
|  1  |  1  |  1  |       I7       |   I7   |

The general Boolean expression is:

$$
Y =
\overline{S_2}\overline{S_1}\overline{S_0}I_0
+
\overline{S_2}\overline{S_1}S_0I_1
+
\overline{S_2}S_1\overline{S_0}I_2
+
\overline{S_2}S_1S_0I_3
$$

$$
+
S_2\overline{S_1}\overline{S_0}I_4
+
S_2\overline{S_1}S_0I_5
+
S_2S_1\overline{S_0}I_6
+
S_2S_1S_0I_7
$$

---

# 5. Files in This Folder

```text
Basic_MUX/
├── 4by1.v
├── 4by1_tb.v
├── 8by1.v
├── 8by1_tb.v
└── README.md
```

| File        | Description                                     |
| ----------- | ----------------------------------------------- |
| `4by1.v`    | RTL implementation of a 4:1 MUX                 |
| `4by1_tb.v` | Testbench for the 4:1 MUX                       |
| `8by1.v`    | RTL implementation of an 8:1 MUX                |
| `8by1_tb.v` | Testbench for the 8:1 MUX                       |
| `README.md` | Documentation for the Basic MUX implementations |

---

# 6. Implementation Approach

The MUXes in this folder represent **basic fixed-size RTL implementations**.

The main objective is to understand:

1. Number of inputs
2. Number of select lines
3. Input selection
4. Truth-table behavior
5. Combinational RTL description
6. Functional verification

These designs are intentionally kept simple before moving to more advanced implementations such as hierarchical and parameterized MUXes.

---

# 7. Other MUX Implementations to Practice

The MUX functionality can be implemented using several different approaches.

The implementations in this folder are basic RTL designs. The following approaches can be practiced separately.

### 7.1 Gate-Level MUX

Implement the MUX using:

* AND gates
* OR gates
* NOT gates

For a 4:1 MUX, directly implement its Boolean equation.

---

### 7.2 NAND-Only MUX

Implement the complete MUX using only:

```text
NAND gates
```

This is useful for understanding universal-gate implementations.

---

### 7.3 NOR-Only MUX

Implement the complete MUX using only:

```text
NOR gates
```

---

### 7.4 Conditional-Operator MUX

Use the Verilog conditional operator:

```verilog
assign y = sel ? b : a;
```

For larger MUXes, multiple conditional expressions can be used.

---

### 7.5 `if-else` MUX

Implement the selection using procedural combinational logic:

```verilog
if (...)
    ...
else
    ...
```

This helps understand how synthesis converts procedural RTL into combinational hardware.

---

### 7.6 `case` Based MUX

Implement the MUX using:

```verilog
case (sel)
    ...
endcase
```

This is particularly readable for fixed-size MUXes.

---

### 7.7 `casez` / `casex` Based MUX

Practice MUX selection using wildcard case statements.

`casez` is generally useful for controlled wildcard matching.

`casex` should be used carefully because it can mask unknown (`X`) values during simulation.

---

### 7.8 MUX Using 2:1 MUXes

Construct larger MUXes from smaller 2:1 MUXes.

For example:

```text
8:1 MUX
   │
   ├── 2:1
   ├── 2:1
   ├── 2:1
   ├── 2:1
   │
   └── Multiple stages
```

This leads naturally to a **MUX tree** architecture.

---

### 7.9 One-Hot MUX

Use one-hot select signals instead of binary select signals.

For a 4-input MUX:

```text
0001 → I0
0010 → I1
0100 → I2
1000 → I3
```

---

### 7.10 Decoder-Based MUX

Use a decoder to generate one-hot selection signals and then use those signals to select the required input.

```text
Select
  │
  ▼
Decoder
  │
  ├── Enable 0
  ├── Enable 1
  ├── Enable 2
  └── Enable 3
          │
          ▼
     Selection Logic
          │
          ▼
          Y
```

---

### 7.11 Transmission-Gate MUX

Implement the MUX using **CMOS transmission gates**.

This is useful for connecting RTL-level MUX concepts with transistor-level CMOS design.

---

### 7.12 Pass-Transistor MUX

Implement the MUX using pass-transistor logic.

This provides practice with:

* Pass-transistor logic
* Threshold-voltage effects
* Logic-level degradation
* CMOS switching

---

### 7.13 CMOS Transistor-Level MUX

Implement the MUX directly using:

* PMOS
* NMOS

This allows investigation of:

* Pull-up network
* Pull-down network
* Transistor sizing
* Propagation delay
* Power
* Area

---

# 8. Verification

Each MUX has a dedicated testbench.

```text
4by1.v
   │
   └──► 4by1_tb.v

8by1.v
   │
   └──► 8by1_tb.v
```

The testbenches should verify all possible select combinations.

For the 4:1 MUX:

```text
00 → I0
01 → I1
10 → I2
11 → I3
```

For the 8:1 MUX:

```text
000 → I0
001 → I1
010 → I2
011 → I3
100 → I4
101 → I5
110 → I6
111 → I7
```

This ensures that every input-selection path is functionally verified.

---

# 9. Learning Progression

The MUX designs in this folder form the basic foundation for the larger MUX designs in the parent directory.

```text
2:1 MUX
   ↓
4:1 MUX
   ↓
8:1 MUX
   ↓
Gate-Level MUX
   ↓
NAND / NOR MUX
   ↓
Hierarchical MUX
   ↓
Parameterized MUX
   ↓
Bus MUX
   ↓
Transmission-Gate / CMOS MUX
```

The important idea is that the **function remains the same**, while the implementation and level of abstraction change.

---

# 10. Key Takeaways

* A MUX is a **combinational data-selection circuit**.
* An `N:1` MUX requires:

$$
\log_2(N)
$$

select lines when `N` is a power of two.

* A 4:1 MUX requires 2 select lines.
* An 8:1 MUX requires 3 select lines.
* Only one input is selected at a time.
* MUXes are heavily used in datapaths, processors, ALUs, buses, and control logic.
* The same MUX functionality can be implemented using different abstraction levels:

  * Boolean equations
  * Gate level
  * RTL
  * Structural RTL
  * Hierarchical design
  * Parameterized RTL
  * Transmission gates
  * CMOS transistor-level logic

The implementations in `Basic_MUX` establish the fundamental MUX operation before progressing to **Hierarchical_MUX** and **Parameterized_MUX** in the parent `Multiplexers` directory.
