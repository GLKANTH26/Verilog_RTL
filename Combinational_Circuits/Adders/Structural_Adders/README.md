# Structural Adders

This directory contains **structural Verilog implementations of binary adders**, where a higher-level arithmetic circuit is constructed by **instantiating and interconnecting lower-level modules**.

The primary implementation demonstrates a **Full Adder constructed using two Half Adders and an OR gate**.

---

## 1. Full Adder Using Half Adders

A Full Adder accepts three single-bit inputs:

* `a`
* `b`
* `c_in`

and produces:

* `sum`
* `c_out`

Instead of directly describing the Full Adder equations, the design builds the circuit hierarchically from **two Half Adder modules**.

### Structure

```text
                    ┌──────────────┐
             a ────►│              │
                    │  Half Adder  │───► w_sum1
             b ────►│     HA1      │
                    │              │───► w_cout1
                    └──────────────┘
                           │
                           │ w_sum1
                           ▼
                    ┌──────────────┐
             c_in ─►│              │
                    │  Half Adder  │───► sum
             w_sum1 ►│     HA2      │
                    │              │───► w_cout2
                    └──────────────┘

                 w_cout1 ───┐
                            ▼
                           OR ───► c_out
                            ▲
                 w_cout2 ───┘
```

### Operation

The first Half Adder adds `a` and `b`:

```text
w_sum1  = a ⊕ b
w_cout1 = a · b
```

The second Half Adder adds the intermediate sum to `c_in`:

```text
sum   = w_sum1 ⊕ c_in
w_cout2 = w_sum1 · c_in
```

The two carry terms are then combined using an OR gate:

```text
c_out = w_cout1 + w_cout2
```

Therefore:

```text
sum   = a ⊕ b ⊕ c_in

c_out = ab + (a ⊕ b)c_in
```

---

## 2. Structural Modeling

The Full Adder is implemented using **module instantiation**:

```verilog
half_adder ha1(w_sum1, w_cout1, a, b);
half_adder ha2(sum, w_cout2, w_sum1, c_in);
```

This demonstrates hierarchical hardware construction, where an existing `half_adder` module is reused as a building block.

The final carry is generated using a Verilog gate primitive:

```verilog
or o1(c_out, w_cout1, w_cout2);
```

This approach reflects the concept of **hierarchical and reusable RTL design**.

---

## 3. Design Hierarchy

```text
Full Adder
    │
    ├── Half Adder 1
    │      ├── XOR → Intermediate Sum
    │      └── AND → Carry 1
    │
    ├── Half Adder 2
    │      ├── XOR → Final Sum
    │      └── AND → Carry 2
    │
    └── OR Gate
           └── Carry 1 + Carry 2 → Final Carry
```

---

## 4. Verification

The accompanying testbench instantiates the structural Full Adder and applies all **eight possible combinations** of the three input signals.

The testbench uses:

```verilog
$monitor(...)
```

to observe the inputs and outputs during simulation and:

```verilog
$fsdbDumpvars();
```

to generate waveform data for **FSDB-based waveform analysis**.

### Verification Flow

```text
Half Adder
     │
     ▼
Structural Full Adder
     │
     ▼
Testbench
     │
     ▼
Simulation
     │
     ├── Console Output
     │
     └── FSDB Waveform
```

---

## 5. Files

```text
Structural_Adders/
│
├── full_using_half.v
├── full_using_half.v
└── README.md
```

### `full_using_half.v`

Contains:

* `half_adder` module
* `full_adder` module constructed using two Half Adders

### `full_using_half_tb.v`

Contains the testbench for functional verification of the Full Adder.

The testbench includes the design using:

```verilog
`include "full_using_half.v"
```

and instantiates the `full_adder` module.

---

## 6. Concepts Covered

* Structural Verilog
* Hierarchical module design
* Module instantiation
* Hardware reuse
* Half Adder
* Full Adder
* Carry generation
* Combinational logic
* Gate primitives
* Testbench development
* Exhaustive single-bit verification
* FSDB waveform generation
* Simulation-based functional verification

---

## 7. Key Design Principle

The main objective of this implementation is to demonstrate that a complex combinational circuit can be constructed from **smaller, reusable hardware blocks**.

```text
Basic Building Block
       │
       ▼
Half Adder
       │
       ▼
Two Half Adders
       │
       ▼
Full Adder
       │
       ▼
Larger Arithmetic Circuits
```

This structural approach becomes particularly important when designing larger hierarchical systems such as **multi-bit adders, ALUs, datapaths, and processor arithmetic units**.

