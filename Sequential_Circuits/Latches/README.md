# Latches

This folder contains the **SR (Set-Reset) Latch** implemented using Verilog RTL along with its testbench.

The SR latch is one of the fundamental sequential building blocks because it demonstrates the basic concept of **state storage and feedback**.

## 📁 Files in This Folder

```text
Latches/
├── sr.v
├── sr_tb.v
└── README.md
```

| File | Description |
|---|---|
| `sr.v` | Verilog RTL implementation of the SR latch |
| `sr_tb.v` | Testbench for functional verification |
| `README.md` | Documentation for the SR latch |

---

## 1. SR Latch

An **SR (Set-Reset) latch** is a basic sequential circuit capable of storing **one bit of information**.

It has:

- **S** → Set input
- **R** → Reset input
- **Q** → Stored output

Unlike a flip-flop, an SR latch does **not require a clock**. Its output responds directly to changes in the control inputs.

### Basic Operation

```text
             ┌─────────────┐
       S ───►│             │───► Q
       R ───►│  SR Latch   │
             │             │───► Q̅
             └─────────────┘
```

The latch maintains its previous state when neither Set nor Reset is asserted.

---

## 2. Truth Table

For the active-high SR latch used here:

| S | R | Q(next) | Operation |
|:-:|:-:|:-------:|---|
| 0 | 0 | Q | Hold / Memory |
| 0 | 1 | 0 | Reset |
| 1 | 0 | 1 | Set |
| 1 | 1 | X | Invalid / Forbidden |

### Hold Condition

When:

```text
S = 0
R = 0
```

the latch retains its previous value:

```text
Q(next) = Q
```

This is the fundamental **memory behavior** of the latch.

### Set Condition

When:

```text
S = 1
R = 0
```

the output becomes:

```text
Q = 1
```

### Reset Condition

When:

```text
S = 0
R = 1
```

the output becomes:

```text
Q = 0
```

### Invalid Condition

When:

```text
S = 1
R = 1
```

both Set and Reset are asserted simultaneously.

This is treated as an **invalid/forbidden state** in the implementation.

---

## 3. RTL Implementation

The SR latch is implemented behaviorally.

The sensitivity list responds to changes in the inputs:

```verilog
always @(s or r)
```

Since there is **no clock signal**, this describes level-sensitive storage rather than edge-triggered storage.

The hold condition is represented by retaining the previous value of `q`:

```verilog
2'b00: q <= q;
```

The basic behavior can be summarized as:

```text
S R
│ │
│ └── Reset
└──── Set

00 → Hold
01 → Reset
10 → Set
11 → Invalid
```

---

## 4. Why It Is a Sequential Circuit

The important distinction between combinational and sequential logic is **memory**.

For a combinational circuit:

```text
Output = f(Current Inputs)
```

For a sequential circuit:

```text
Output = f(Current Inputs, Previous State)
```

For the SR latch:

```text
Q(next) = f(S, R, Q)
```

When `S = 0` and `R = 0`, the output depends on its **previous value**, which gives the circuit its memory.

---

## 5. Testbench

`sr_tb.v` is used to verify the different operating conditions of the latch.

The testbench should exercise:

1. Hold condition
2. Set condition
3. Reset condition
4. Invalid condition
5. Transitions between these states

A representative verification sequence is:

```text
S R
0 0 → Hold
1 0 → Set
0 0 → Hold
0 1 → Reset
0 0 → Hold
1 1 → Invalid
```

The waveform can then be inspected to verify that `Q` responds correctly to the applied inputs.

---

## 6. Latch vs Flip-Flop

| Feature | Latch | Flip-Flop |
|---|---|---|
| Control | Level-sensitive | Edge-sensitive |
| Clock required | Not necessarily | Yes |
| Output changes | During active level | At clock edge |
| Storage | 1 bit | 1 bit |
| Example | SR latch | D flip-flop |

The SR latch in this folder is therefore a starting point for understanding more advanced sequential elements.

---

## 7. Key Concepts Demonstrated

This implementation introduces several important sequential-logic concepts:

- **State storage**
- **Feedback**
- **Hold condition**
- **Set and Reset operations**
- **Level-sensitive behavior**
- **Invalid state**
- **Previous-state dependence**
- **Behavioral RTL modeling**
- **Testbench-based verification**

---

## 8. Possible Extensions

Further sequential designs can build directly on this SR latch:

```text
SR Latch
   │
   └──► D Latch
           │
           └──► D Flip-Flop
                    │
                    ├──► Registers
                    │
                    ├──► Shift Registers
                    │
                    └──► Counters
```

Other useful exercises include:

- SR latch using NAND gates
- SR latch using NOR gates
- Gated SR latch
- D latch
- Master-slave flip-flop
- Edge-triggered flip-flops

---

## Summary

The `Latches` folder currently contains an **SR latch and its testbench**, providing the first sequential RTL design in this repository.

The main behavior is:

```text
S R = 00 → Hold
S R = 01 → Reset
S R = 10 → Set
S R = 11 → Invalid
```

This establishes the fundamental concept of **state and memory in digital RTL design** and forms the foundation for the subsequent **D latch and flip-flop** designs.
