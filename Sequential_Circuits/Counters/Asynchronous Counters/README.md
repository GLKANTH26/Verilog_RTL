# Asynchronous Counters

Asynchronous counters are sequential circuits in which the clock signal is applied to the first flip-flop, while the outputs of preceding flip-flops are used to trigger subsequent flip-flops.

They are also called **ripple counters** because the state transition propagates from one flip-flop to the next.

This folder contains implementations of:

- 2-bit Ripple Counter
- 3-bit Ripple Counter
- 4-bit Ripple Counter
- 4-bit Ripple Counter using JK Flip-Flops
- Truncated Ripple Counter

---

## Folder Structure

```text
Counters/
├── Asynchronous/
│   ├── rc_2.v
│   ├── rc_3.v
│   ├── rc_4.v
│   ├── ripple_counter.v
│   ├── truncate.v
│   └── ...
│
└── Synchronous/
    └── ...
```

| File | Description |
|---|---|
| `rc_2.v` | 2-bit Ripple Counter |
| `rc_3.v` | 3-bit Ripple Counter |
| `rc_4.v` | 4-bit Ripple Counter |
| `ripple_counter.v` | 4-bit Ripple Counter using JK Flip-Flops |
| `truncate.v` | Truncated Ripple Counter |

---

## What Is an Asynchronous Counter?

An asynchronous counter is a counter in which **all flip-flops do not receive the same clock signal**.

Only the first flip-flop receives the external clock.

The output of one flip-flop becomes the clock input of the next flip-flop.

```text
CLK
 │
 ▼
┌─────┐      ┌─────┐      ┌─────┐      ┌─────┐
│ FF0 │─Q0──►│ FF1 │─Q1──►│ FF2 │─Q2──►│ FF3 │
└─────┘      └─────┘      └─────┘      └─────┘
   │            │            │            │
   Q0           Q1           Q2           Q3
```

The state change therefore **ripples** through the flip-flops.

---

## Why Is It Called a Ripple Counter?

When the external clock changes, the first flip-flop changes first.

Its output then triggers the next flip-flop.

The next flip-flop changes after that.

This continues through the counter.

```text
CLK → FF0 → FF1 → FF2 → FF3
       ↓     ↓     ↓     ↓
      Q0    Q1    Q2    Q3
```

The state transition therefore propagates like a ripple.

---

## Asynchronous vs Synchronous Counters

| Feature | Asynchronous Counter | Synchronous Counter |
|---|---|---|
| Clock | Rippled between flip-flops | Common clock |
| State transition | Stage-by-stage | Same clock edge |
| Propagation delay | Accumulates | Lower |
| Maximum speed | Lower | Higher |
| Hardware | Simple | More logic may be required |
| Timing | More difficult | Easier |
| Main characteristic | Ripple propagation | Simultaneous update |

---

# Ripple Counter Principle

A ripple counter can be constructed using flip-flops configured to toggle.

For a JK flip-flop:

```text
J = 1
K = 1
```

causes the flip-flop to toggle whenever its active clock edge occurs.

```text
      J = 1
      K = 1
        │
        ▼
     ┌──────┐
CLK ─►│ JK FF│──► Q
     └──────┘
```

The output `Q` of one stage is then used as the clock for the next stage.

---

# 2-Bit Ripple Counter

The 2-bit implementation is provided in:

```text
rc_2.v
```

A 2-bit ripple counter contains two flip-flops.

```text
CLK ──► FF0 ──► FF1
         │       │
         Q0      Q1
```

The counter produces:

```text
00
01
10
11
00
...
```

Therefore:

```text
MOD = 4
```

In general, an N-bit binary ripple counter has:

```text
MOD = 2^N
```

valid states.

---

## 2-Bit Counter State Sequence

```text
Clock    Q1 Q0
Reset    0  0
1        0  1
2        1  0
3        1  1
4        0  0
```

The LSB changes on every input clock transition, while the next stage changes at a lower frequency.

---

# 3-Bit Ripple Counter

The 3-bit implementation is provided in:

```text
rc_3.v
```

Architecture:

```text
CLK ──► FF0 ──► FF1 ──► FF2
         │       │       │
         Q0      Q1      Q2
```

The counter produces:

```text
000
001
010
011
100
101
110
111
000
...
```

Therefore:

```text
MOD = 2^3
    = 8
```

---

## 3-Bit Counter State Sequence

```text
Clock    Q2 Q1 Q0
Reset    0  0  0
1        0  0  1
2        0  1  0
3        0  1  1
4        1  0  0
5        1  0  1
6        1  1  0
7        1  1  1
8        0  0  0
```

---

# 4-Bit Ripple Counter

The 4-bit implementation is provided in:

```text
rc_4.v
```

The architecture is:

```text
CLK ──► FF0 ──► FF1 ──► FF2 ──► FF3
         │       │       │       │
         Q0      Q1      Q2      Q3
```

The counter produces:

```text
0000
0001
0010
0011
0100
0101
0110
0111
1000
...
1111
0000
```

Therefore:

```text
MOD = 2^4
    = 16
```

---

# Ripple Counter Using JK Flip-Flops

The file:

```text
ripple_counter.v
```

implements a 4-bit ripple counter using JK flip-flops.

The basic structure is:

```text
              ┌─────────┐
CLK ─────────►│ JK FF0  │
              │ J=1 K=1 │
              └────┬────┘
                   Q0
                    │
                    ▼
              ┌─────────┐
              │ JK FF1  │
              │ J=1 K=1 │
              └────┬────┘
                   Q1
                    │
                    ▼
              ┌─────────┐
              │ JK FF2  │
              │ J=1 K=1 │
              └────┬────┘
                   Q2
                    │
                    ▼
              ┌─────────┐
              │ JK FF3  │
              │ J=1 K=1 │
              └─────────┘
                   Q3
```

Each JK flip-flop operates in toggle mode because:

```text
J = 1
K = 1
```

---

## JK Flip-Flop Toggle Operation

For a JK flip-flop:

| J | K | Operation |
|---|---|---|
| 0 | 0 | Hold |
| 0 | 1 | Reset |
| 1 | 0 | Set |
| 1 | 1 | Toggle |

Therefore, when:

```text
J = 1
K = 1
```

the output changes state at every active clock edge.

This makes the JK flip-flop suitable for constructing ripple counters.

---

# Frequency Division

Each flip-flop in a binary ripple counter divides the frequency by 2.

For the first stage:

```text
f_Q0 = f_CLK / 2
```

For the second stage:

```text
f_Q1 = f_CLK / 4
```

For the third stage:

```text
f_Q2 = f_CLK / 8
```

For the fourth stage:

```text
f_Q3 = f_CLK / 16
```

In general:

```text
f_Qn = f_CLK / 2^(n+1)
```

where `n = 0` represents the first flip-flop.

---

## Example

If:

```text
f_CLK = 100 MHz
```

then:

```text
Q0 = 100 MHz / 2
   = 50 MHz

Q1 = 100 MHz / 4
   = 25 MHz

Q2 = 100 MHz / 8
   = 12.5 MHz

Q3 = 100 MHz / 16
   = 6.25 MHz
```

The MSB of a 4-bit ripple counter therefore has a frequency of:

```text
f_Q3 = f_CLK / 16
```

---

# Why Frequency Division Occurs

A toggle flip-flop changes its output once for every active clock edge.

Therefore, one complete output cycle requires two clock transitions.

Hence:

```text
f_OUT = f_CLK / 2
```

When multiple toggle flip-flops are cascaded:

```text
CLK → /2 → /2 → /2 → /2
```

the total division becomes:

```text
2 × 2 × 2 × 2 = 16
```

Therefore:

```text
f_OUT = f_CLK / 16
```

for a 4-bit counter's MSB.

---

# Asynchronous Propagation Delay

The major limitation of a ripple counter is **cumulative propagation delay**.

The clock first reaches FF0.

After FF0 changes, its output reaches FF1.

After FF1 changes, its output reaches FF2.

This continues through the counter.

```text
CLK
 │
 ▼
FF0 ──delay──► FF1 ──delay──► FF2 ──delay──► FF3
```

Therefore, the total settling time increases with the number of flip-flops.

---

## Propagation Delay

If the propagation delay of each flip-flop is approximately:

```text
t_PD
```

then for an N-bit ripple counter, the worst-case accumulated delay is approximately:

```text
t_total ≈ N × t_PD
```

This is an approximate conceptual relationship. Actual timing depends on the flip-flop implementation, clock polarity, loading, PVT conditions, and library characteristics.

---

# Ripple Counter Timing

The first flip-flop responds directly to the external clock.

The second flip-flop responds to the first flip-flop.

The third responds to the second.

Therefore, during a state transition, intermediate states may briefly appear.

For example, a transition from:

```text
0111 → 1000
```

does not necessarily happen instantaneously.

The internal transitions can ripple:

```text
0111
 ↓
0110
 ↓
0100
 ↓
0000
 ↓
1000
```

The actual transient sequence depends on the clocking scheme and flip-flop polarity.

This is one of the main reasons ripple counters are unsuitable for high-speed synchronous logic.

---

# Asynchronous Counter Clocking

The important characteristic is:

```text
Only the first flip-flop receives the external clock.
```

The remaining flip-flops are clocked by preceding outputs.

```text
External CLK
     │
     ▼
   FF0
     │
     Q0
     ▼
   FF1
     │
     Q1
     ▼
   FF2
     │
     Q2
     ▼
   FF3
```

This is what makes the counter asynchronous.

---

# Reset Behavior

The reset implementation depends on the particular RTL file.

The asynchronous counter designs in this repository use reset to force the counter into a known state.

An asynchronous reset does not wait for the clock.

For an active-low reset:

```text
rst = 0 → Reset immediately
rst = 1 → Normal operation
```

For an active-high reset:

```text
rst = 1 → Reset immediately
rst = 0 → Normal operation
```

The exact polarity should always be checked from the `always` block and reset condition in each implementation.

---

# Truncated Counter

The file:

```text
truncate.v
```

implements a truncated ripple counter.

A normal N-bit binary counter has:

```text
MOD = 2^N
```

A truncated counter intentionally resets or changes its sequence before reaching all `2^N` states.

For example, a 4-bit counter normally has:

```text
MOD = 16
```

A truncated counter can be designed to operate with fewer states.

---

## Why Truncate a Counter?

Truncation is useful when a specific modulus is required.

Examples include:

```text
MOD-3
MOD-5
MOD-6
MOD-10
MOD-12
```

A common example is a decade counter:

```text
0 → 1 → 2 → ... → 9 → 0
```

which has:

```text
MOD = 10
```

instead of the natural 16 states of a 4-bit binary counter.

---

# Truncation Logic

The basic concept is:

```text
Counter
   │
   ▼
State Detection
   │
   ▼
Reset / Clear
   │
   ▼
Initial State
```

The counter detects a particular state and uses that condition to force the counter back to its starting state.

For example:

```text
0000
0001
0010
0011
0100
0101
...
```

When the selected terminal state is detected:

```text
State Detection
       │
       ▼
     RESET
       │
       ▼
     0000
```

The counter therefore cycles through only the required number of states.

---

# Modulus of an Asynchronous Binary Counter

For an N-bit binary ripple counter:

```text
MOD = 2^N
```

Examples:

```text
N = 2 → MOD = 4
N = 3 → MOD = 8
N = 4 → MOD = 16
N = 5 → MOD = 32
N = 6 → MOD = 64
```

For a truncated counter:

```text
MOD < 2^N
```

when fewer than all possible binary states are used.

---

# Counter State Representation

A binary ripple counter naturally generates binary states.

For a 4-bit counter:

```text
0000
0001
0010
0011
0100
0101
0110
0111
1000
1001
1010
1011
1100
1101
1110
1111
```

Then the sequence returns to:

```text
0000
```

---

# Applications

Asynchronous counters are useful in applications where very high-speed synchronous operation is not required.

Common applications include:

- Frequency division
- Simple event counting
- Digital clocks
- Low-speed timing circuits
- Frequency counters
- Prescalers
- Clock divider circuits
- Simple sequence generation
- Low-cost control circuits

---

# Advantages

- Simple architecture
- Simple RTL
- Low combinational logic requirement
- Easy to implement using toggle flip-flops
- Natural binary counting sequence
- Useful for frequency division
- Fewer logic gates compared with many synchronous-counter implementations

---

# Limitations

- Propagation delay accumulates across stages
- Lower maximum operating frequency
- Intermediate states can occur during transitions
- Not ideal for high-speed synchronous systems
- Timing analysis is more complicated
- Ripple clocking can create clock-domain-like timing problems
- Truncation logic can introduce additional asynchronous paths

---

# Verification

The counter implementations can be verified by checking:

- Reset operation
- Binary counting sequence
- Correct modulus
- Frequency division
- Flip-flop toggling
- Ripple propagation
- Truncation behavior
- Counter rollover
- Correct reset polarity
- Correct terminal-state detection

Waveforms are particularly useful for observing the ripple behavior.

For example, a 4-bit counter should eventually show:

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

while also showing that the higher-order bits do not change at exactly the same instant as the lower-order bits.

---

# Timing Considerations

For a ripple counter, the accumulated propagation delay limits the maximum operating frequency.

Conceptually:

```text
T_CLK > N × t_PD + timing_margin
```

where:

```text
T_CLK     = Clock period
N         = Number of ripple stages
t_PD      = Propagation delay per stage
```

Therefore:

```text
f_MAX ≈ 1 / T_MIN
```

As `N` increases, the total ripple delay increases.

This is the primary reason synchronous counters are preferred for high-speed digital systems.

---

# Asynchronous vs Synchronous State Update

### Asynchronous Counter

```text
CLK
 │
 ▼
FF0
 │
 ▼
FF1
 │
 ▼
FF2
 │
 ▼
FF3
```

The state propagates stage-by-stage.

### Synchronous Counter

```text
          ┌──► FF0
          │
CLK ──────┼──► FF1
          │
          ├──► FF2
          │
          └──► FF3
```

All flip-flops receive the same clock.

---

# Future Implementations

Possible future additions to this folder include:

- Parameterized N-bit Ripple Counter
- Ripple Up Counter
- Ripple Down Counter
- Ripple Up/Down Counter
- Mod-N Ripple Counter
- Decade Ripple Counter
- Programmable Truncated Counter
- Frequency Divider
- Prescaler
- Counter with Terminal Count
- Counter with Enable
- Counter with Overflow Detection

---

# Key Takeaways

- An asynchronous counter is also called a **ripple counter**.
- Only the first flip-flop receives the external clock.
- Subsequent flip-flops are clocked by preceding flip-flop outputs.
- JK flip-flops can operate as toggle flip-flops using:

```text
J = 1
K = 1
```

- An N-bit binary ripple counter has:

```text
MOD = 2^N
```

- Each flip-flop divides the frequency by 2.
- The output frequencies are:

```text
Q0 = f_CLK / 2

Q1 = f_CLK / 4

Q2 = f_CLK / 8

Q3 = f_CLK / 16
```

- Propagation delay accumulates from one stage to the next.
- Higher-order bits change after lower-order stages have propagated.
- Ripple counters are therefore slower than synchronous counters.
- Truncated counters intentionally use fewer than `2^N` states.
- Asynchronous counters are particularly useful for **frequency division, simple event counting, timing circuits, and low-speed digital systems**.
