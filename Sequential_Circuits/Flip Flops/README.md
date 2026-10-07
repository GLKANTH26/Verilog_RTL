# Flip-Flops

This folder contains RTL implementations and testbenches for the four fundamental flip-flops:

- SR Flip-Flop
- JK Flip-Flop
- D Flip-Flop
- T Flip-Flop

These designs extend the concept of **state storage introduced by the SR latch** and demonstrate **edge-triggered sequential logic**.

---

## 📁 Folder Structure

```text
Flip_Flops/
├── sr(1).v
├── sr_tb(1).v
├── jk.v
├── jk_tb.v
├── dff.v
├── dff_tb.v
├── tff.v
├── tff_tb.v
└── README.md
```

| File | Description |
|---|---|
| `sr(1).v` | SR flip-flop RTL |
| `sr_tb(1).v` | SR flip-flop testbench |
| `jk.v` | JK flip-flop RTL |
| `jk_tb.v` | JK flip-flop testbench |
| `dff.v` | D flip-flop RTL |
| `dff_tb.v` | D flip-flop testbench |
| `tff.v` | T flip-flop RTL |
| `tff_tb.v` | T flip-flop testbench |
| `README.md` | Documentation |

---

# 1. Why Move from Latches to Flip-Flops?

The previous `Latches` folder introduced **level-sensitive storage**.

A latch can respond to input changes throughout its active level:

```text
Enable = Active
     │
     ▼
Input ─────────► Latch ─────────► Q
       changes can propagate
```

This makes timing control more difficult when many storage elements are connected together.

A flip-flop instead updates its state at a specific **clock edge**:

```text
             Active Edge
                 ↓
CLK ────────────↑──────────────
                 │
                 ▼
Input ───────► Flip-Flop ─────► Q
```

### Main reason

> **Flip-flops provide edge-controlled state updates, making them the standard storage elements in synchronous digital systems.**

---

# 2. Latch vs Flip-Flop

| Feature | Latch | Flip-Flop |
|---|---|---|
| Sensitivity | Level-sensitive | Edge-sensitive |
| Control | Enable | Clock |
| State update | During active level | At clock edge |
| Transparency | Can be transparent | Not transparent between edges |
| Timing control | More complex | Easier in synchronous systems |
| Typical use | Specialized storage/timing structures | Registers, counters, FSMs, pipelines |

### Conceptual Difference

```text
Latch:

Enable ─────► [ LATCH ] ─────► Q
                 │
                 └── Level-sensitive


Flip-Flop:

Clock ──────► [ FLIP-FLOP ] ──► Q
                    ↑
               Edge-sensitive
```

---

# 3. Where Are They Used?

### Latches

Latches are used when **level-sensitive storage** is intentionally required.

Examples:

- Timing-sensitive storage structures
- Two-phase latch-based systems
- Certain low-power/area optimized designs
- Temporary data storage

### Flip-Flops

Flip-flops are commonly used in synchronous digital systems.

Examples:

- Registers
- Pipeline registers
- Counters
- Shift registers
- FSM state storage
- Control/status registers
- Synchronization circuits

A typical synchronous datapath is:

```text
        ┌──────────────────┐
        │ Combinational    │
        │ Logic            │
        └────────┬─────────┘
                 │
                 ▼
            ┌─────────┐
CLK ───────►│ Flip-   │
            │ Flops   │
            └────┬────┘
                 │
                 ▼
        ┌──────────────────┐
        │ Combinational    │
        │ Logic            │
        └────────┬─────────┘
                 │
                 ▼
            Flip-Flops
```

---

# 4. Why Different Types of Flip-Flops?

All flip-flops store **one bit**, but they provide different methods for controlling the next state.

| Flip-Flop | Main Purpose |
|---|---|
| **SR** | Set/Reset control |
| **JK** | Set/Reset + Toggle |
| **D** | Data storage |
| **T** | Toggle/Counting |

The required behavior determines which type is appropriate.

---

# 5. SR Flip-Flop

### Inputs

- `S` → Set
- `R` → Reset
- `CLK` → Clock
- `RST` → Reset
- `Q` → Output

### Truth Table

| S | R | Q(next) | Operation |
|:-:|:-:|:---:|---|
| 0 | 0 | Q | Hold |
| 0 | 1 | 0 | Reset |
| 1 | 0 | 1 | Set |
| 1 | 1 | X | Invalid |

### Key Point

```text
S = 0, R = 0 → Hold
S = 0, R = 1 → Reset
S = 1, R = 0 → Set
S = 1, R = 1 → Invalid
```

The major limitation is the **invalid `S=R=1` condition**.

---

# 6. JK Flip-Flop

The JK flip-flop removes the invalid state of the SR flip-flop.

### Truth Table

| J | K | Q(next) | Operation |
|:-:|:-:|:---:|---|
| 0 | 0 | Q | Hold |
| 0 | 1 | 0 | Reset |
| 1 | 0 | 1 | Set |
| 1 | 1 | Q̅ | Toggle |

### Key Point

```text
J = K = 1 → Toggle
```

Characteristic equation:

\[
Q_{next}=J\overline{Q}+\overline{K}Q
\]

### Typical Applications

- Counters
- Toggle-based circuits
- General sequential logic
- Construction of other flip-flops

---

# 7. D Flip-Flop

The D flip-flop is primarily used for **data storage**.

### Truth Table

| D | Q(next) |
|:-:|:---:|
| 0 | 0 |
| 1 | 1 |

Therefore:

\[
Q_{next}=D
\]

### Operation

```text
At the active clock edge:

D = 0 → Q becomes 0
D = 1 → Q becomes 1
```

### Typical Applications

- Registers
- Pipeline registers
- FSM state registers
- Data storage
- Synchronizers

### Implementation in This Folder

The D flip-flop is constructed using the JK flip-flop:

```text
J = D
K = D̅
```

Therefore:

```text
D = 0 → J=0, K=1 → Reset
D = 1 → J=1, K=0 → Set
```

Hence:

\[
Q_{next}=D
\]

This demonstrates **hierarchical RTL design and module reuse**.

---

# 8. T Flip-Flop

The T flip-flop is designed for **toggle operation**.

### Truth Table

| T | Q(next) | Operation |
|:-:|:---:|---|
| 0 | Q | Hold |
| 1 | Q̅ | Toggle |

Characteristic equation:

\[
Q_{next}=T\oplus Q
\]

### Operation

```text
T = 0 → Hold
T = 1 → Toggle
```

### Typical Applications

- Counters
- Frequency division
- Toggle control

### Implementation in This Folder

The T flip-flop is constructed using the JK flip-flop:

```text
J = T
K = T
```

Therefore:

```text
T = 0 → J=0, K=0 → Hold
T = 1 → J=1, K=1 → Toggle
```

---

# 9. Flip-Flop Comparison

| Feature | SR | JK | D | T |
|---|---|---|---|---|
| Hold | S=R=0 | J=K=0 | D retains sampled state | T=0 |
| Set | S=1,R=0 | J=1,K=0 | D=1 | — |
| Reset | S=0,R=1 | J=0,K=1 | D=0 | — |
| Toggle | Invalid | J=K=1 | — | T=1 |
| Main use | Set/Reset | General sequential control | Data storage | Counting/toggling |
| Main limitation | Invalid state | More inputs | No direct toggle input | Limited direct control |

---

# 10. Why D Flip-Flops Are Commonly Used in RTL

In practical synchronous RTL, the required next state is often already available as a data value:

```text
                Next-State Logic
                       │
                       ▼
                     D
                     │
CLK ───────────────► D FF
                     │
                     ▼
                     Q
```

Therefore, a D flip-flop provides a direct way to store the result of combinational logic.

This makes D flip-flops particularly suitable for:

- Registers
- Pipeline stages
- FSM state registers
- Datapaths

---

# 11. Clocking

The flip-flops in this folder are **positive-edge triggered**.

The sequential blocks use the form:

```verilog
always @(posedge clk or negedge rst)
```

Therefore:

```text
posedge clk → Normal state update
negedge rst → Immediate reset
```

Between clock edges, the stored output remains unchanged unless the asynchronous reset is activated.

---

# 12. Reset

The designs use an **asynchronous active-low reset**.

```verilog
negedge rst
```

When:

```text
RST = 0
```

the output is forced to:

```text
Q = 0
```

without waiting for a clock edge.

When:

```text
RST = 1
```

normal clocked operation resumes.

### Reset behavior

```text
             RST = 0
                 │
                 ▼
              Q = 0
                 │
                 │ RST = 1
                 ▼
          Normal operation
          on posedge CLK
```

---

# 13. Hierarchical Construction

This folder also demonstrates how one flip-flop can be used to construct another.

```text
                 JK Flip-Flop
                 /          \
                /            \
               ▼              ▼
        D Flip-Flop       T Flip-Flop

        J = D             J = T
        K = D̅            K = T
```

### D Flip-Flop

\[
J=D,\qquad K=\overline{D}
\]

### T Flip-Flop

\[
J=T,\qquad K=T
\]

This demonstrates **RTL module reuse and hierarchical design**.

---

# 14. Verification

Each flip-flop has a dedicated testbench:

```text
sr(1).v  ─────────► sr_tb(1).v
jk.v     ─────────► jk_tb.v
dff.v    ─────────► dff_tb.v
tff.v    ─────────► tff_tb.v
```

The testbenches verify:

- Reset operation
- Hold condition
- Set operation
- Reset operation
- Toggle operation
- Clock-edge behavior
- SR invalid condition
- Hierarchical D flip-flop operation
- Hierarchical T flip-flop operation

Waveforms are dumped using:

```verilog
$fsdbDumpvars();
```

and can be inspected using a waveform viewer.

---

# 15. From Flip-Flops to Larger Sequential Circuits

A single flip-flop stores **one bit**.

Multiple flip-flops can therefore be combined to create larger sequential structures.

```text
Flip-Flop
    │
    ▼
Register
    │
    ├──► Shift Register
    │
    ├──► Counter
    │
    ├──► FSM State Register
    │
    └──► Pipeline Register
```

For example:

```text
1 D FF       → 1-bit storage

8 D FFs      → 8-bit register

32 D FFs     → 32-bit register
```

---

# 16. Sequential Design Progression

The sequential section progresses from basic storage to larger systems:

```text
SR Latch
   │
   │ Level-sensitive
   ▼
Flip-Flops
   │
   │ Edge-triggered
   ▼
Registers
   │
   ├──► Shift Registers
   │
   ├──► Counters
   │
   └──► FSMs
```

The fundamental transition is:

```text
Latch
  ↓
Level-sensitive storage

Flip-Flop
  ↓
Edge-sensitive storage

Register
  ↓
Multiple flip-flops

Sequential System
  ↓
Combinational Logic + Storage + Clock
```

---

# 17. Key Takeaways

- A **latch** is level-sensitive.
- A **flip-flop** is edge-sensitive.
- Flip-flops provide controlled state updates for synchronous systems.
- **SR** provides direct Set/Reset but has an invalid state.
- **JK** removes the SR invalid state and provides Toggle.
- **D** is primarily used for data storage.
- **T** is primarily used for toggling and counting.
- D and T flip-flops can be constructed from a JK flip-flop.
- The designs in this folder use **positive-edge triggering**.
- The designs use an **asynchronous active-low reset**.
- Multiple flip-flops form registers, counters, shift registers, and FSM state storage.
