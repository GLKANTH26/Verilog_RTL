# Decoders

This folder contains different **Decoder** designs implemented using Verilog HDL.

The designs included in this folder cover basic decoder logic, hierarchical decoder design, and a practical BCD-to-7-segment display application.

---

## 1. What is a Decoder?

A **Decoder** is a combinational circuit that converts an `N`-bit binary input into one of up to `2^N` output lines.

For `N` input lines:

**Number of Outputs = 2^N**

For example:

| Decoder | Input Lines | Output Lines |
| ------- | ----------: | -----------: |
| 1-to-2  |           1 |            2 |
| 2-to-4  |           2 |            4 |
| 3-to-8  |           3 |            8 |
| 4-to-16 |           4 |           16 |
| 5-to-32 |           5 |           32 |

A decoder normally activates only one output for a particular input combination.

---

## 2. Basic Decoder Operation

A decoder can be represented as:

```text
              Input
            A1    A0
             │    │
             ▼    ▼
          ┌──────────┐
          │  2-to-4  │
    EN ──►│  Decoder │
          └────┬─────┘
               │
        ┌──────┼──────┐
        ▼      ▼      ▼      ▼
       Y0     Y1     Y2     Y3
```

The input combination determines which output is activated.

The enable input controls whether the decoder is active.

```text
EN = 0 → Decoder disabled → All outputs = 0

EN = 1 → Decoder enabled  → One output = 1
```

---

# 3. Designs Included

This folder contains three decoder designs:

```text
Decoders/
├── 2by4.v
├── 2by4_tb.v
├── hier_4by16.v
├── hier_4by16_tb.v
├── bcd.v
├── bcd_tb.v
└── README.md
```

| Design                       | RTL File       | Testbench         |
| ---------------------------- | -------------- | ----------------- |
| 2-to-4 Decoder               | `2by4.v`       | `2by4_tb.v`       |
| Hierarchical 4-to-16 Decoder | `hier_4by16.v` | `hier_4by16_tb.v` |
| BCD-to-7-Segment Decoder     | `bcd.v`        | `bcd_tb.v`        |

---

# 4. 2-to-4 Decoder

The `2by4.v` file contains a basic **2-to-4 Decoder**.

It has:

* 2 input lines
* 1 enable input
* 4 output lines

```text
Inputs  → 2
Enable  → 1
Outputs → 4
```

### Truth Table

|  EN |  A1 |  A0 |  Y3 |  Y2 |  Y1 |  Y0 |
| :-: | :-: | :-: | :-: | :-: | :-: | :-: |
|  0  |  X  |  X  |  0  |  0  |  0  |  0  |
|  1  |  0  |  0  |  0  |  0  |  0  |  1  |
|  1  |  0  |  1  |  0  |  0  |  1  |  0  |
|  1  |  1  |  0  |  0  |  1  |  0  |  0  |
|  1  |  1  |  1  |  1  |  0  |  0  |  0  |

Only one output is active when `EN = 1`.

### Boolean Expressions

**Y0 = EN · A1' · A0'**

**Y1 = EN · A1' · A0**

**Y2 = EN · A1 · A0'**

**Y3 = EN · A1 · A0**

Each output corresponds to one minterm of the two input variables.

---

# 5. 2-to-4 Decoder RTL

The `2by4.v` design is a combinational RTL implementation.

The decoder operation can be represented as:

```text
                 A1 A0
                  │ │
                  ▼ ▼
             ┌──────────┐
       EN ──►│ 2-to-4   │
             │ Decoder  │
             └────┬─────┘
                  │
          ┌───────┼───────┐
          ▼       ▼       ▼       ▼
         Y0      Y1      Y2      Y3
```

The design uses combinational logic to:

1. Check the enable signal.
2. Decode the input combination.
3. Activate the corresponding output.
4. Keep all other outputs at `0`.

---

# 6. Hierarchical 4-to-16 Decoder

The `hier_4by16.v` file demonstrates a **hierarchical decoder design**.

It contains:

* 4 input lines
* 1 enable input
* 16 output lines

Since:

**2⁴ = 16**

there are 16 possible output combinations.

---

## 7. Hierarchical Architecture

The 4-to-16 Decoder is constructed using multiple **2-to-4 Decoder** modules.

```text
                         A3 A2
                          │ │
                          ▼ ▼
                    ┌──────────┐
                    │ 2-to-4   │
                    │ Decoder  │
                    └────┬─────┘
                         │
                ┌────────┼────────┐
                ▼        ▼        ▼        ▼
              EN0      EN1      EN2      EN3
                │        │        │        │
                ▼        ▼        ▼        ▼
             ┌──────┐ ┌──────┐ ┌──────┐ ┌──────┐
             │2-to-4│ │2-to-4│ │2-to-4│ │2-to-4│
             │ Dec  │ │ Dec  │ │ Dec  │ │ Dec  │
             └──┬───┘ └──┬───┘ └──┬───┘ └──┬───┘
                │        │        │        │
              Y0-Y3    Y4-Y7    Y8-Y11   Y12-Y15
```

The upper two input bits determine which lower-level decoder is enabled.

The lower two input bits determine which output is activated inside the selected decoder.

---

## 8. Select-Line Organization

For the 4-to-16 Decoder:

```text
A3 A2 A1 A0
│  │  │  │
│  │  └──┴── Select output within the selected 2-to-4 Decoder
└──┴──────── Select one of four 2-to-4 Decoders
```

Therefore:

| Input Lines | Function                                      |
| ----------- | --------------------------------------------- |
| A3, A2      | Select one of the four lower-level decoders   |
| A1, A0      | Select one output within the selected decoder |

---

## 9. 4-to-16 Decoder Output Mapping

|  A3 |  A2 |  A1 |  A0 | Active Output |
| :-: | :-: | :-: | :-: | :-----------: |
|  0  |  0  |  0  |  0  |       Y0      |
|  0  |  0  |  0  |  1  |       Y1      |
|  0  |  0  |  1  |  0  |       Y2      |
|  0  |  0  |  1  |  1  |       Y3      |
|  0  |  1  |  0  |  0  |       Y4      |
|  0  |  1  |  0  |  1  |       Y5      |
|  0  |  1  |  1  |  0  |       Y6      |
|  0  |  1  |  1  |  1  |       Y7      |
|  1  |  0  |  0  |  0  |       Y8      |
|  1  |  0  |  0  |  1  |       Y9      |
|  1  |  0  |  1  |  0  |      Y10      |
|  1  |  0  |  1  |  1  |      Y11      |
|  1  |  1  |  0  |  0  |      Y12      |
|  1  |  1  |  0  |  1  |      Y13      |
|  1  |  1  |  1  |  0  |      Y14      |
|  1  |  1  |  1  |  1  |      Y15      |

When `EN = 0`, all outputs remain `0`.

---

# 10. BCD-to-7-Segment Decoder

The `bcd.v` file demonstrates an application of decoder logic: a **BCD-to-7-Segment Decoder**.

It accepts a 4-bit BCD input and generates the corresponding seven-segment display pattern.

```text
              BCD Input
             A3 A2 A1 A0
                  │
                  ▼
           ┌──────────────┐
           │ BCD-to-7-    │
       EN ─► Segment      │
           │   Decoder    │
           └──────┬───────┘
                  │
            a b c d e f g
                  │
                  ▼
             7-Segment
              Display
```

---

## 11. BCD Input

BCD represents decimal digits from `0` to `9`.

| Decimal |  BCD |
| ------: | :--: |
|       0 | 0000 |
|       1 | 0001 |
|       2 | 0010 |
|       3 | 0011 |
|       4 | 0100 |
|       5 | 0101 |
|       6 | 0110 |
|       7 | 0111 |
|       8 | 1000 |
|       9 | 1001 |

The remaining four combinations are invalid BCD inputs:

```text
1010
1011
1100
1101
1110
1111
```

These invalid combinations are handled separately by the RTL design.

---

# 12. Seven-Segment Output

The seven-segment display contains seven individual segments:

```text
      ─── a ───
     │         │
     f         b
     │         │
      ─── g ───
     │         │
     e         c
     │         │
      ─── d ───
```

The output signals are:

```text
a b c d e f g
```

The decoder generates the appropriate segment pattern for each BCD digit.

| Decimal |  BCD | Segments `abcdefg` |
| ------: | :--: | :----------------: |
|       0 | 0000 |       1111110      |
|       1 | 0001 |       0000110      |
|       2 | 0010 |       1101101      |
|       3 | 0011 |       1111001      |
|       4 | 0100 |       0110011      |
|       5 | 0101 |       1011011      |
|       6 | 0110 |       1011111      |
|       7 | 0111 |       1110000      |
|       8 | 1000 |       1111111      |
|       9 | 1001 |       1111011      |

---

# 13. Decoder Verification

Each decoder design has a corresponding testbench.

### 2-to-4 Decoder

`2by4_tb.v` verifies:

* Decoder disabled condition
* All four input combinations
* Correct output activation
* Enable functionality

```text
00 → Y0
01 → Y1
10 → Y2
11 → Y3
```

### 4-to-16 Decoder

`hier_4by16_tb.v` verifies:

* 4-bit input combinations
* Enable functionality
* Hierarchical output selection
* Correct output activation

There are:

**2⁴ = 16**

possible input combinations.

### BCD-to-7-Segment Decoder

`bcd_tb.v` verifies:

* Enable functionality
* Valid BCD digits from `0` to `9`
* Seven-segment output patterns
* Invalid BCD input handling

---

# 14. Decoder vs Demultiplexer

Decoders and Demultiplexers are closely related, but their primary purposes are different.

| Feature            | Decoder                        | Demultiplexer                      |
| ------------------ | ------------------------------ | ---------------------------------- |
| Main Function      | Binary code to selected output | Route one data input to an output  |
| Data Input         | No separate data input         | One data input                     |
| Select/Input Lines | Binary input                   | Select lines                       |
| Enable             | Commonly used                  | May be used                        |
| Output             | Selected output is activated   | Selected output carries input data |
| Common Application | Address decoding               | Data distribution                  |

A Demultiplexer can be viewed as a decoder combined with a data input.

---

# 15. Decoder Implementation Methods

Decoders can be implemented using different approaches.

### Behavioral RTL

Using:

* `always @(*)`
* `if`
* `case`

### Dataflow RTL

Using continuous assignments and Boolean expressions.

### Gate-Level Design

Using:

* NOT gates
* AND gates
* OR gates

### Hierarchical Design

Constructing larger decoders using smaller decoder modules.

### Parameterized Design

Creating configurable decoders with adjustable input and output sizes.

### Application-Specific Decoders

Examples include:

* BCD-to-7-segment decoder
* Address decoder
* Instruction decoder
* Memory decoder
* Control signal decoder

---

# 16. Common Decoder Sizes

| Decoder | Input Lines | Output Lines |
| ------- | ----------: | -----------: |
| 1-to-2  |           1 |            2 |
| 2-to-4  |           2 |            4 |
| 3-to-8  |           3 |            8 |
| 4-to-16 |           4 |           16 |
| 5-to-32 |           5 |           32 |
| 6-to-64 |           6 |           64 |

The general relationship is:

**Number of Outputs = 2^N**

where `N` is the number of input lines.

---

# 17. Applications of Decoders

Decoders are commonly used in:

* Memory address decoding
* Register selection
* Instruction decoding
* Control signal generation
* Peripheral selection
* Chip selection
* Display driving
* BCD-to-7-segment conversion
* Data routing
* Digital system control

---

# 18. Learning Progression

The designs in this folder follow a progressive learning path:

```text
Basic 2-to-4 Decoder
        │
        ▼
Enable-Controlled Decoder
        │
        ▼
Hierarchical 4-to-16 Decoder
        │
        ▼
BCD-to-7-Segment Decoder
        │
        ▼
Parameterized Decoder
        │
        ▼
Address / Instruction Decoders
        │
        ▼
System-Level Applications
```

---

# 19. Key Concepts Practiced

This folder provides practice with:

* Combinational logic
* Decoder operation
* Binary-to-one-hot conversion
* Enable control
* Truth tables
* Boolean expressions
* Minterms
* `always @(*)`
* `case` statements
* Hierarchical RTL
* Module instantiation
* Module reuse
* BCD decoding
* Seven-segment display control
* Testbench development
* Exhaustive verification
* Application-oriented RTL design

---

# 20. Future Practice

Additional decoder designs that can be explored include:

```text
1-to-2 Decoder
2-to-4 Decoder
3-to-8 Decoder
4-to-16 Decoder
5-to-32 Decoder
6-to-64 Decoder
```

Additional applications include:

```text
Address Decoder
Instruction Decoder
Memory Decoder
Register Decoder
Peripheral Decoder
Control Signal Decoder
BCD-to-7-Segment Decoder
```

---

## Summary

The `Decoders` folder contains a collection of decoder designs ranging from a basic **2-to-4 Decoder** to a **hierarchical 4-to-16 Decoder** and a practical **BCD-to-7-Segment Decoder**.

```text
                         Decoders
                            │
             ┌──────────────┼──────────────┐
             │              │              │
             ▼              ▼              ▼
        2-to-4 Decoder  4-to-16 Decoder  BCD Decoder
             │              │              │
             ▼              ▼              ▼
        Basic Logic     Hierarchical    7-Segment
                           Design         Application
```

The main objective of this folder is to develop a strong understanding of **decoder operation, enable control, binary-to-one-hot conversion, hierarchical RTL design, module reuse, BCD decoding, and practical digital system applications**.

