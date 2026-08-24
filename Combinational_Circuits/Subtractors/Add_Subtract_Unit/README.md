# Add and Subtract Unit

This directory contains **single-bit combined Adder/Subtractor circuits implemented in Verilog HDL**.

Instead of implementing addition and subtraction as completely separate hardware blocks, these designs use a **control signal `x`** to configure the same combinational circuit for either operation.

Two implementations are included:

* **Half Adder / Half Subtractor Unit**
* **Full Adder / Full Subtractor Unit**

---

## 📂 Directory Structure

```text id="0p3psh"
Add_Subtract_Unit/
│
├── ha_and_hs.v
├── ha_and_hs_tb.v
├── fa_fs.v
├── fa_fs_tb.v
└── README.md
```

---

# 1. Operation Selection

The input `x` acts as the **mode-control signal**.

| `x` | Operation   |
| :-: | ----------- |
| `0` | Addition    |
| `1` | Subtraction |

Therefore:

```text id="6rsqfb"
x = 0  →  Adder Mode
x = 1  →  Subtractor Mode
```

The same output signals are reused depending on the selected operation:

| Output | Addition Mode | Subtraction Mode |
| ------ | ------------- | ---------------- |
| `res`  | Sum           | Difference       |
| `cout` | Carry         | Borrow           |

Conceptually:

```text id="gk7r0i"
                   x
                   │
                   ▼
            ┌──────────────┐
      a ───►│              │
      b ───►│  Add/Subtract│────► res
            │     Unit     │────► cout
            └──────────────┘

x = 0:
    res  → Sum
    cout → Carry

x = 1:
    res  → Difference
    cout → Borrow
```

---

# 2. Half Adder / Half Subtractor Unit

The `ha_and_hs` module combines the functionality of a **Half Adder and Half Subtractor** into a single circuit.

### Inputs

* `a` — First operand
* `b` — Second operand
* `x` — Operation control

### Outputs

* `res` — Sum or Difference
* `cout` — Carry or Borrow

---

## Result Generation

Both a Half Adder and a Half Subtractor have the same Sum/Difference expression:

```text id="iwvlb4"
Sum        = a ⊕ b

Difference = a ⊕ b
```

Therefore, `res` does not require the control signal.

The implementation directly uses:

```verilog id="aj0wzi"
xor x1(res, a, b);
```

Hence:

```text id="cb0y6g"
res = a ⊕ b
```

The meaning of `res` depends on the selected mode:

```text id="smnj4p"
x = 0 → res = Sum
x = 1 → res = Difference
```

---

# 3. Carry / Borrow Selection

Unlike Sum and Difference, the **Carry and Borrow equations are different**.

For a Half Adder:

```text id="3bp62x"
Carry = a · b
```

For a Half Subtractor:

```text id="13q7za"
Borrow = a' · b
```

The design combines both equations using the control signal.

The implementation first generates:

```verilog id="l1fw6e"
xor x2(w1, a, x);
```

Therefore:

```text id="ey6bz7"
w1 = a ⊕ x
```

and then:

```verilog id="0ss0hc"
and a1(cout, w1, b);
```

Therefore:

```text id="mrvyio"
cout = (a ⊕ x)b
```

---

## When `x = 0`

```text id="djmx9h"
a ⊕ 0 = a
```

Therefore:

```text id="iy1g18"
cout = ab
```

which is the **Half Adder Carry equation**.

Hence:

```text id="og7jzb"
x = 0:

res  = a ⊕ b
cout = ab

→ Half Adder
```

---

## When `x = 1`

```text id="1l73mv"
a ⊕ 1 = a'
```

Therefore:

```text id="vjlqtr"
cout = a'b
```

which is the **Half Subtractor Borrow equation**.

Hence:

```text id="q1r7bj"
x = 1:

res  = a ⊕ b
cout = a'b

→ Half Subtractor
```

This demonstrates how an XOR gate can act as a **controlled inverter**.

---

# 4. Half Add/Subtract Architecture

The complete operation can be represented as:

```text id="e56s3i"
                    ┌───────┐
        a ─────────►│       │
                    │  XOR  │────────► res
        b ─────────►│       │
                    └───────┘


        a ─────┐
               ▼
            ┌───────┐
        x ─►│  XOR  │────► w1 = a ⊕ x
            └───────┘
                         │
                         ▼
                      ┌─────┐
        b ───────────►│ AND │────► cout
                      └─────┘
```

The control signal changes only the Carry/Borrow generation logic.

---

# 5. Full Adder / Full Subtractor Unit

The `fa_and_fs` module extends the same concept to a **Full Adder / Full Subtractor**.

### Inputs

* `a`
* `b`
* `c`
* `x` — Operation control

Here, `c` represents:

```text id="z9bcma"
x = 0 → Carry-in

x = 1 → Borrow-in
```

### Outputs

* `res` — Sum / Difference
* `cout` — Carry-out / Borrow-out

---

# 6. Sum / Difference Generation

For a Full Adder:

```text id="yd8gpe"
Sum = a ⊕ b ⊕ c
```

For a Full Subtractor:

```text id="g4uqkt"
Difference = a ⊕ b ⊕ c
```

Since both equations are identical, the same XOR network can generate `res`.

The implementation uses:

```verilog id="sbt5uv"
xor x1(w1, a, b);
xor x2(res, w1, c);
```

Therefore:

```text id="1m8wr8"
w1  = a ⊕ b

res = a ⊕ b ⊕ c
```

Again:

```text id="z2f5de"
x = 0 → res represents Sum

x = 1 → res represents Difference
```

---

# 7. Carry / Borrow Generation

The control signal `x` is used to modify the internal signals responsible for Carry/Borrow generation.

The implementation contains:

```verilog id="8blv9r"
xor x3(w2, a, x);
xor x4(w4, w1, x);
```

Therefore:

```text id="9fihpf"
w2 = a  ⊕ x
w4 = w1 ⊕ x
```

The intermediate terms are:

```verilog id="ch3sjx"
and a1(w3, w2, b);
and a2(w5, w4, c);
```

giving:

```text id="bsx1bz"
w3 = (a ⊕ x)b

w5 = ((a ⊕ b) ⊕ x)c
```

Finally:

```verilog id="99o22h"
or(cout, w3, w5);
```

Therefore:

```text id="vauaqv"
cout = (a ⊕ x)b + ((a ⊕ b) ⊕ x)c
```

The control signal determines whether this expression behaves as **Carry-out or Borrow-out logic**.

---

# 8. Addition Mode — `x = 0`

When:

```text id="cm5gyj"
x = 0
```

the XOR-controlled signals remain unchanged:

```text id="4v8bpf"
a ⊕ 0       = a

(a ⊕ b) ⊕ 0 = a ⊕ b
```

Therefore:

```text id="urcj0d"
cout = ab + (a ⊕ b)c
```

which is the Full Adder carry equation.

The complete operation becomes:

```text id="wsq2ik"
res  = a ⊕ b ⊕ c

cout = ab + (a ⊕ b)c
```

Thus:

```text id="a2vyue"
x = 0
   ↓
FULL ADDER
```

where:

```text id="n4bv4m"
c    = Carry-in
res  = Sum
cout = Carry-out
```

---

# 9. Subtraction Mode — `x = 1`

When:

```text id="p2e79j"
x = 1
```

XOR with `1` complements the corresponding signals:

```text id="ezh8dh"
a ⊕ 1       = a'

(a ⊕ b) ⊕ 1 = (a ⊕ b)'
```

Therefore:

```text id="4uqw40"
cout = a'b + (a ⊕ b)'c
```

which represents the Full Subtractor borrow equation.

The complete operation becomes:

```text id="49ef9j"
res  = a ⊕ b ⊕ c

cout = a'b + (a ⊕ b)'c
```

Thus:

```text id="fqk47e"
x = 1
   ↓
FULL SUBTRACTOR
```

where:

```text id="6nnmfg"
c    = Borrow-in
res  = Difference
cout = Borrow-out
```

---

# 10. Unified Operation

The key idea behind both implementations is the use of **XOR as controlled inversion**:

```text id="kj5om7"
Signal ⊕ 0 = Signal
Signal ⊕ 1 = Signal'
```

Therefore:

```text id="58fqw1"
             x
             │
       ┌─────┴─────┐
       │           │
      x=0         x=1
       │           │
       ▼           ▼
   Addition    Subtraction
```

For the Full Adder / Full Subtractor:

```text id="ppuk2p"
                     x
                     │
              ┌──────┴──────┐
              │             │
              ▼             ▼
            x = 0         x = 1
              │             │
              ▼             ▼
        FULL ADDER    FULL SUBTRACTOR
              │             │
        ┌─────┴────┐   ┌────┴─────┐
        ▼          ▼   ▼          ▼
       Sum       Carry Diff.     Borrow
```

---

# 11. Design Progression

The implementations demonstrate the progression:

```text id="73apxi"
Half Adder                 Half Subtractor
     │                           │
     └─────────────┬─────────────┘
                   ▼
          Half Add/Sub Unit
                   │
                   ▼
          Full Add/Sub Unit
                   │
                   ▼
         N-Bit Add/Sub Unit
```

The single-bit units in this directory therefore form the building blocks for the **parameterized N-bit Add/Subtract architecture**.

---

# 12. Verification

Both designs include dedicated Verilog testbenches.

## Half Add/Sub Unit

`ha_and_hs_tb.v` applies all possible combinations of:

```text id="shx11w"
a, b, x
```

Since there are three binary inputs:

```text id="s8pph4"
2³ = 8 combinations
```

the testbench exhaustively verifies both Half Adder and Half Subtractor modes.

---

## Full Add/Sub Unit

`fa_fs_tb.v` applies representative combinations of:

```text id="90bbfh"
a, b, c, x
```

for both:

```text id="sx3ykt"
x = 0 → Full Adder

x = 1 → Full Subtractor
```

The simulation monitors:

```text id="d78r80"
a
b
c
Control
Result
Carry / Borrow
```

---

# 13. Simulation and Waveform Generation

The testbenches use:

```verilog id="pz3d81"
$fsdbDumpvars();
```

to generate **FSDB waveform data**.

The outputs are monitored using `$monitor`, allowing both console-level and waveform-level functional verification.

### Verification Flow

```text id="9gpy7f"
Add/Subtract RTL
       │
       ▼
   Testbench
       │
       ▼
   Simulation
    ┌──┴───┐
    ▼      ▼
 Console  FSDB
 Output   Waveform
```

---

# 14. Files

### `ha_and_hs.v`

Contains the combined **Half Adder / Half Subtractor** implementation controlled by `x`.

### `ha_and_hs_tb.v`

Contains the testbench for the Half Adder / Half Subtractor unit and exhaustively verifies all eight input/control combinations.

### `fa_fs.v`

Contains the combined **Full Adder / Full Subtractor** implementation controlled by `x`.

### `fa_fs_tb.v`

Contains the testbench used to verify the Full Adder / Full Subtractor operation in both modes.

---

# 15. Concepts Covered

* Half Adder
* Half Subtractor
* Full Adder
* Full Subtractor
* Combined arithmetic circuits
* Mode-controlled arithmetic
* XOR as a controlled inverter
* Sum / Difference generation
* Carry / Borrow generation
* Gate-level structural Verilog
* Hardware sharing
* Combinational logic
* Functional verification
* Testbench development
* FSDB waveform generation

---

## Key Design Principle

The central idea of this implementation is that **addition and subtraction share significant common logic**.

Instead of creating completely separate arithmetic blocks, a control signal can modify selected internal signals so that the same hardware supports both operations:

```text id="ef4e7y"
                  Arithmetic Hardware
                         │
                   Control (x)
                         │
               ┌─────────┴─────────┐
               │                   │
             x = 0               x = 1
               │                   │
               ▼                   ▼
            ADDITION           SUBTRACTION
               │                   │
          Sum + Carry       Difference + Borrow
```

This concept of **sharing arithmetic hardware through control signals** provides an important foundation for understanding the construction of **multi-function arithmetic units, ALUs, and processor datapaths**.

