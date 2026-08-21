# Basic Adders

This directory contains **fundamental binary addition circuits implemented in Verilog HDL**:

* **Half Adder**
* **Full Adder**

These circuits form the basic building blocks for larger arithmetic units such as multi-bit adders, ALUs, and arithmetic datapaths.

---

## 1. Half Adder

A Half Adder performs the addition of two single-bit binary inputs.

### Inputs

* `a` — First operand
* `b` — Second operand

### Outputs

* `s` — Sum
* `cout` — Carry-out

### Boolean Equations

```text
s    = a ⊕ b
cout = a · b
```

### Implementation

The Half Adder is implemented using an `always @(*)` combinational block:

```verilog
always @(*) begin
    s    = a ^ b;
    cout = a & b;
end
```

An equivalent compact implementation is:

```verilog
{cout, s} = a + b;
```

This works because the 2-bit result of the addition is mapped directly to `{cout, s}`.

### Truth Table

|  a  |  b  |  s  | cout |
| :-: | :-: | :-: | :--: |
|  0  |  0  |  0  |   0  |
|  0  |  1  |  1  |   0  |
|  1  |  0  |  1  |   0  |
|  1  |  1  |  0  |   1  |

---

## 2. Full Adder

A Full Adder performs the addition of **three single-bit inputs**:

* `a`
* `b`
* `c_in`

and generates:

* `sum`
* `c_out`

### Boolean Equations

```text
sum   = a ⊕ b ⊕ c_in

c_out = ab + c_in(a ⊕ b)
```

### Implementation

The Full Adder is implemented using **gate-level structural modeling**.

The design first computes the Half Adder operation for `a` and `b`, then adds `c_in` to the intermediate sum.

```text
          a ─────┐
                 │
                 ▼
             ┌────────┐
          b ─►│  HA₁   │─── w_sum_ha1
             └────────┘
                  │
                  │
             c_in ▼
             ┌────────┐
             │  HA₂   │──── sum
             └────────┘
                  │
                  │
        w_cout_ha1│ w_cout_ha2
              └────┬────┘
                   ▼
                  OR
                   │
                   ▼
                 c_out
```

The implementation uses:

* `XOR` gates for sum generation
* `AND` gates for carry generation
* `OR` gate for final carry generation

---

## 3. Full Adder Logic

The Full Adder can be understood as two Half Adder operations followed by an OR operation for the carry.

```text
HA₁:
    a + b
       │
       ├──► w_sum_ha1
       └──► w_cout_ha1

HA₂:
    w_sum_ha1 + c_in
       │
       ├──► sum
       └──► w_cout_ha2

Final Carry:

    c_out = w_cout_ha1 | w_cout_ha2
```

Therefore:

```text
c_out = ab + (a ⊕ b)c_in
```

---

## 4. Files

```text
Basic_Adders/
│
├── half_adder.v
├── half_adder_tb.v
├── full_adder.v
├── full_adder_tb.v
└── README.md
```

The corresponding testbenches are used to verify the functionality of each design through simulation.

---

## 5. Concepts Covered

* Binary addition
* Half Adder
* Full Adder
* Sum generation
* Carry generation
* Boolean equations
* Combinational logic
* Gate-level structural modeling
* Verilog `always @(*)`
* Verilog bitwise operators
* Module-level arithmetic design
* Functional verification

---

## 6. Verification

The testbenches apply all possible combinations of the input signals and verify the resulting `sum` and `carry` outputs against the expected truth-table behavior.

```text
RTL Design
     │
     ▼
Testbench
     │
     ▼
Simulation
     │
     ▼
Output Verification
```

---

## 7. Implementation Note

The Half Adder demonstrates two equivalent ways of describing the same combinational function:

**Explicit Boolean implementation:**

```verilog
s    = a ^ b;
cout = a & b;
```

**Arithmetic representation:**

```verilog
{cout, s} = a + b;
```

The explicit implementation makes the underlying Boolean logic clear, while the arithmetic form provides a compact representation of the same functionality.

