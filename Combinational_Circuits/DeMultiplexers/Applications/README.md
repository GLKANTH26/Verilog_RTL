# Full Adder Using Demultiplexer

This folder contains an implementation of a **Full Adder using a Demultiplexer (DeMUX)**.

A Full Adder is a combinational circuit that performs the addition of three 1-bit inputs:

* `A`
* `B`
* `Cin` — Carry Input

It produces two outputs:

* `Sum`
* `Cout` — Carry Output

The Full Adder functionality is realized using a **1-to-8 Demultiplexer** by applying the input combinations as select lines and generating the required Boolean functions for `Sum` and `Cout`.

---

## 1. Full Adder

A Full Adder performs:

$$
A + B + C_{in}
$$

The outputs are:

$$
Sum = A \oplus B \oplus C_{in}
$$

$$
C_{out} = AB + AC_{in} + BC_{in}
$$

### Block Diagram

```text
             ┌─────────────┐
A ──────────►│             │
B ──────────►│ Full Adder  │──► Sum
Cin ────────►│             │──► Cout
             └─────────────┘
```

---

## 2. Full Adder Truth Table

|  A  |  B  | Cin | Sum | Cout |
| :-: | :-: | :-: | :-: | :--: |
|  0  |  0  |  0  |  0  |   0  |
|  0  |  0  |  1  |  1  |   0  |
|  0  |  1  |  0  |  1  |   0  |
|  0  |  1  |  1  |  0  |   1  |
|  1  |  0  |  0  |  1  |   0  |
|  1  |  0  |  1  |  0  |   1  |
|  1  |  1  |  0  |  0  |   1  |
|  1  |  1  |  1  |  1  |   1  |

---

# 3. Implementing a Full Adder Using a Demultiplexer

A 1:8 Demultiplexer has:

* 1 data input
* 3 select lines
* 8 outputs

```text
                 ┌─────────────┐
                 │             │──► Y0
                 │             │──► Y1
                 │             │──► Y2
        IN ─────►│    1 : 8    │──► Y3
                 │    DeMUX    │──► Y4
                 │             │──► Y5
                 │             │──► Y6
                 │             │──► Y7
                 └─────────────┘
                    A   B   Cin
```

The three Full Adder inputs are connected to the three select lines:

```text
S2 = A
S1 = B
S0 = Cin
```

The eight Demultiplexer outputs correspond to the eight possible combinations of `A`, `B`, and `Cin`.

---

## 4. Demultiplexer Output Mapping

With:

```text
S2 = A
S1 = B
S0 = Cin
```

the outputs represent the corresponding minterms:

|  A  |  B  | Cin | Active DeMUX Output |
| :-: | :-: | :-: | :-----------------: |
|  0  |  0  |  0  |          Y0         |
|  0  |  0  |  1  |          Y1         |
|  0  |  1  |  0  |          Y2         |
|  0  |  1  |  1  |          Y3         |
|  1  |  0  |  0  |          Y4         |
|  1  |  0  |  1  |          Y5         |
|  1  |  1  |  0  |          Y6         |
|  1  |  1  |  1  |          Y7         |

Only one Demultiplexer output is active for each input combination when the data input is asserted.

---

# 5. Generating the Sum Output

From the Full Adder truth table:

```text
Sum = 1
```

for the following input combinations:

```text
A B Cin

0 0 1  → Y1
0 1 0  → Y2
1 0 0  → Y4
1 1 1  → Y7
```

Therefore:

$$
Sum = Y_1 + Y_2 + Y_4 + Y_7
$$

So the required Demultiplexer outputs are combined using OR logic.

```text
                 Y1 ──┐
                 Y2 ──┤
                 Y4 ──┼──► OR ──► Sum
                 Y7 ──┘
```

---

# 6. Generating the Carry Output

From the Full Adder truth table:

```text
Cout = 1
```

for the following input combinations:

```text
A B Cin

0 1 1  → Y3
1 0 1  → Y5
1 1 0  → Y6
1 1 1  → Y7
```

Therefore:

$$
C_{out} = Y_3 + Y_5 + Y_6 + Y_7
$$

The required Demultiplexer outputs are combined using OR logic.

```text
                 Y3 ──┐
                 Y5 ──┤
                 Y6 ──┼──► OR ──► Cout
                 Y7 ──┘
```

---

# 7. Complete Logic

The complete implementation can be represented as:

```text
                         A
                         B
                        Cin
                         │
                         ▼
                  ┌─────────────┐
                  │    1 : 8    │
                  │    DeMUX    │
                  └──────┬──────┘
                         │
          ┌──────────────┴──────────────┐
          │                             │
       Y1,Y2,Y4,Y7                  Y3,Y5,Y6,Y7
          │                             │
          ▼                             ▼
      ┌────────┐                    ┌────────┐
      │   OR   │                    │   OR   │
      └────┬───┘                    └────┬───┘
           │                             │
           ▼                             ▼
          Sum                           Cout
```

Therefore:

$$
Sum = Y_1 + Y_2 + Y_4 + Y_7
$$

$$
C_{out} = Y_3 + Y_5 + Y_6 + Y_7
$$

---

# 8. Files in This Folder

```text
Applications/
├── fulladder.v
├── fulladder_tb.v
└── README.md
```

| File             | Description                                         |
| ---------------- | --------------------------------------------------- |
| `fulladder.v`    | Full Adder implementation using Demultiplexer logic |
| `fulladder_tb.v` | Testbench for the Full Adder                        |
| `README.md`      | Documentation for the Full Adder application        |

---

# 9. RTL Implementation

The `fulladder.v` module implements the Full Adder functionality using Demultiplexer-based logic.

The three inputs are treated as select signals:

```text
A   → Select
B   → Select
Cin → Select
```

The Demultiplexer generates the corresponding minterm outputs.

The required minterms are then combined to generate:

```text
Sum
Cout
```

This demonstrates how a standard combinational circuit can be constructed using a Demultiplexer and logic operations.

---

# 10. Verification

The `fulladder_tb.v` testbench verifies all possible combinations of the three Full Adder inputs.

There are:

$$
2^3 = 8
$$

possible input combinations.

```text
000 → Sum = 0, Cout = 0
001 → Sum = 1, Cout = 0
010 → Sum = 1, Cout = 0
011 → Sum = 0, Cout = 1
100 → Sum = 1, Cout = 0
101 → Sum = 0, Cout = 1
110 → Sum = 0, Cout = 1
111 → Sum = 1, Cout = 1
```

The testbench should verify:

* All 8 input combinations
* Correct `Sum`
* Correct `Cout`
* No incorrect output combinations

---

# 11. Full Adder Using Different Approaches

A Full Adder can be implemented using several different design approaches.

### Gate-Level Implementation

Using:

* XOR gates
* AND gates
* OR gates

### Dataflow Implementation

Using Boolean equations and continuous assignments.

### Behavioral Implementation

Using:

* `always @(*)`
* `case`
* `if-else`

### Structural Implementation

Using smaller modules such as:

```text
Half Adder
    +
Half Adder
    +
OR Gate
    ↓
Full Adder
```

### Demultiplexer-Based Implementation

Using:

```text
1:8 DeMUX
    +
OR Logic
    ↓
Full Adder
```

---

# 12. Full Adder as a Minterm Function

The Full Adder outputs can be expressed using minterms.

### Sum

$$
Sum = \Sigma m(1,2,4,7)
$$

### Carry

$$
C_{out} = \Sigma m(3,5,6,7)
$$

This makes the Full Adder a useful example for understanding how **Demultiplexers can be used to implement Boolean functions**.

---

# 13. Applications of Demultiplexer-Based Logic

Demultiplexer-based implementations are useful for understanding:

* Boolean function realization
* Minterm generation
* Combinational circuit design
* Data distribution
* Logic function implementation
* Decoder-based architectures
* Digital circuit construction
* Modular RTL design

The technique can also be extended to implement other Boolean functions by selecting the required minterms and combining them appropriately.

---

# 14. Key Concepts Practiced

This folder provides practice with:

* Full Adder design
* Demultiplexer operation
* Boolean functions
* Minterms
* Truth tables
* Sum and Carry generation
* Combinational logic
* OR-based function realization
* RTL implementation
* Testbench development
* Exhaustive verification
* Application-oriented use of Demultiplexers

---

# 15. Learning Progression

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
Boolean Function Using DeMUX
     │
     ▼
Full Adder Using DeMUX
     │
     ▼
Other Combinational Functions
     │
     ▼
Larger Digital Applications
```

---

## Summary

The `Applications` folder demonstrates an application of a Demultiplexer by implementing a **Full Adder**.

The three Full Adder inputs are used as select lines of a 1:8 Demultiplexer, and the required Demultiplexer outputs are combined to generate the `Sum` and `Cout` functions.

```text
             A
             B
            Cin
             │
             ▼
        ┌──────────┐
        │  1 : 8   │
        │  DeMUX   │
        └────┬─────┘
             │
       ┌─────┴─────┐
       │           │
    Sum Minterms  Carry Minterms
       │           │
       ▼           ▼
      OR          OR
       │           │
       ▼           ▼
      Sum         Cout
```

This application demonstrates how **Demultiplexers can be used to realize Boolean functions and construct practical combinational circuits**.

