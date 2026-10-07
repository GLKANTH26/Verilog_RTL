# Counters

Counters are sequential digital circuits used to generate a predefined sequence of states in response to clock pulses. They are built using flip-flops and are widely used for **counting events, frequency division, timing generation, sequence generation, control logic, and digital system synchronization**.

This folder contains both **Asynchronous (Ripple) Counters** and **Synchronous Counters**.

---

## Folder Structure

```text
Sequential_Circuits/
└── Counters/
    ├── Asynchronous/
    │   ├── rc_2.v
    │   ├── rc_3.v
    │   ├── rc_4.v
    │   ├── ripple_counter.v
    │   ├── truncate.v
    │   └── README.md
    │
    ├── Synchronous/
    │   ├── ring.v
    │   ├── ring_tb.v
    │   ├── twisted.v
    │   ├── twisted_tb.v
    │   └── README.md
    │
    └── README.md
```

---

## What Is a Counter?

A counter is a sequential circuit that moves through a predefined sequence of states whenever a clock event occurs.

For an N-bit binary counter, the states are:

```text
0000
0001
0010
0011
0100
...
1111
0000
```

The number of available binary states is:

```text
Number of states = 2^N
```

Therefore:

```text
N = 2  → 4 states
N = 3  → 8 states
N = 4  → 16 states
N = 8  → 256 states
```

---

## Why Counters Are Built Using Flip-Flops

A flip-flop stores one bit of information.

Therefore:

```text
1 Flip-Flop  → 1 bit
2 Flip-Flops → 2 bits
4 Flip-Flops → 4 bits
N Flip-Flops → N bits
```

The flip-flops are connected with appropriate feedback or combinational logic to produce the required counting sequence.

---

# Types of Counters

The counters in this repository are divided into two major categories:

```text
                    Counters
                       │
             ┌─────────┴─────────┐
             │                   │
       Asynchronous          Synchronous
        Counters              Counters
             │                   │
       Ripple Counters      Ring Counter
                            Johnson Counter
```

---

# Asynchronous Counters

Asynchronous counters are also called **ripple counters**.

Only the first flip-flop receives the external clock. The output of one flip-flop is used as the clock input of the next flip-flop.

```text
CLK
 │
 ▼
FF0 ──► FF1 ──► FF2 ──► FF3
 │       │       │       │
 Q0      Q1      Q2      Q3
```

The state transition therefore propagates from one stage to the next.

---

## Asynchronous Counter Characteristics

```text
External CLK → FF0 → FF1 → FF2 → FF3
```

Important characteristics:

- Ripple clocking
- Stage-by-stage state transition
- Accumulated propagation delay
- Simple hardware
- Natural binary counting
- Useful for frequency division

For an N-bit binary ripple counter:

```text
MOD = 2^N
```

---

## Asynchronous Counter Frequency Division

Each flip-flop operates as a divide-by-2 stage.

```text
Q0 = f_CLK / 2

Q1 = f_CLK / 4

Q2 = f_CLK / 8

Q3 = f_CLK / 16
```

In general:

```text
Qn = f_CLK / 2^(n+1)
```

This makes ripple counters useful as simple frequency dividers.

---

# Synchronous Counters

In synchronous counters, all flip-flops receive the same clock signal.

```text
                 ┌──► FF0
                 │
CLK ─────────────┼──► FF1
                 │
                 ├──► FF2
                 │
                 └──► FF3
```

All state bits therefore update on the same active clock edge.

The feedback signals are used as data rather than clocks.

---

## Synchronous Counter Characteristics

Important characteristics:

- Common clock for all flip-flops
- Simultaneous state updates
- Lower accumulated clock-to-clock delay
- Better suited for high-speed designs
- Easier timing analysis
- More combinational logic may be required

The synchronous counter implementations in this repository are **Ring Counter** and **Johnson Counter**.

---

# Ring Counter

A ring counter is a shift-register-based counter in which the output of the final stage is fed back to the first stage.

A single `1` circulates through the register.

For a 4-bit ring counter:

```text
0001
0010
0100
1000
0001
```

For an N-bit ring counter:

```text
MOD = N
```

The sequence frequency is:

```text
f_state = f_CLK / N
```

---

# Johnson Counter

A Johnson counter is also known as a **Twisted Ring Counter**.

Instead of feeding the final bit directly back into the first stage, its complement is fed back.

```text
q <= {q[N-2:0],~q[N-1]}
```

For a 4-bit Johnson counter:

```text
0000
0001
0011
0111
1111
1110
1100
1000
0000
```

Therefore:

```text
MOD = 2N
```

and:

```text
f_state = f_CLK / 2N
```

---

# Asynchronous vs Synchronous Counters

| Feature | Asynchronous | Synchronous |
|---|---|---|
| Clock | Rippled | Common |
| State update | Stage-by-stage | Same clock edge |
| Propagation delay | Accumulates | Lower |
| Maximum speed | Lower | Higher |
| Timing analysis | More difficult | Easier |
| Hardware | Simple | More combinational logic |
| Main structure | Cascaded FFs | Common-clock FFs |
| Typical use | Frequency division | High-speed control/counting |

---

# Binary vs Ring vs Johnson Counters

| Counter | N Flip-Flops | Number of States | Typical Sequence |
|---|---:|---:|---|
| Binary | N | 2^N | Binary |
| Ring | N | N | One-hot rotation |
| Johnson | N | 2N | Twisted/shift sequence |

For N = 4:

```text
Binary  → 16 states
Ring    → 4 states
Johnson → 8 states
```

---

# Modulus

The modulus of a counter represents the number of states in its repeating sequence.

### Binary Counter

```text
MOD = 2^N
```

### Ring Counter

```text
MOD = N
```

### Johnson Counter

```text
MOD = 2N
```

### Truncated Counter

```text
MOD < 2^N
```

A truncated counter intentionally resets or changes its sequence before reaching all possible binary states.

---

# Propagation Delay

Propagation delay is one of the major differences between asynchronous and synchronous counters.

In an asynchronous counter:

```text
CLK → FF0 → FF1 → FF2 → FF3
```

The delay accumulates from stage to stage.

Conceptually:

```text
t_total ≈ N × t_PD
```

where:

```text
t_total = Total ripple propagation delay

N = Number of flip-flop stages

t_PD = Propagation delay of one stage
```

This limits the maximum operating frequency.

---

# Counter Timing

For an asynchronous counter, the clock period must be large enough for the ripple transitions to settle.

Conceptually:

```text
T_CLK > N × t_PD + timing_margin
```

For synchronous counters, the timing path is analyzed between flip-flops:

```text
T_CLK ≥ t_CLK→Q + t_COMB + t_SETUP
```

where:

```text
t_CLK→Q = Clock-to-Q delay

t_COMB = Combinational logic delay

t_SETUP = Setup time
```

In practical ASIC designs, clock skew, uncertainty, PVT variation, and other timing margins must also be considered.

---

# Reset in Counters

Reset initializes the counter into a known state.

Depending on the implementation, reset may be:

```text
Active-low:
rst = 0 → Reset
rst = 1 → Normal operation
```

or:

```text
Active-high:
rst = 1 → Reset
rst = 0 → Normal operation
```

The reset may also be synchronous or asynchronous depending on the RTL implementation.

In the current synchronous counter implementations:

```text
always @(posedge clk or negedge rst)
```

is used, giving an **asynchronous active-low reset**.

---

# Enable Control

The synchronous counter implementations use an enable signal:

```text
en
```

The basic behavior is:

```text
en = 0 → Hold current state

en = 1 → Advance counter
```

This allows the counter to pause without resetting its current state.

---

# Non-Blocking Assignment

Sequential counter logic uses non-blocking assignment:

```verilog
q <= next_state;
```

The `<=` operator is important for modeling flip-flop behavior.

The right-hand side is evaluated using the current state, and the state update occurs after the current simulation event.

This prevents unintended simulation ordering effects in sequential logic.

---

# Counter State Transitions

A counter can be represented as a state machine.

```text
Current State
      │
      ▼
Next-State Logic
      │
      ▼
Next State
      │
      ▼
Flip-Flops
      │
      └──────► Current State
```

For synchronous counters, the state transition occurs at the active clock edge.

For asynchronous counters, the transition propagates through the individual flip-flop stages.

---

# Applications

Counters are used extensively in digital systems.

Common applications include:

- Event counting
- Frequency division
- Clock division
- Digital clocks
- Timers
- Frequency counters
- Sequence generation
- Control sequencing
- Memory control
- FSM implementation
- Address generation
- Communication timing
- Prescalers
- Digital measurement systems

---

# Repository Implementations

### Asynchronous

The `Asynchronous` folder currently contains:

```text
rc_2.v
```

2-bit ripple counter.

```text
rc_3.v
```

3-bit ripple counter.

```text
rc_4.v
```

4-bit ripple counter.

```text
ripple_counter.v
```

4-bit ripple counter using JK flip-flops.

```text
truncate.v
```

Truncated ripple counter.

---

### Synchronous

The `Synchronous` folder currently contains:

```text
ring.v
```

Parameterized N-bit ring counter.

```text
ring_tb.v
```

Ring counter testbench.

```text
twisted.v
```

Parameterized Johnson/Twisted Ring Counter.

```text
twisted_tb.v
```

Johnson counter testbench.

---

# Verification

Counter designs should be verified for:

- Reset behavior
- Enable behavior
- Correct state sequence
- Correct modulus
- Counter rollover
- Frequency division
- Invalid-state behavior
- State holding
- Feedback operation
- Parameterized widths
- Timing behavior

Waveform analysis is particularly important for asynchronous counters because it allows the ripple propagation between stages to be observed.

---

# Learning Progression

The counter implementations in this folder follow a useful progression:

```text
Flip-Flops
    │
    ▼
Asynchronous Counters
    │
    ├── 2-bit
    ├── 3-bit
    ├── 4-bit
    ├── JK-based Ripple Counter
    └── Truncated Counter
    │
    ▼
Synchronous Counters
    │
    ├── Ring Counter
    └── Johnson Counter
    │
    ▼
Future Counter Designs
    │
    ├── Binary Up/Down Counter
    ├── Mod-N Counter
    ├── Programmable Counter
    └── Gray-Code Counter
```

---

# Future Implementations

The Counters folder can be extended with:

- Binary Up Counter
- Binary Down Counter
- Up/Down Counter
- Mod-N Counter
- Decade Counter
- Programmable Counter
- Gray-Code Counter
- Saturating Counter
- Prescaler
- Frequency Divider
- Counter with Terminal Count
- Counter with Overflow/Underflow Detection
- Programmable Modulus Counter
- Clock-Enable Based Counter
- Synchronous Truncated Counter
- Parameterized Counter Framework

---

# Key Takeaways

- A counter is a sequential circuit that progresses through a predefined sequence of states.
- Flip-flops provide the storage elements required for counters.
- Asynchronous counters use **rippled clocking**.
- Synchronous counters use a **common clock**.
- An N-bit binary counter has:

```text
MOD = 2^N
```

- An N-bit ring counter has:

```text
MOD = N
```

- An N-bit Johnson counter has:

```text
MOD = 2N
```

- Ripple counters are simple but suffer from accumulated propagation delay.
- Synchronous counters provide better timing characteristics for high-speed designs.
- Ring counters provide simple one-hot sequencing.
- Johnson counters provide twice as many states as a ring counter with the same number of flip-flops.
- Counters are fundamental building blocks for **timers, frequency dividers, sequence generators, control logic, address generation, and digital systems**.
