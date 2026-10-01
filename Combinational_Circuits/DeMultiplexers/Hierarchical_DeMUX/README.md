# Hierarchical Demultiplexers

This folder contains a **hierarchical 1-to-16 Demultiplexer (DeMUX)** design implemented using smaller Demultiplexer modules.

Hierarchical design is an important RTL design technique in which a larger digital circuit is constructed by **connecting multiple smaller, already-designed modules**.

---

## 1. What is a Hierarchical Demultiplexer?

A hierarchical Demultiplexer builds a larger Demultiplexer using smaller Demultiplexer blocks.

Instead of directly designing a 1:16 Demultiplexer from scratch, a 1:16 Demultiplexer can be constructed using multiple smaller DeMUX modules.

For example:

```text
1:4 DeMUX
    +
1:4 DeMUX
    +
1:4 DeMUX
    +
1:4 DeMUX
    +
Selection Logic
    ↓
1:16 DeMUX
```

This approach improves:

* Modularity
* Code reusability
* Design readability
* Verification
* Scalability
* Maintainability

---

## 2. 1-to-16 Demultiplexer

A 1:16 Demultiplexer contains:

* 1 data input
* 4 select lines
* 16 outputs

The number of select lines is:

$$
\log_2(16)=4
$$

Therefore:

```text
Data Input  →  1
Select Lines →  4
Outputs      →  16
```

---

## 3. Hierarchical Architecture

A 1:16 Demultiplexer can be constructed using **four 1:4 Demultiplexers**.

```text
                         S3 S2
                          │ │
                          ▼ ▼
                    ┌────────────┐
                    │ Selection  │
                    │   Logic    │
                    └─────┬──────┘
                          │
              ┌───────────┼───────────┐
              │           │           │
              ▼           ▼           ▼
             EN0         EN1         EN2       EN3
              │           │           │         │
              ▼           ▼           ▼         ▼
          ┌───────┐   ┌───────┐   ┌───────┐ ┌───────┐
IN ──────►│ 1:4   │   │ 1:4   │   │ 1:4   │ │ 1:4   │
          │ DeMUX │   │ DeMUX │   │ DeMUX │ │ DeMUX │
          └───┬───┘   └───┬───┘   └───┬───┘ └───┬───┘
              │           │           │         │
           Y0-Y3       Y4-Y7       Y8-Y11    Y12-Y15
```

The lower two select bits select an output **within each 1:4 Demultiplexer**, while the upper two select bits select **which 1:4 Demultiplexer is enabled**.

---

## 4. Select-Line Organization

For a 1:16 Demultiplexer:

```text
S3 S2 S1 S0
│  │  │  │
│  │  └──┴── Select output within 1:4 DeMUX
└──┴──────── Select one of four 1:4 DeMUX blocks
```

Therefore:

| Select Lines | Purpose                                         |
| ------------ | ----------------------------------------------- |
| S3, S2       | Select one of the four 1:4 DeMUX blocks         |
| S1, S0       | Select one output within the selected 1:4 DeMUX |

---

## 5. Block Selection

The upper two select lines determine which 1:4 Demultiplexer receives the data.

|  S3 |  S2 | Selected DeMUX | Output Group |
| :-: | :-: | :------------: | :----------: |
|  0  |  0  |     DeMUX 0    |     Y0-Y3    |
|  0  |  1  |     DeMUX 1    |     Y4-Y7    |
|  1  |  0  |     DeMUX 2    |    Y8-Y11    |
|  1  |  1  |     DeMUX 3    |    Y12-Y15   |

The lower two select lines then determine the exact output inside the selected block.

---

## 6. Output Selection

The complete 4-bit select value determines one of the sixteen outputs.

|  S3 |  S2 |  S1 |  S0 | Selected Output |
| :-: | :-: | :-: | :-: | :-------------: |
|  0  |  0  |  0  |  0  |        Y0       |
|  0  |  0  |  0  |  1  |        Y1       |
|  0  |  0  |  1  |  0  |        Y2       |
|  0  |  0  |  1  |  1  |        Y3       |
|  0  |  1  |  0  |  0  |        Y4       |
|  0  |  1  |  0  |  1  |        Y5       |
|  0  |  1  |  1  |  0  |        Y6       |
|  0  |  1  |  1  |  1  |        Y7       |
|  1  |  0  |  0  |  0  |        Y8       |
|  1  |  0  |  0  |  1  |        Y9       |
|  1  |  0  |  1  |  0  |       Y10       |
|  1  |  0  |  1  |  1  |       Y11       |
|  1  |  1  |  0  |  0  |       Y12       |
|  1  |  1  |  0  |  1  |       Y13       |
|  1  |  1  |  1  |  0  |       Y14       |
|  1  |  1  |  1  |  1  |       Y15       |

---

## 7. Example

Consider:

```text
IN = 1
S3 S2 S1 S0 = 1 0 1 1
```

The upper two select bits are:

```text
S3 S2 = 10
```

Therefore, the third 1:4 DeMUX is selected.

The lower two bits are:

```text
S1 S0 = 11
```

Therefore, output `Y11` is selected.

Result:

```text
IN = 1
S3S2S1S0 = 1011

              ┌─────────────┐
IN = 1 ──────►│ 1:16 DeMUX  │──► Y11 = 1
              └─────────────┘
```

All other outputs remain `0`.

---

## 8. Files in This Folder

```text
Hierarchical_DeMUX/
├── hier_1by16.v
├── hier_1by16_tb.v
└── README.md
```

| File              | Description                                       |
| ----------------- | ------------------------------------------------- |
| `hier_1by16.v`    | Hierarchical 1:16 Demultiplexer RTL design        |
| `hier_1by16_tb.v` | Testbench for the hierarchical 1:16 Demultiplexer |
| `README.md`       | Documentation for the hierarchical Demultiplexer  |

---

## 9. Hierarchical RTL Concept

The main idea behind the RTL implementation is to instantiate smaller DeMUX modules inside the larger DeMUX module.

Conceptually:

```text
                hier_1by16
                     │
       ┌─────────────┼─────────────┐
       │             │             │
       ▼             ▼             ▼
    1:4 DeMUX     1:4 DeMUX     1:4 DeMUX     1:4 DeMUX
       │             │             │             │
       ▼             ▼             ▼             ▼
     Y0-Y3         Y4-Y7         Y8-Y11       Y12-Y15
```

This demonstrates **module instantiation and hierarchical design** in Verilog.

---

## 10. Why Use Hierarchical Design?

Hierarchical RTL design provides several advantages.

### Modularity

A complex design can be divided into smaller blocks.

### Reusability

An already-tested 1:4 DeMUX can be reused to build larger DeMUX structures.

### Easier Verification

Each smaller module can be verified independently before being used in a larger design.

### Scalability

The same design approach can be extended to larger Demultiplexers.

### Maintainability

Changes to a lower-level module can be reflected wherever that module is instantiated.

---

## 11. Verification

The testbench `hier_1by16_tb.v` verifies the hierarchical 1:16 Demultiplexer.

The verification should cover:

* `IN = 0`
* `IN = 1`
* All 16 possible select combinations
* Correct output selection
* All unselected outputs remaining `0`

The complete selection space is:

```text
0000 → Y0
0001 → Y1
0010 → Y2
0011 → Y3

0100 → Y4
0101 → Y5
0110 → Y6
0111 → Y7

1000 → Y8
1001 → Y9
1010 → Y10
1011 → Y11

1100 → Y12
1101 → Y13
1110 → Y14
1111 → Y15
```

---

## 12. Hierarchical vs Basic Demultiplexer

| Feature      | Basic DeMUX           | Hierarchical DeMUX         |
| ------------ | --------------------- | -------------------------- |
| Design       | Direct implementation | Built from smaller modules |
| Example      | 1:4, 1:8              | 1:16                       |
| Module Reuse | Limited               | High                       |
| Modularity   | Lower                 | Higher                     |
| Scalability  | Limited               | Better                     |
| Verification | Direct                | Block-level + top-level    |
| Main Concept | DeMUX logic           | Hierarchical RTL design    |

---

## 13. Other Hierarchical Designs to Practice

After implementing the hierarchical 1:16 Demultiplexer, the following designs can be practiced:

### 1:8 using 1:2 Demultiplexers

```text
1:2 DeMUX
     │
     ▼
1:4 DeMUX
     │
     ▼
1:8 DeMUX
```

### 1:16 using 1:2 Demultiplexers

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
1:16 DeMUX
```

### 1:32 using 1:4 Demultiplexers

```text
1:4 DeMUX
     │
     ▼
1:16 DeMUX
     │
     ▼
1:32 DeMUX
```

These exercises provide practice with recursive and multi-level hierarchical design.

---

## 14. Other Implementation Approaches

The same 1:16 Demultiplexer can also be implemented using different architectures for practice:

* Direct behavioral RTL
* Gate-level implementation
* Decoder-based implementation
* 1:2 DeMUX hierarchy
* 1:4 DeMUX hierarchy
* Parameterized Demultiplexer
* Generate-based hierarchical implementation
* Recursive hierarchical implementation
* One-hot selection
* Case-based implementation

---

## 15. Hierarchical Design Flow

```text
Design Small Module
        │
        ▼
Verify Small Module
        │
        ▼
Instantiate Small Modules
        │
        ▼
Connect Modules
        │
        ▼
Create Larger Module
        │
        ▼
Verify Top-Level Design
```

This design methodology is widely applicable to larger RTL systems.

---

## 16. Key Concepts Practiced

This folder provides practice with:

* Hierarchical RTL design
* Module instantiation
* Module reuse
* Combinational logic
* Demultiplexer architecture
* Select-line organization
* Multi-level selection
* Structural RTL
* Block-level design
* Top-level integration
* Testbench development
* Hierarchical verification
* Scalable digital design

---

## 17. Learning Progression

```text
Basic 1:2 DeMUX
       │
       ▼
Basic 1:4 DeMUX
       │
       ▼
Basic 1:8 DeMUX
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
Complex RTL Applications
```

---

## Summary

The `Hierarchical_DeMUX` folder demonstrates how a larger **1:16 Demultiplexer** can be constructed by reusing smaller Demultiplexer modules.

```text
              Hierarchical 1:16 DeMUX
                       │
        ┌──────────────┼──────────────┐
        │              │              │
        ▼              ▼              ▼
     1:4 DeMUX      1:4 DeMUX      1:4 DeMUX      1:4 DeMUX
        │              │              │              │
        ▼              ▼              ▼              ▼
      Y0-Y3          Y4-Y7          Y8-Y11        Y12-Y15
```

The main objective of this folder is to understand **hierarchical module construction, module reuse, structural RTL, select-line organization, and top-level verification**.

