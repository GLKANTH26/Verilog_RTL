# Basic Demultiplexers

This folder contains basic **1-to-4** and **1-to-8 Demultiplexer (DeMUX)** designs implemented using Verilog HDL.

A Demultiplexer is a combinational circuit that takes **one data input** and routes it to **one of multiple output lines** based on the select lines.

---

## 1. What is a Demultiplexer?

A **Demultiplexer (DeMUX)** is also known as a **data distributor**.

It has:

* One data input
* Multiple data outputs
* Select lines

For an `N`-output Demultiplexer:

**Number of Select Lines = log₂(N)**

### Examples

| Demultiplexer | Data Input | Select Lines | Outputs |
| ------------- | ---------: | -----------: | ------: |
| 1:2           |          1 |            1 |       2 |
| 1:4           |          1 |            2 |       4 |
| 1:8           |          1 |            3 |       8 |
| 1:16          |          1 |            4 |      16 |
| 1:32          |          1 |            5 |      32 |

---

## 2. Basic Demultiplexer Operation

```text
                    Select Lines
                       S1 S0
                        │ │
                        ▼ ▼
                 ┌─────────────┐
                 │             │──► Y0
                 │    1 : 4    │──► Y1
        IN ─────►│    DeMUX    │──► Y2
                 │             │──► Y3
                 └─────────────┘
```

The select lines determine which output receives the input.

Only one output is selected at a time.

---

## 3. 1-to-4 Demultiplexer

A 1:4 Demultiplexer contains:

* 1 data input
* 2 select lines
* 4 outputs

```text
                    ┌─────────────┐
                    │             │──► Y0
                    │             │──► Y1
        IN ────────►│    1 : 4    │──► Y2
                    │    DeMUX    │──► Y3
                    │             │
                    └─────────────┘
                       S1     S0
```

### Selection Table

|  S1 |  S0 | Selected Output |
| :-: | :-: | :-------------: |
|  0  |  0  |        Y0       |
|  0  |  1  |        Y1       |
|  1  |  0  |        Y2       |
|  1  |  1  |        Y3       |

If `IN = 1`:

|  S1 |  S0 |  IN |  Y3 |  Y2 |  Y1 |  Y0 |
| :-: | :-: | :-: | :-: | :-: | :-: | :-: |
|  0  |  0  |  1  |  0  |  0  |  0  |  1  |
|  0  |  1  |  1  |  0  |  0  |  1  |  0  |
|  1  |  0  |  1  |  0  |  1  |  0  |  0  |
|  1  |  1  |  1  |  1  |  0  |  0  |  0  |

If `IN = 0`, all outputs are `0`.

### Boolean Expressions

* **Y0 = IN · S1' · S0'**
* **Y1 = IN · S1' · S0**
* **Y2 = IN · S1 · S0'**
* **Y3 = IN · S1 · S0**

Therefore:

```text
S1 S0 = 00 → IN → Y0
S1 S0 = 01 → IN → Y1
S1 S0 = 10 → IN → Y2
S1 S0 = 11 → IN → Y3
```

---

## 4. 1-to-8 Demultiplexer

A 1:8 Demultiplexer contains:

* 1 data input
* 3 select lines
* 8 outputs

```text
                    ┌─────────────┐
                    │             │──► Y0
                    │             │──► Y1
                    │             │──► Y2
        IN ────────►│    1 : 8    │──► Y3
                    │    DeMUX    │──► Y4
                    │             │──► Y5
                    │             │──► Y6
                    │             │──► Y7
                    └─────────────┘
                       S2 S1 S0
```

### Selection Table

|  S2 |  S1 |  S0 | Selected Output |
| :-: | :-: | :-: | :-------------: |
|  0  |  0  |  0  |        Y0       |
|  0  |  0  |  1  |        Y1       |
|  0  |  1  |  0  |        Y2       |
|  0  |  1  |  1  |        Y3       |
|  1  |  0  |  0  |        Y4       |
|  1  |  0  |  1  |        Y5       |
|  1  |  1  |  0  |        Y6       |
|  1  |  1  |  1  |        Y7       |

### Boolean Expressions

* **Y0 = IN · S2' · S1' · S0'**
* **Y1 = IN · S2' · S1' · S0**
* **Y2 = IN · S2' · S1 · S0'**
* **Y3 = IN · S2' · S1 · S0**
* **Y4 = IN · S2 · S1' · S0'**
* **Y5 = IN · S2 · S1' · S0**
* **Y6 = IN · S2 · S1 · S0'**
* **Y7 = IN · S2 · S1 · S0**

---

## 5. Files in This Folder

```text
Basic_DeMUX/
├── 1by4.v
├── 1by4_tb.v
├── 1by8.v
├── 1by8_tb.v
└── README.md
```

| File        | Description                                   |
| ----------- | --------------------------------------------- |
| `1by4.v`    | RTL design of 1:4 Demultiplexer               |
| `1by4_tb.v` | Testbench for 1:4 Demultiplexer               |
| `1by8.v`    | RTL design of 1:8 Demultiplexer               |
| `1by8_tb.v` | Testbench for 1:8 Demultiplexer               |
| `README.md` | Documentation for basic Demultiplexer designs |

---

## 6. RTL Implementation

The Demultiplexers in this folder are **combinational RTL designs**.

The basic RTL operation is:

1. Initialize all outputs to `0`.
2. Check the select-line value.
3. Route the input to the selected output.
4. Keep all other outputs at `0`.

The designs can be implemented using:

* `always @(*)`
* `case`
* `if-else`
* Continuous assignments

---

## 7. Demultiplexer Using a Decoder

A Demultiplexer is closely related to a decoder.

A decoder generates an active output based on the select inputs. A Demultiplexer additionally uses the data input to control the selected output.

```text
                 S1 S0
                  │ │
                  ▼ ▼
             ┌──────────┐
             │ 2-to-4   │
             │ Decoder  │
             └────┬─────┘
                  │
          ┌───────┼───────┐
          ▼       ▼       ▼       ▼
         Y0      Y1      Y2      Y3
          │       │       │       │
          └───────┴──── IN ┴───────┘
```

This gives the relationship:

**Decoder + Data Input → Demultiplexer**

Understanding this relationship is useful when designing hierarchical Demultiplexers.

---

## 8. Other Implementation Methods for Practice

The current folder focuses on basic RTL implementations. The following approaches can be implemented as additional practice.

### 8.1 Gate-Level Implementation

A 1:4 Demultiplexer can be implemented using NOT and AND gates.

```text
Y0 = IN · S1' · S0'
Y1 = IN · S1' · S0
Y2 = IN · S1  · S0'
Y3 = IN · S1  · S0
```

### 8.2 NAND-Only Implementation

Implement the complete Demultiplexer using only NAND gates.

This helps in understanding universal-gate based digital design.

### 8.3 NOR-Only Implementation

Implement the complete Demultiplexer using only NOR gates.

This provides additional practice with universal logic gates.

### 8.4 Continuous Assignment

The Demultiplexer can be described using `assign` statements based on its Boolean expressions.

### 8.5 `if-else` Implementation

The select lines can be evaluated using conditional statements.

### 8.6 Conditional Operator

A Demultiplexer can also be implemented using the conditional operator.

### 8.7 Decoder-Based Implementation

Another useful implementation is to use a decoder to generate the output selection signals and then route the data input accordingly.

---

## 9. Demultiplexer Sizes to Practice

After implementing 1:4 and 1:8 Demultiplexers, the following designs can be practiced:

```text
1 : 2
1 : 4
1 : 8
1 : 16
1 : 32
1 : 64
```

| Demultiplexer | Select Lines |
| ------------- | -----------: |
| 1:2           |            1 |
| 1:4           |            2 |
| 1:8           |            3 |
| 1:16          |            4 |
| 1:32          |            5 |
| 1:64          |            6 |

---

## 10. Verification

Each RTL design has a corresponding testbench.

### 1:4 Demultiplexer

`1by4_tb.v` verifies all possible select-line combinations.

```text
1by4.v
   │
   ▼
1by4_tb.v
   │
   ├── IN = 0
   ├── IN = 1
   ├── S1S0 = 00
   ├── S1S0 = 01
   ├── S1S0 = 10
   └── S1S0 = 11
```

### 1:8 Demultiplexer

`1by8_tb.v` verifies all possible select-line combinations.

```text
1by8.v
   │
   ▼
1by8_tb.v
   │
   ├── IN = 0
   ├── IN = 1
   ├── S2S1S0 = 000
   ├── S2S1S0 = 001
   ├── S2S1S0 = 010
   ├── S2S1S0 = 011
   ├── S2S1S0 = 100
   ├── S2S1S0 = 101
   ├── S2S1S0 = 110
   └── S2S1S0 = 111
```

The testbench verifies that:

* Only the selected output receives the input.
* All unselected outputs remain `0`.
* Every possible select-line combination is tested.
* Both `IN = 0` and `IN = 1` are tested.

---

## 11. MUX vs Demultiplexer

| Feature        | Multiplexer    | Demultiplexer     |
| -------------- | -------------- | ----------------- |
| Function       | Many-to-One    | One-to-Many       |
| Data Inputs    | Multiple       | One               |
| Data Outputs   | One            | Multiple          |
| Select Lines   | Select input   | Select output     |
| Common Purpose | Data selection | Data distribution |

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

## 12. Applications

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

---

## 13. Learning Progression

```text
1:2 DeMUX
    │
    ▼
1:4 DeMUX
    │
    ▼
1:8 DeMUX
    │
    ▼
Hierarchical 1:16 DeMUX
    │
    ▼
Hierarchical 1:32 DeMUX
    │
    ▼
Parameterized DeMUX
    │
    ▼
Decoder-Based DeMUX
    │
    ▼
System-Level Applications
```

---

## 14. Key Concepts Practiced

This folder provides practice with:

* Combinational logic
* Demultiplexer operation
* Select-line decoding
* Truth tables
* Boolean expressions
* Behavioral RTL
* `always @(*)`
* `case` statements
* Output initialization
* Testbench development
* Select-line verification
* Decoder and Demultiplexer relationship
* Hierarchical digital design fundamentals

---

## Summary

The `Basic_DeMUX` folder contains fundamental **1:4** and **1:8 Demultiplexer** designs along with their corresponding testbenches.

```text
Basic DeMUX
     │
     ├── 1:4 DeMUX
     │
     └── 1:8 DeMUX
```

These designs provide the foundation for more advanced Demultiplexer implementations such as **hierarchical, parameterized, and decoder-based architectures**.
