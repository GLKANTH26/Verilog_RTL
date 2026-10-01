# Demultiplexers

This folder contains different **Demultiplexer (DeMUX)** designs implemented using Verilog HDL.

The designs are organized progressively, starting from basic Demultiplexer implementations and moving toward hierarchical designs and practical applications.

---

## 1. What is a Demultiplexer?

A **Demultiplexer (DeMUX)** is a combinational circuit that takes **one data input** and routes it to **one of multiple output lines** based on the select inputs.

A Demultiplexer is also known as a **data distributor**.

```text
                     Select Lines
                          │
                          ▼
                   ┌─────────────┐
                   │             │──► Y0
                   │             │──► Y1
             IN ──►│   DeMUX     │──► Y2
                   │             │──► Y3
                   │             │
                   └─────────────┘
```

For `N` outputs, the number of select lines is:

**Number of Select Lines = log₂(N)**

---

## 2. Demultiplexer Structure

A general Demultiplexer contains:

* One data input
* Select lines
* Multiple data outputs

For example:

| Demultiplexer | Data Input | Select Lines | Outputs |
| ------------- | ---------: | -----------: | ------: |
| 1:2           |          1 |            1 |       2 |
| 1:4           |          1 |            2 |       4 |
| 1:8           |          1 |            3 |       8 |
| 1:16          |          1 |            4 |      16 |
| 1:32          |          1 |            5 |      32 |

The relationship is:

**Number of Outputs = 2^(Number of Select Lines)**

---

## 3. Basic Demultiplexer Operation

The select lines determine which output receives the input.

For a 1:4 Demultiplexer:

|  S1 |  S0 | Selected Output |
| :-: | :-: | :-------------: |
|  0  |  0  |        Y0       |
|  0  |  1  |        Y1       |
|  1  |  0  |        Y2       |
|  1  |  1  |        Y3       |

If `IN = 1`, the selected output becomes `1` and all other outputs remain `0`.

If `IN = 0`, all outputs remain `0`.

---

## 4. Boolean Representation

For a 1:4 Demultiplexer:

**Y0 = IN · S1' · S0'**

**Y1 = IN · S1' · S0**

**Y2 = IN · S1 · S0'**

**Y3 = IN · S1 · S0**

Each output corresponds to one minterm of the select inputs.

---

# 5. Folder Structure

```text
DeMultiplexers/
├── Basic_DeMUX/
│   ├── 1by4.v
│   ├── 1by4_tb.v
│   ├── 1by8.v
│   ├── 1by8_tb.v
│   └── README.md
│
├── Hierarchical_DeMUX/
│   ├── hier_1by16.v
│   ├── hier_1by16_tb.v
│   └── README.md
│
├── Applications/
│   ├── fulladder.v
│   ├── fulladder_tb.v
│   └── README.md
│
└── README.md
```

---

# 6. Basic_DeMUX

The `Basic_DeMUX` folder contains fundamental Demultiplexer implementations.

```text
Basic_DeMUX/
├── 1by4.v
├── 1by4_tb.v
├── 1by8.v
├── 1by8_tb.v
└── README.md
```

### Designs Included

* 1:4 Demultiplexer
* 1:8 Demultiplexer

### Concepts Covered

* Basic Demultiplexer operation
* Select-line decoding
* Combinational RTL
* Truth tables
* Boolean expressions
* Testbench development
* Exhaustive verification

---

# 7. Hierarchical_DeMUX

The `Hierarchical_DeMUX` folder demonstrates how a larger Demultiplexer can be constructed by combining smaller Demultiplexer modules.

```text
Hierarchical_DeMUX/
├── hier_1by16.v
├── hier_1by16_tb.v
└── README.md
```

The main design is a **1:16 Demultiplexer**.

A larger Demultiplexer can be constructed using smaller DeMUX blocks:

```text
             1:16 DeMUX
                  │
       ┌──────────┼──────────┐
       │          │          │
       ▼          ▼          ▼
    1:4 DeMUX  1:4 DeMUX  1:4 DeMUX  1:4 DeMUX
       │          │          │          │
       ▼          ▼          ▼          ▼
     Y0-Y3      Y4-Y7      Y8-Y11    Y12-Y15
```

This demonstrates:

* Module instantiation
* Module reuse
* Structural RTL
* Hierarchical design
* Block-level verification
* Top-level integration

---

# 8. Applications

The `Applications` folder demonstrates a practical application of Demultiplexer-based logic.

```text
Applications/
├── fulladder.v
├── fulladder_tb.v
└── README.md
```

The current application is a **Full Adder using Demultiplexer logic**.

The three Full Adder inputs:

```text
A
B
Cin
```

are used as select inputs of a 1:8 Demultiplexer.

The required Demultiplexer outputs are then combined to generate:

```text
Sum
Cout
```

The Full Adder functions are:

**Sum = A ⊕ B ⊕ Cin**

**Cout = AB + ACin + BCin**

The corresponding minterms are:

**Sum = Σm(1, 2, 4, 7)**

**Cout = Σm(3, 5, 6, 7)**

This demonstrates how a Demultiplexer can be used to realize Boolean functions.

---

# 9. Demultiplexer as a Boolean Function Generator

A Demultiplexer can be used to generate individual minterms of a Boolean function.

```text
                 Select Inputs
                 A   B   Cin
                  │   │   │
                  ▼   ▼   ▼
              ┌─────────────┐
              │    1 : 8    │
              │    DeMUX    │
              └──────┬──────┘
                     │
              Minterm Outputs
                     │
                     ▼
                OR Combination
                     │
                     ▼
              Boolean Function
```

By selecting and OR-ing the required minterms, different combinational functions can be implemented.

This makes the Demultiplexer useful for understanding:

* Minterms
* Sum-of-products
* Boolean function realization
* Combinational circuit design

---

# 10. Different Demultiplexer Implementation Methods

Demultiplexers can be implemented using different RTL and logic-design approaches.

### Behavioral RTL

Using:

* `always @(*)`
* `case`
* `if-else`

### Dataflow RTL

Using continuous assignments.

### Gate-Level Design

Using:

* AND gates
* NOT gates
* OR gates

### Universal-Gate Implementation

Using:

* NAND gates
* NOR gates

### Decoder-Based Implementation

Using a decoder together with data/enable logic.

### Hierarchical Implementation

Constructing larger Demultiplexers using smaller verified Demultiplexer modules.

### Parameterized Implementation

Using parameters to support different numbers of outputs and configurable architectures.

---

# 11. Common Demultiplexer Sizes

The Demultiplexer architecture can be extended to different sizes.

| Demultiplexer | Select Lines | Outputs |
| ------------- | -----------: | ------: |
| 1:2           |            1 |       2 |
| 1:4           |            2 |       4 |
| 1:8           |            3 |       8 |
| 1:16          |            4 |      16 |
| 1:32          |            5 |      32 |
| 1:64          |            6 |      64 |

---

# 12. Verification Approach

Verification is performed using dedicated testbenches for the RTL modules.

The general verification process is:

1. Apply the input data.
2. Apply every possible select-line combination.
3. Check the selected output.
4. Confirm that all unselected outputs remain `0`.
5. Repeat the process for different input values.

For a 1:8 Demultiplexer:

```text
3 Select Lines
      │
      ▼
2³ = 8 combinations
      │
      ▼
Test Y0 through Y7
```

For a 1:16 Demultiplexer:

```text
4 Select Lines
      │
      ▼
2⁴ = 16 combinations
      │
      ▼
Test Y0 through Y15
```

---

# 13. Applications of Demultiplexers

Demultiplexers are commonly used in:

* Data distribution
* Digital switching
* Communication systems
* Address decoding
* Memory selection
* Control signal routing
* Bus routing
* Peripheral selection
* Datapath control
* Digital communication interfaces
* Boolean function realization

---

# 14. MUX vs DeMUX

| Feature      | Multiplexer    | Demultiplexer     |
| ------------ | -------------- | ----------------- |
| Function     | Many-to-One    | One-to-Many       |
| Data Inputs  | Multiple       | One               |
| Data Outputs | One            | Multiple          |
| Select Lines | Select input   | Select output     |
| Main Purpose | Data selection | Data distribution |

### Multiplexer

```text
I0 ──┐
I1 ──┤
I2 ──┤──► MUX ──► Y
I3 ──┘
       ▲
     Select
```

### Demultiplexer

```text
             ┌──► Y0
             │
IN ──► DeMUX ├──► Y1
             │
             ├──► Y2
             │
             └──► Y3
                ▲
              Select
```

---

# 15. Learning Progression

The designs in this folder follow a progressive learning path:

```text
Basic DeMUX
     │
     ▼
1:4 DeMUX
     │
     ▼
1:8 DeMUX
     │
     ▼
Hierarchical DeMUX
     │
     ▼
1:16 DeMUX
     │
     ▼
Boolean Function Realization
     │
     ▼
Full Adder Using DeMUX
     │
     ▼
Larger RTL Applications
```

---

# 16. Key Concepts Practiced

This folder provides practice with:

* Combinational logic
* Demultiplexer architecture
* Select-line decoding
* Boolean expressions
* Truth tables
* Minterms
* Sum-of-products realization
* Behavioral RTL
* Structural RTL
* Module instantiation
* Hierarchical design
* Module reuse
* Testbench development
* Exhaustive verification
* Application-oriented RTL design

---

# 17. Future Practice

The following Demultiplexer designs can be implemented to further develop RTL skills:

```text
1:2 DeMUX
1:4 DeMUX
1:8 DeMUX
1:16 DeMUX
1:32 DeMUX
1:64 DeMUX
```

Additional implementation approaches:

```text
Gate-Level DeMUX
      ↓
Behavioral DeMUX
      ↓
Dataflow DeMUX
      ↓
Hierarchical DeMUX
      ↓
Parameterized DeMUX
      ↓
Decoder-Based DeMUX
      ↓
Boolean Function Applications
```

---

## Summary

The `DeMultiplexers` folder provides a progressive collection of Demultiplexer designs, starting from basic combinational RTL and progressing toward hierarchical designs and practical applications.

```text
                    DeMultiplexers
                          │
          ┌───────────────┼────────────────┐
          │               │                │
          ▼               ▼                ▼
    Basic_DeMUX   Hierarchical_DeMUX   Applications
          │               │                │
          ▼               ▼                ▼
       1:4, 1:8          1:16        Full Adder
```

The main objective of this folder is to develop a strong understanding of **Demultiplexer operation, combinational RTL, hierarchical design, module reuse, Boolean function realization, and practical digital circuit applications**.

