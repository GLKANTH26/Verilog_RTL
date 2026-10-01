# Encoders

This folder contains different **Encoder** designs implemented using Verilog HDL.

The designs cover a basic **4-to-2 Encoder**, a **4-to-2 Priority Encoder**, and a **hierarchical 8-to-3 Priority Encoder**.

---

## 1. What is an Encoder?

An **Encoder** is a combinational circuit that converts an active input line into its corresponding binary code.

An encoder performs the reverse operation of a decoder.

For an encoder with `2^N` input lines, the output contains `N` binary bits.

For example:

| Encoder | Input Lines | Output Lines |
| ------- | ----------: | -----------: |
| 2-to-1  |           2 |            1 |
| 4-to-2  |           4 |            2 |
| 8-to-3  |           8 |            3 |
| 16-to-4 |          16 |            4 |

---

## 2. Basic Encoder Operation

A 4-to-2 Encoder has:

* 4 input lines
* 2 output lines
* 1 enable input in this implementation

```text
                  ┌───────────┐
       I0 ───────►│           │
       I1 ───────►│   4-to-2  │──► Y1
       I2 ───────►│  Encoder  │──► Y0
       I3 ───────►│           │
                  └───────────┘
                       ▲
                       │
                      EN
```

When the encoder is enabled and exactly one input is active, the output represents the binary position of that active input.

---

# 3. 4-to-2 Encoder

The `4by2.v` file contains a basic **4-to-2 Encoder**.

It has:

```text
Inputs  → 4
Outputs → 2
Enable  → 1
```

The input lines represent four possible positions.

### Truth Table

|  EN |  I3 |  I2 |  I1 |  I0 |  Y1 |  Y0 |
| :-: | :-: | :-: | :-: | :-: | :-: | :-: |
|  0  |  X  |  X  |  X  |  X  |  0  |  0  |
|  1  |  0  |  0  |  0  |  1  |  0  |  0  |
|  1  |  0  |  0  |  1  |  0  |  0  |  1  |
|  1  |  0  |  1  |  0  |  0  |  1  |  0  |
|  1  |  1  |  0  |  0  |  0  |  1  |  1  |

The basic encoder assumes that **only one input is active at a time**.

---

## 4. 4-to-2 Encoder Mapping

The input-to-output relationship is:

```text
I0 = 1 → Y = 00
I1 = 1 → Y = 01
I2 = 1 → Y = 10
I3 = 1 → Y = 11
```

Therefore, the encoder converts the active input position into its corresponding binary value.

---

## 5. 4-to-2 Encoder RTL

The `4by2.v` design uses combinational RTL with:

* `always @(*)`
* Enable control
* `case` statement
* Default handling for invalid input combinations

Conceptually:

```text
                 Input
             I3 I2 I1 I0
              │  │  │  │
              ▼  ▼  ▼  ▼
             ┌──────────┐
        EN ─►│  4-to-2  │
             │  Encoder │
             └────┬─────┘
                  │
                 Y1 Y0
```

For a valid one-hot input, the corresponding binary code is produced.

---

# 6. Invalid Input Conditions

A basic encoder assumes that only one input is active.

For example:

```text
0001 → Valid
0010 → Valid
0100 → Valid
1000 → Valid
```

However, inputs such as:

```text
0011
0110
1111
```

have multiple active inputs.

These combinations do not have a unique output for a normal encoder.

The implementation therefore handles such combinations separately.

---

# 7. 4-to-2 Priority Encoder

The `prenc4by2.v` file contains a **4-to-2 Priority Encoder**.

Unlike a basic encoder, a priority encoder allows multiple inputs to be active simultaneously.

When multiple inputs are active, the encoder selects the input with the **highest priority**.

In this implementation:

```text
I3 → Highest Priority
I2
I1
I0 → Lowest Priority
```

Therefore:

```text
I3 > I2 > I1 > I0
```

---

## 8. Priority Encoder Operation

The priority encoder checks the inputs from highest priority to lowest priority.

```text
I3 active?
   │
   ├── Yes → Output 11
   │
   └── No
        │
        ▼
     I2 active?
        │
        ├── Yes → Output 10
        │
        └── No
             │
             ▼
          I1 active?
             │
             ├── Yes → Output 01
             │
             └── No
                  │
                  ▼
               I0 active?
                  │
                  ├── Yes → Output 00
                  │
                  └── No → Invalid / No input
```

---

## 9. Priority Encoder Truth Table

|  EN |  I3 |  I2 |  I1 |  I0 | Valid |  Y1 |  Y0 |
| :-: | :-: | :-: | :-: | :-: | :---: | :-: | :-: |
|  0  |  X  |  X  |  X  |  X  |   0   |  X  |  X  |
|  1  |  0  |  0  |  0  |  0  |   0   |  X  |  X  |
|  1  |  0  |  0  |  0  |  1  |   1   |  0  |  0  |
|  1  |  0  |  0  |  1  |  X  |   1   |  0  |  1  |
|  1  |  0  |  1  |  X  |  X  |   1   |  1  |  0  |
|  1  |  1  |  X  |  X  |  X  |   1   |  1  |  1  |

`X` indicates that the lower-priority inputs do not affect the result once a higher-priority input is active.

---

# 10. Valid Output

The priority encoder includes a `valid` output.

The `valid` signal indicates whether at least one input is active while the encoder is enabled.

```text
valid = 1 → A valid input is present
valid = 0 → No valid input is present
```

Conceptually:

```text
                ┌──────────────┐
 I3 ───────────►│              │
 I2 ───────────►│   Priority   │──► Y1
 I1 ───────────►│   Encoder    │──► Y0
 I0 ───────────►│              │──► valid
                └──────────────┘
                       ▲
                       │
                      EN
```

---

# 11. Hierarchical 8-to-3 Priority Encoder

The `hier_8by3.v` file demonstrates a **hierarchical 8-to-3 Priority Encoder**.

Instead of designing the complete 8-to-3 priority encoder directly, the design reuses two **4-to-2 Priority Encoder** modules.

```text
Input Lines  → 8
Output Lines → 3
Enable       → 1
```

---

## 12. Hierarchical Architecture

The 8 inputs are divided into two groups:

```text
Lower Group → I3 I2 I1 I0
Upper Group → I7 I6 I5 I4
```

Each group is processed by a 4-to-2 priority encoder.

```text
                    8-to-3 Priority Encoder
                             │
              ┌──────────────┴──────────────┐
              │                             │
              ▼                             ▼
       ┌─────────────┐               ┌─────────────┐
       │ 4-to-2      │               │ 4-to-2      │
       │ Priority    │               │ Priority    │
       │ Encoder     │               │ Encoder     │
       └──────┬──────┘               └──────┬──────┘
              │                             │
          I3-I0                          I7-I4
              │                             │
              └──────────────┬──────────────┘
                             ▼
                       Output Selection
                             │
                             ▼
                            Y[2:0]
```

The upper group has priority over the lower group.

---

# 13. Priority Between Encoder Blocks

The two lower-level priority encoders generate:

```text
y_low
v_low

y_high
v_high
```

The upper group is given higher priority.

Therefore:

```text
If v_high = 1
    Select upper encoder

Else if v_low = 1
    Select lower encoder

Else
    No valid input
```

The final output is constructed as:

```text
Upper group selected → Y = {1'b1, y_high}

Lower group selected → Y = {1'b0, y_low}
```

---

# 14. 8-to-3 Priority Mapping

The priority order is:

```text
I7 > I6 > I5 > I4 > I3 > I2 > I1 > I0
```

Therefore:

| Highest Active Input | Output |
| :------------------: | :----: |
|          I0          |   000  |
|          I1          |   001  |
|          I2          |   010  |
|          I3          |   011  |
|          I4          |   100  |
|          I5          |   101  |
|          I6          |   110  |
|          I7          |   111  |

If multiple inputs are active, the highest-priority active input determines the output.

For example:

```text
Input = 00011000
```

Both `I4` and `I3` are active.

Since:

```text
I4 > I3
```

the output corresponds to `I4`:

```text
Y = 100
```

---

# 15. Files in This Folder

```text
Encoders/
├── 4by2.v
├── 4by2_tb.v
├── prenc4by2.v
├── prenc4by2_tb.v
├── hier_8by3.v
├── hier_8by3_tb.v
└── README.md
```

| File             | Description                                            |
| ---------------- | ------------------------------------------------------ |
| `4by2.v`         | Basic 4-to-2 Encoder                                   |
| `4by2_tb.v`      | Testbench for the 4-to-2 Encoder                       |
| `prenc4by2.v`    | 4-to-2 Priority Encoder                                |
| `prenc4by2_tb.v` | Testbench for the 4-to-2 Priority Encoder              |
| `hier_8by3.v`    | Hierarchical 8-to-3 Priority Encoder                   |
| `hier_8by3_tb.v` | Testbench for the hierarchical 8-to-3 Priority Encoder |
| `README.md`      | Documentation for the Encoder designs                  |

---

# 16. Verification

Each encoder design has a corresponding testbench.

### 4-to-2 Encoder

`4by2_tb.v` tests:

* Enabled operation
* Valid one-hot inputs
* Invalid multiple-input condition
* Disabled operation

### 4-to-2 Priority Encoder

`prenc4by2_tb.v` tests:

* Valid single-input conditions
* Multiple active inputs
* Priority operation
* No active input
* Disabled operation
* `valid` output

### 8-to-3 Priority Encoder

`hier_8by3_tb.v` tests:

* Lower-group inputs
* Upper-group inputs
* Multiple active inputs
* Priority between groups
* No active input
* Disabled operation
* `valid` output

---

# 17. Encoder vs Decoder

An Encoder and Decoder perform opposite types of binary conversion.

| Feature      | Encoder                      | Decoder                   |
| ------------ | ---------------------------- | ------------------------- |
| Function     | One-of-many → Binary code    | Binary code → One-of-many |
| Example      | 4-to-2                       | 2-to-4                    |
| Inputs       | More                         | Fewer                     |
| Outputs      | Fewer                        | More                      |
| Main Purpose | Encode active input position | Decode binary input       |
| Common Use   | Priority logic, interrupts   | Address/control decoding  |

### Encoder

```text
I0 ──┐
I1 ──┤
I2 ──┤──► Encoder ──► Binary Code
I3 ──┘
```

### Decoder

```text
Binary Code ──► Decoder ──► Y0
                         ├──► Y1
                         ├──► Y2
                         └──► Y3
```

---

# 18. Basic Encoder vs Priority Encoder

| Feature                | Basic Encoder    | Priority Encoder        |
| ---------------------- | ---------------- | ----------------------- |
| Multiple active inputs | Not supported    | Supported               |
| Priority               | No               | Yes                     |
| Valid signal           | Not necessarily  | Commonly used           |
| Input requirement      | One active input | One or more inputs      |
| Example                | 4-to-2           | 4-to-2 Priority Encoder |
| Main Purpose           | Binary encoding  | Priority-based encoding |

A priority encoder is particularly useful when multiple request signals can become active at the same time.

---

# 19. Implementation Methods

Encoders can be implemented using different approaches.

### Behavioral RTL

Using:

* `always @(*)`
* `if-else`
* `case`

### Dataflow RTL

Using Boolean expressions and continuous assignments.

### Gate-Level Design

Using:

* AND gates
* OR gates
* NOT gates

### Priority Logic

Using ordered `if-else` conditions where the highest-priority input is checked first.

### Hierarchical Design

Constructing larger encoders using smaller encoder modules.

### Parameterized Design

Creating configurable encoders with adjustable input and output sizes.

---

# 20. Common Encoder Sizes

| Encoder | Input Lines | Output Lines |
| ------- | ----------: | -----------: |
| 2-to-1  |           2 |            1 |
| 4-to-2  |           4 |            2 |
| 8-to-3  |           8 |            3 |
| 16-to-4 |          16 |            4 |
| 32-to-5 |          32 |            5 |
| 64-to-6 |          64 |            6 |

The general relationship is:

**Number of Inputs = 2^(Number of Outputs)**

---

# 21. Applications of Encoders

Encoders are commonly used in:

* Interrupt priority systems
* Bus arbitration
* Request prioritization
* Keyboard encoding
* Digital control systems
* Data compression
* One-hot to binary conversion
* Resource selection
* Priority-based control logic
* Processor and peripheral control systems

---

# 22. Learning Progression

The designs in this folder follow a progressive learning path:

```text
Basic 4-to-2 Encoder
        │
        ▼
Multiple-Input Conditions
        │
        ▼
4-to-2 Priority Encoder
        │
        ▼
Valid Signal
        │
        ▼
Hierarchical 8-to-3 Priority Encoder
        │
        ▼
Larger Priority Encoders
        │
        ▼
System-Level Applications
```

---

# 23. Key Concepts Practiced

This folder provides practice with:

* Combinational logic
* Encoder operation
* Binary encoding
* One-hot to binary conversion
* Priority logic
* Enable control
* Valid signal generation
* `always @(*)`
* `case` statements
* `if-else` priority logic
* Hierarchical RTL
* Module instantiation
* Module reuse
* Testbench development
* Priority verification
* Application-oriented RTL design

---

# 24. Future Practice

Additional encoder designs that can be explored include:

```text
2-to-1 Encoder
4-to-2 Encoder
8-to-3 Encoder
16-to-4 Encoder
32-to-5 Encoder
64-to-6 Encoder
```

Additional priority encoder designs:

```text
4-to-2 Priority Encoder
8-to-3 Priority Encoder
16-to-4 Priority Encoder
32-to-5 Priority Encoder
```

Other applications:

```text
Interrupt Priority Encoder
Bus Arbitration
Request Priority Logic
Keyboard Encoder
One-Hot to Binary Converter
Resource Selection Logic
```

---

## Summary

The `Encoders` folder contains a progressive collection of Encoder designs, starting with a basic **4-to-2 Encoder**, followed by a **4-to-2 Priority Encoder**, and finally a **hierarchical 8-to-3 Priority Encoder**.

```text
                         Encoders
                            │
             ┌──────────────┼──────────────┐
             │              │              │
             ▼              ▼              ▼
        4-to-2 Encoder  Priority Encoder  Hierarchical
                             │             8-to-3 Encoder
                             ▼
                         4-to-2
```

The main objective of this folder is to develop a strong understanding of **binary encoding, priority logic, valid signal generation, hierarchical RTL design, module reuse, and practical priority-based digital logic**.

