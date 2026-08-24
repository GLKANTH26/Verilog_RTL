# CMOS Adders

This directory contains **CMOS/MOS transistor-level implementations of binary adders using Verilog MOS primitives**.

The designs demonstrate how fundamental arithmetic circuits can be constructed from **NMOS and PMOS transistor networks**, and how these transistor-level building blocks can be hierarchically composed to implement Half Adders and Full Adders.

---

## 1. CMOS Logic Building Blocks

The implementation first defines fundamental CMOS logic modules using Verilog's transistor primitives:

* `not_cmos`
* `nand_cmos`
* `nor_cmos`
* `and_cmos`
* `or_cmos`
* `xor_cmos`

These modules are then reused to construct the arithmetic circuits.

### CMOS Power Rails

The transistor-level modules use Verilog supply primitives:

```verilog
supply1 vdd;
supply0 gnd;
```

representing the CMOS:

* `VDD` — Logic HIGH supply
* `GND` — Logic LOW supply

The logic gates are implemented using combinations of:

```verilog
pmos
nmos
```

---

## 2. CMOS Logic Hierarchy

The implementation follows a hierarchical construction approach:

```text
NMOS / PMOS Transistors
          │
          ▼
   CMOS Logic Gates
          │
    ┌─────┴─────┐
    │           │
   XOR         AND
    │           │
    └─────┬─────┘
          ▼
      Half Adder
          │
          ▼
   Two Half Adders
          │
          ▼
      Full Adder
```

This provides a direct connection between **transistor-level CMOS implementation and arithmetic circuit design**.

---

## 3. CMOS Logic Gates

### NOT Gate

The CMOS inverter is implemented using one PMOS and one NMOS transistor:

```verilog
pmos p1(y, vdd, a);
nmos n1(y, gnd, a);
```

The PMOS forms the pull-up network and the NMOS forms the pull-down network.

---

### NAND Gate

The CMOS NAND gate uses:

* Parallel PMOS transistors in the pull-up network
* Series NMOS transistors in the pull-down network

```text
         VDD
        /   \
      PMOS  PMOS
        \   /
          Y
          │
        NMOS
          │
        NMOS
          │
         GND
```

---

### NOR Gate

The CMOS NOR gate uses:

* Series PMOS transistors in the pull-up network
* Parallel NMOS transistors in the pull-down network

---

### AND and OR Gates

The AND and OR gates are constructed hierarchically:

```text
AND = NAND + NOT

OR  = NOR + NOT
```

For example:

```verilog
nand_cmos n1(w1_nand, a, b);
not_cmos  i1(y, w1_nand);
```

---

### XOR Gate

The `xor_cmos` module implements XOR using CMOS transistor networks and intermediate inverter/logic stages.

The implementation explicitly constructs the required complementary signals and transistor networks using `pmos` and `nmos` primitives.

---

# 4. CMOS Half Adder

The CMOS Half Adder is constructed using the CMOS XOR and AND modules:

```verilog
xor_cmos x1(.a(a), .b(b), .y(sum));
and_cmos a1(.a(a), .b(b), .y(cout));
```

### Inputs

* `a`
* `b`

### Outputs

* `sum`
* `cout`

### Boolean Equations

```text
sum  = a ⊕ b
cout = a · b
```

### Structure

```text
             ┌────────────┐
a ──────────►│ CMOS XOR   │────► sum
             └────────────┘
                    ▲
                    │
b ──────────────────┘


             ┌────────────┐
a ──────────►│ CMOS AND   │────► cout
             └────────────┘
                    ▲
                    │
b ──────────────────┘
```

---

# 5. CMOS Full Adder

The CMOS Full Adder is constructed hierarchically using CMOS logic modules.

The implementation computes:

```text
w_sum1  = a ⊕ b
w_cout1 = a · b

sum     = w_sum1 ⊕ c_in
w_cout2 = w_sum1 · c_in

c_out   = w_cout1 + w_cout2
```

Therefore:

```text
sum   = a ⊕ b ⊕ c_in

c_out = ab + (a ⊕ b)c_in
```

### Structure

```text
                 ┌─────────────┐
        a ──────►│  CMOS XOR   │────► w_sum1
        b ──────►│             │
                 └─────────────┘
                        │
                        ▼
                 ┌─────────────┐
      c_in ─────►│  CMOS XOR   │────► sum
      w_sum1 ───►│             │
                 └─────────────┘


                 ┌─────────────┐
        a ──────►│  CMOS AND   │────► w_cout1
        b ──────►│             │
                 └─────────────┘

                 ┌─────────────┐
   w_sum1 ──────►│  CMOS AND   │────► w_cout2
      c_in ─────►│             │
                 └─────────────┘

                  w_cout1 ───┐
                             ▼
                        ┌─────────┐
                        │ CMOS OR │────► c_out
                        └─────────┘
                             ▲
                  w_cout2 ───┘
```

---

# 6. Design Hierarchy

The complete implementation can be viewed as:

```text
                     CMOS Transistors
                            │
                 ┌──────────┴──────────┐
                 ▼                     ▼
             PMOS Network          NMOS Network
                 │                     │
                 └──────────┬──────────┘
                            ▼
                       CMOS Gates
                            │
             ┌──────────────┼──────────────┐
             ▼              ▼              ▼
           XOR             AND             OR
             │              │              │
             └───────┬──────┴──────┬───────┘
                     ▼              ▼
                Half Adder
                     │
              Two Half Adders
                     │
                     ▼
                Full Adder
```

This demonstrates **hierarchical transistor-level design**, where complex functionality is built by reusing lower-level CMOS modules.

---

# 7. Verification

Dedicated testbenches are provided for the CMOS Half Adder and Full Adder.

The testbenches:

* Apply all possible input combinations
* Monitor the resulting outputs
* Generate FSDB waveform data using `$fsdbDumpvars()`
* Verify the expected arithmetic behavior

### Half Adder Verification

The Half Adder testbench verifies all four combinations:

```text
00
01
10
11
```

### Full Adder Verification

The Full Adder testbench verifies all eight combinations of:

```text
a, b, c_in
```

### Verification Flow

```text
CMOS Transistor-Level Modules
            │
            ▼
      CMOS Logic Gates
            │
            ▼
       CMOS Adder
            │
            ▼
        Testbench
            │
            ▼
        Simulation
       ┌────┴────┐
       ▼         ▼
 Console       FSDB
 Output       Waveform
```

---

# 8. Files

```text
CMOS_Adders/
│
├── using_cmos.v
├── using_cmos_tb.v
├── full_adder_cmos.v
├── full_adder_cmos_tb.v
└── README.md
```

> File names may vary depending on the organization of the RTL and testbench files in the repository.

### RTL

The RTL/design files contain:

* CMOS inverter
* CMOS NAND
* CMOS NOR
* CMOS AND
* CMOS OR
* CMOS XOR
* CMOS Half Adder
* CMOS Full Adder

### Testbenches

The testbenches instantiate the corresponding arithmetic modules and perform functional simulation.

---

# 9. Concepts Covered

* CMOS logic design
* NMOS transistor primitives
* PMOS transistor primitives
* Pull-up networks
* Pull-down networks
* CMOS inverter
* CMOS NAND
* CMOS NOR
* CMOS AND
* CMOS OR
* CMOS XOR
* Half Adder
* Full Adder
* Hierarchical hardware construction
* Transistor-level modeling
* Structural Verilog
* Combinational circuit design
* Functional verification
* FSDB waveform generation

---

# 10. Key Design Principle

The primary objective of this implementation is to demonstrate the progression from **transistor-level CMOS logic to arithmetic hardware**:

```text
PMOS + NMOS
     │
     ▼
CMOS Logic Gates
     │
     ▼
Arithmetic Building Blocks
     │
     ├── Half Adder
     │
     └── Full Adder
```

Unlike an RTL-only implementation, this design exposes the underlying **transistor-level realization of the logic functions**, making it useful for connecting digital design concepts with **CMOS VLSI circuit implementation**.

