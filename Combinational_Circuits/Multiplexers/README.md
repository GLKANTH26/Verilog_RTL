# Multiplexers

This directory contains **Verilog implementations of Multiplexers (MUXes)**, progressing from basic single-bit selection circuits to hierarchical large-input MUX architectures and parameterized multi-bit bus selection.

The implementations demonstrate different approaches to describing and constructing multiplexers, including **procedural case modeling, conditional/ternary modeling, hierarchical module instantiation, and parameterized vector selection**.

---

## 📂 Directory Structure

```text
Multiplexers/
│
├── Basic_MUX/
│   ├── 4by1.v
│   ├── 4by1_tb.v
│   ├── 8by1.v
│   ├── 8by1_tb.v
│   └── README.md
│
├── Hierarchical_MUX/
│   ├── 16by1_hier.v
│   ├── 16by1_hier_tb.v
│   ├── hier_32by1.v
│   ├── hier_32by1_tb.v
│   └── README.md
│
├── Parameterized_MUX/
│   ├── n_bit_bus.v
│   ├── n_bit_bus_tb.v
│   └── README.md
│
└── README.md
```

---

# 1. Basic MUX

The `Basic_MUX` directory contains fundamental single-bit MUX implementations.

The current designs include:

* **4:1 Multiplexer**
* **8:1 Multiplexer**

The 4:1 MUX is implemented using two different Verilog description styles:

* `case` statement
* Conditional/ternary operator

The 8:1 MUX is implemented using a `case` statement.

---

## 1.1 4:1 Multiplexer

A 4:1 MUX selects **one of four inputs** and forwards the selected input to the output.

### Inputs

```text
in[3:0]
```

### Select

```text
sel[1:0]
```

### Output

```text
y
```

The selection is:

| `sel` | Selected Input |
| :---: | -------------- |
|  `00` | `in[0]`        |
|  `01` | `in[1]`        |
|  `10` | `in[2]`        |
|  `11` | `in[3]`        |

### Implementations

The design contains two versions:

```text
mux4
mux4_t
```

`mux4` uses a `case` statement:

```verilog
case(sel)
    2'b00: y = in[0];
    2'b01: y = in[1];
    2'b10: y = in[2];
    2'b11: y = in[3];
endcase
```

`mux4_t` uses nested conditional operators:

```verilog
assign y = (sel == 2'b00) ? a :
           (sel == 2'b01) ? b :
           (sel == 2'b10) ? c : d;
```

This provides a direct comparison between **procedural selection logic and continuous conditional assignment**.

---

# 2. 8:1 Multiplexer

The 8:1 MUX selects one input from eight single-bit inputs.

### Inputs

```text
in[7:0]
```

### Select

```text
sel[2:0]
```

### Output

```text
y
```

The 3-bit select signal provides eight possible selections:

| `sel` | Selected Input |
| :---: | -------------- |
| `000` | `in[0]`        |
| `001` | `in[1]`        |
| `010` | `in[2]`        |
| `011` | `in[3]`        |
| `100` | `in[4]`        |
| `101` | `in[5]`        |
| `110` | `in[6]`        |
| `111` | `in[7]`        |

The implementation uses a `case` statement to describe the selection behavior.

---

# 3. Hierarchical MUX

The `Hierarchical_MUX` directory demonstrates how larger MUXes can be constructed by **instantiating smaller, previously designed MUX modules**.

Current implementations:

* **16:1 MUX using 4:1 MUXes**
* **32:1 MUX using 8:1 and 4:1 MUXes**

This demonstrates hierarchical and reusable RTL design.

---

# 4. 16:1 MUX Using 4:1 MUXes

The 16:1 MUX is constructed using **five 4:1 MUX stages**:

* Four 4:1 MUXes in the first stage
* One 4:1 MUX in the final stage

### Architecture

```text
                    sel[1:0]
                       │
        ┌──────────────┼──────────────┐
        │              │              │
        ▼              ▼              ▼
     ┌──────┐       ┌──────┐       ┌──────┐
     │ 4:1  │       │ 4:1  │  ...   │ 4:1  │
     │ MUX  │       │ MUX  │        │ MUX  │
     └──┬───┘       └──┬───┘        └──┬───┘
        │              │                │
       w0             w1               w2 ... w3
        │              │                │
        └──────────────┴────────────────┘
                       │
                    sel[3:2]
                       │
                       ▼
                    ┌──────┐
                    │ 4:1  │
                    │ MUX  │
                    └──┬───┘
                       │
                       ▼
                       y
```

The lower two select bits:

```text
sel[1:0]
```

select one input within each group of four.

The upper two bits:

```text
sel[3:2]
```

select which group-level result reaches the final output.

Thus:

```text
16 inputs
   ↓
4 groups × 4 inputs
   ↓
4 intermediate outputs
   ↓
Final 4:1 MUX
   ↓
1 output
```

This is a direct demonstration of **hierarchical MUX construction**.

---

# 5. 32:1 MUX Using 8:1 and 4:1 MUXes

The 32:1 MUX is constructed hierarchically using:

* Four 8:1 MUXes
* One 4:1 MUX

### Architecture

```text
                 32 Inputs
                     │
        ┌────────────┼────────────┐
        │            │            │
        ▼            ▼            ▼
      8:1 MUX      8:1 MUX      8:1 MUX ... 8:1 MUX
        │            │            │            │
       w[0]         w[1]         w[2]         w[3]
        └────────────┬────────────┬────────────┘
                     │
                  4:1 MUX
                     │
                     ▼
                     y
```

The lower three select bits:

```text
sel[2:0]
```

are connected to all four 8:1 MUXes.

These select one input from each group of eight.

The upper two bits:

```text
sel[4:3]
```

are supplied to the final 4:1 MUX to select one of the four intermediate outputs.

Therefore:

```text
sel[2:0] → Select input within each 8-input group

sel[4:3] → Select one of the four groups
```

This demonstrates how large MUXes can be constructed from smaller reusable MUX blocks.

---

# 6. Parameterized MUX

The `Parameterized_MUX` directory contains a generalized **N-to-1 bus multiplexer**.

Unlike the previous designs, which select a single bit, this implementation can select an entire **multi-bit data word**.

The module is parameterized by:

```verilog
parameter N = 8
parameter WIDTH = 8
```

where:

* `N` — Number of input words
* `WIDTH` — Width of each input word

The select width is automatically calculated using:

```verilog
localparam SEL_WIDTH = $clog2(N);
```

---

## 6.1 N-to-1 Bus Selection

The input is an array of `N` data words:

```verilog
input [WIDTH-1:0] in[0:N-1];
```

The output is:

```verilog
output [WIDTH-1:0] y;
```

The selected word is assigned using:

```verilog
assign y = in[sel];
```

Therefore, the MUX selects one complete `WIDTH`-bit input vector rather than a single bit.

### Example

For:

```verilog
N = 4
WIDTH = 8
```

the inputs can be:

```text
in[0] = 8'hAA
in[1] = 8'hBB
in[2] = 8'hCC
in[3] = 8'hDD
```

Then:

| `sel` | Output  |
| :---: | ------- |
|  `00` | `8'hAA` |
|  `01` | `8'hBB` |
|  `10` | `8'hCC` |
|  `11` | `8'hDD` |

This is effectively a **4-to-1, 8-bit-wide bus MUX**.

---

# 7. MUX Scaling Progression

The implementations demonstrate how MUX architectures can scale:

```text
4:1 MUX
   │
   ▼
8:1 MUX
   │
   ▼
16:1 MUX
   │
   ▼
32:1 MUX
   │
   ▼
Parameterized N-to-1 Bus MUX
```

The hierarchical designs demonstrate that a larger MUX does not necessarily need to be designed from scratch.

Instead:

```text
Small Verified MUX
        ↓
Module Instantiation
        ↓
Hierarchical MUX
        ↓
Larger Selection Network
```

---

# 8. Verification

Each implementation has a dedicated Verilog testbench.

The testbenches verify:

* Correct input selection
* Select-line behavior
* Different input patterns
* Hierarchical MUX operation
* Parameterized bus selection

The testbenches use:

```verilog
$fsdbDumpvars();
```

for FSDB waveform generation and:

```verilog
$monitor(...)
```

for simulation-time output monitoring.

### Verification Flow

```text
MUX RTL
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

# 9. Files

## `Basic_MUX`

### `4by1.v`

Contains:

* 4:1 MUX using a `case` statement
* 4:1 MUX using a ternary operator

### `4by1_tb.v`

Testbench for both 4:1 MUX implementations.

### `8by1.v`

Contains the 8:1 MUX using a `case` statement.

### `8by1_tb.v`

Testbench for the 8:1 MUX.

---

## `Hierarchical_MUX`

### `16by1_hier.v`

Contains the hierarchical 16:1 MUX constructed using 4:1 MUX modules.

### `16by1_hier_tb.v`

Testbench for the 16:1 hierarchical MUX.

### `hier_32by1.v`

Contains the hierarchical 32:1 MUX constructed using four 8:1 MUXes and one 4:1 MUX.

### `hier_32by1_tb.v`

Testbench for the 32:1 hierarchical MUX.

---

## `Parameterized_MUX`

### `n_bit_bus.v`

Contains the parameterized N-to-1 bus MUX.

### `n_bit_bus_tb.v`

Testbench for the parameterized bus MUX.

---

# 10. Concepts Covered

This MUX section covers:

* Multiplexer fundamentals
* 4:1 MUX
* 8:1 MUX
* 16:1 MUX
* 32:1 MUX
* `case`-based MUX modeling
* Ternary operator modeling
* Hierarchical module instantiation
* MUX decomposition
* Select-line partitioning
* Parameterized RTL
* `$clog2`
* Multi-bit bus selection
* Combinational logic
* Testbench development
* Functional simulation
* FSDB waveform analysis

---

# 11. Learning Path

| Stage | Implementation    | Primary Concept                   |
| ----- | ----------------- | --------------------------------- |
| 1     | 4:1 MUX — `case`  | Procedural MUX modeling           |
| 2     | 4:1 MUX — Ternary | Conditional operator modeling     |
| 3     | 8:1 MUX           | Larger basic MUX                  |
| 4     | 16:1 MUX          | Hierarchical MUX construction     |
| 5     | 32:1 MUX          | Multi-level hierarchical design   |
| 6     | N-to-1 Bus MUX    | Parameterized multi-bit selection |

---

## Key Design Principle

The MUX implementations demonstrate two important RTL design methodologies:

```text
                  Multiplexer Design
                         │
             ┌───────────┴───────────┐
             │                       │
             ▼                       ▼
      Direct Description       Hierarchical Design
             │                       │
       case / ternary          Module Instantiation
             │                       │
             ▼                       ▼
       Basic MUXes             Larger MUXes
                                     │
                                     ▼
                              Parameterized
                               Bus Selection
```

The overall progression demonstrates how a simple **single-bit selection circuit can be scaled into large hierarchical MUX networks and generalized into parameterized multi-bit datapath selection logic**.

