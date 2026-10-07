# Asynchronous Counters

This folder contains RTL implementations of **asynchronous (ripple) counters** using JK and T flip-flops.

The designs demonstrate:

- Ripple-counter operation
- Cascaded flip-flop clocking
- Up-counting
- Frequency division
- JK/T flip-flop based counter design
- Truncated counting
- Reset behavior
- Propagation delay in asynchronous counters
- Hierarchical reuse of the existing JK flip-flop

---

## Folder Structure

```text
Asynchronous/
├── rc_2.v
├── rc_2_tb.v
├── rc_3.v
├── rc_3_tb.v
├── rc_4.v
├── rc_4_tb.v
├── ripple_counter.v
├── ripple_counter_tb.v
├── truncate.v
├── truncate_tb.v
└── README.md
```

| File | Description |
|---|---|
| `rc_2.v` | 4-bit asynchronous counter using JK flip-flops |
| `rc_2_tb.v` | Testbench for `rc_2.v` |
| `rc_3.v` | 4-bit asynchronous counter using a different clock-edge/cascade configuration |
| `rc_3_tb.v` | Testbench for `rc_3.v` |
| `rc_4.v` | 4-bit asynchronous counter using T flip-flops |
| `rc_4_tb.v` | Testbench for `rc_4.v` |
| `ripple_counter.v` | Ripple counter using the existing JK flip-flop |
| `ripple_counter_tb.v` | Testbench for `ripple_counter.v` |
| `truncate.v` | Truncated asynchronous counter |
| `truncate_tb.v` | Testbench for `truncate.v` |

---

## What Is a Counter?

A counter is a sequential circuit that moves through a predefined sequence of states in response to clock events.

For a 4-bit binary up counter:

```text
0000
  ↓
0001
  ↓
0010
  ↓
0011
  ↓
0100
  ↓
...
1110
  ↓
1111
  ↓
0000
```

A 4-bit counter has:

\[
2^4=16
\]

possible states.

Therefore, a normal 4-bit binary counter is a **MOD-16 counter**.

---

## Why Counters Are Required

Counters are used whenever a digital system needs to:

- Count clock pulses
- Count events
- Generate timing sequences
- Divide clock frequency
- Generate addresses
- Control sequential operations
- Implement timers
- Generate periodic control signals

Typical structure:

```text
Clock
  │
  ▼
Counter
  │
  ├──► Event counting
  ├──► Timing generation
  ├──► Frequency division
  ├──► Address generation
  └──► Control sequencing
```

---

## Why Asynchronous Counters?

An asynchronous counter is useful when a simple counter with relatively low hardware complexity is required.

The key characteristic is:

> **Only the first flip-flop receives the external clock. The subsequent flip-flops are clocked by outputs of preceding flip-flops.**

```text
External CLK
     │
     ▼
   ┌────┐
   │ FF0│
   └─┬──┘
     │ Q0
     ▼
   ┌────┐
   │ FF1│
   └─┬──┘
     │ Q1
     ▼
   ┌────┐
   │ FF2│
   └─┬──┘
     │ Q2
     ▼
   ┌────┐
   │ FF3│
   └────┘
```

Because the clocking propagates from one stage to the next, the circuit is called a **ripple counter**.

---

## Asynchronous vs Synchronous Counters

| Feature | Asynchronous Counter | Synchronous Counter |
|---|---|---|
| External clock | First flip-flop | All flip-flops |
| Clock for later stages | Previous FF output | Common clock |
| State transition | Propagates stage by stage | All FFs respond to same clock |
| Propagation delay | Accumulates | Much smaller |
| Hardware complexity | Lower | Higher |
| Maximum speed | Lower | Higher |
| Main characteristic | Ripple effect | Common-clock operation |

### Asynchronous

```text
CLK → FF0 → FF1 → FF2 → FF3
```

### Synchronous

```text
          ┌──► FF0
          │
          ├──► FF1
CLK ──────┼──► FF2
          │
          └──► FF3
```

The synchronous version will be covered separately in the `Synchronous` folder.

---

## Ripple Counter Architecture

A JK flip-flop toggles when:

```text
J = 1
K = 1
```

Therefore:

```text
J = K = 1
     │
     ▼
Toggle operation
```

A chain of such flip-flops can be used to create a binary counter.

```text
             J=1 K=1
CLK ───────► ┌──────┐
             │ JK0  │
             └──┬───┘
                Q0
                 │
                 ▼
             ┌──────┐
             │ JK1  │
             └──┬───┘
                Q1
                 │
                 ▼
             ┌──────┐
             │ JK2  │
             └──┬───┘
                Q2
                 │
                 ▼
             ┌──────┐
             │ JK3  │
             └──────┘
```

Each stage represents one binary bit.

---

## Why JK/T Flip-Flops Work for Counters

A counter requires the individual bits to toggle.

For a T flip-flop:

\[
T=1 \Rightarrow Q_{next}=\overline{Q}
\]

For a JK flip-flop:

\[
J=K=1 \Rightarrow Q_{next}=\overline{Q}
\]

Therefore, both can be used as toggle elements in a counter.

| Flip-Flop | Counter Configuration |
|---|---|
| JK | `J = 1`, `K = 1` |
| T | `T = 1` |

---

## `rc_2.v` — JK-Based Ripple Counter

`rc_2.v` implements a 4-bit asynchronous counter using JK flip-flops.

The JK flip-flops are configured for toggle operation:

```text
J = 1
K = 1
```

The clocking is cascaded between stages.

Conceptually:

```text
CLK
 │
 ▼
FF0
 │
 └──► next clock
        │
        ▼
       FF1
        │
        └──► next clock
               │
               ▼
              FF2
               │
               └──► next clock
                      │
                      ▼
                     FF3
```

The particular `Q`/`Q̅` connection determines which clock transition activates the next stage.

---

## Clock Propagation in `rc_2`

The design uses the complemented output of each stage to clock the following stage.

Conceptually:

```text
CLK → FF0
Q̅0 → FF1 clock
Q̅1 → FF2 clock
Q̅2 → FF3 clock
```

When a lower-order bit changes from:

```text
1 → 0
```

its complemented output changes:

```text
0 → 1
```

creating the required rising edge for the next stage.

This produces the binary carry behavior.

For example:

```text
0001
  ↓
0010
```

`Q0` changes:

```text
1 → 0
```

which causes the next stage to toggle.

---

## Binary Counting Sequence

For a 4-bit up counter:

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
0000
```

The counter therefore operates as:

\[
MOD=16
\]

---

## `rc_3.v` — Alternative Ripple Configuration

`rc_3.v` implements another 4-bit asynchronous counter configuration.

Its JK flip-flop uses a different clock/reset arrangement:

```verilog
always @(negedge clk or posedge rst)
```

Therefore, the local flip-flop responds to the **falling edge of its clock** and uses an **active-high asynchronous reset**.

The cascade uses the output of one stage to clock the next stage.

```text
CLK → FF0
Q0  → FF1
Q1  → FF2
Q2  → FF3
```

This demonstrates an important asynchronous-counter design parameter:

> **The selected clock edge and whether `Q` or `Q̅` is cascaded determine the counting behavior.**

---

## `rc_4.v` — T Flip-Flop Based Counter

`rc_4.v` demonstrates an asynchronous counter using T flip-flops.

The T input is held at:

```text
T = 1
```

so every active clock edge causes the corresponding flip-flop to toggle.

```text
T = 1
 ↓
Toggle
```

The flip-flops are cascaded:

```text
CLK → TFF0 → TFF1 → TFF2 → TFF3
```

This shows that JK flip-flops are not the only storage elements suitable for ripple counters.

A T flip-flop is particularly natural for counters because its primary operation is toggling.

---

## JK Flip-Flop vs T Flip-Flop for Counters

| Feature | JK Flip-Flop | T Flip-Flop |
|---|---|---|
| Toggle condition | `J=K=1` | `T=1` |
| Inputs required | 2 | 1 |
| Counter use | Configure for toggle | Direct toggle operation |
| Main advantage | General-purpose FF | Simple counter implementation |

A JK flip-flop can effectively be converted into a T flip-flop by connecting:

```text
J = T
K = T
```

For a permanent toggle:

```text
J = K = 1
```

---

## `ripple_counter.v` — Reusing the Repository JK Flip-Flop

This implementation is important from a repository-design perspective because it reuses the existing JK flip-flop instead of defining another JK flip-flop.

The dependency is:

```text
Sequential_Circuits/
├── Flip_Flops/
│   └── jk.v
│
└── Counters/
    └── Asynchronous/
        └── ripple_counter.v
```

The counter therefore depends on:

```text
Flip_Flops/jk.v
```

This demonstrates **hierarchical RTL design and module reuse**.

---

## Repository Dependency

The existing `jk.v` in the `Flip_Flops` folder has a six-port interface including both `q` and `qbar`.

Therefore, when `ripple_counter.v` instantiates this module, its port connections must match that interface.

The intended connection is conceptually:

```verilog
wire [3:0] qbar;

jk tff0(1'b1,1'b1,clk,rst,q[0],qbar[0]);
jk tff1(1'b1,1'b1,q[0],rst,q[1],qbar[1]);
jk tff2(1'b1,1'b1,q[1],rst,q[2],qbar[2]);
jk tff3(1'b1,1'b1,q[2],rst,q[3],qbar[3]);
```

The exact implementation should be kept consistent with the actual `jk.v` interface in the repository.

---

## Truncated Counters

A normal N-bit binary counter has:

\[
2^N
\]

states.

A truncated counter intentionally uses fewer states.

Examples:

| Counter | Number of States |
|---|---:|
| MOD-4 | 4 |
| MOD-6 | 6 |
| MOD-10 | 10 |
| MOD-12 | 12 |
| MOD-16 | 16 |

For example, a MOD-10 counter should follow:

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
0000
```

The states:

```text
1010 → 1111
```

are not part of the desired counting sequence.

---

## `truncate.v` — Truncated Ripple Counter

`truncate.v` demonstrates state decoding to truncate the normal counting sequence.

The design uses combinational logic to detect a particular counter state.

The detection logic includes:

```verilog
nand n1(trunc,q[3],q[1]);
```

which detects the condition:

\[
Q_3Q_1=1
\]

through the NAND output.

The decoded condition is then combined with reset control.

Conceptually:

```text
Counter Outputs
      │
      ▼
State Detection Logic
      │
      ▼
Reset Control
      │
      ▼
Counter returns to reset state
```

This is the basic principle used to construct **MOD-N counters from larger binary counters**.

---

## Why Truncated Counters Are Useful

A system may require a specific number of states rather than a power-of-two sequence.

Examples:

```text
MOD-10 → Decimal/decade counting
MOD-12 → Clock-related counting
MOD-60 → Seconds/minutes
MOD-24 → Hours
```

The basic approach is:

```text
Binary Counter
      │
      ▼
Detect unwanted/terminal state
      │
      ▼
Reset counter
```

---

## Propagation Delay in Ripple Counters

The major limitation of an asynchronous counter is **accumulated propagation delay**.

The state transition occurs stage by stage:

```text
CLK
 ↓
FF0
 ↓
FF1
 ↓
FF2
 ↓
FF3
```

Each flip-flop has a clock-to-Q delay.

For an N-stage ripple counter, the total ripple delay approximately grows with the number of stages:

\[
T_{ripple}\approx N \times t_{CQ}
\]

with additional delay depending on the actual implementation and interconnect.

Therefore:

```text
More stages
    ↓
More accumulated delay
    ↓
Lower maximum operating frequency
```

---

## Intermediate States During Ripple

Consider the transition:

```text
0111 → 1000
```

Ideally, four bits appear to change simultaneously.

In an asynchronous counter, the transition propagates:

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

These intermediate states exist only because the flip-flops do not change at exactly the same instant.

This can produce temporary glitches if the counter outputs are used directly by other logic.

---

## Frequency Division

Every toggle flip-flop divides its input clock frequency by two.

For a 4-bit ripple counter:

\[
f_{Q0}=\frac{f_{CLK}}{2}
\]

\[
f_{Q1}=\frac{f_{CLK}}{4}
\]

\[
f_{Q2}=\frac{f_{CLK}}{8}
\]

\[
f_{Q3}=\frac{f_{CLK}}{16}
\]

Therefore:

```text
CLK
 │
 ├──► Q0 = CLK / 2
 │
 ├──► Q1 = CLK / 4
 │
 ├──► Q2 = CLK / 8
 │
 └──► Q3 = CLK / 16
```

This makes asynchronous counters useful as simple **clock-frequency dividers**.

---

## Reset Behavior

Reset behavior is not identical across all current implementations.

### `rc_2.v`

Uses:

```verilog
negedge rst
```

with:

```verilog
if(!rst)
```

Therefore:

**Asynchronous active-low reset**

```text
RST = 0 → Q = 0
```

### `rc_3.v`

Uses:

```verilog
posedge rst
```

with:

```verilog
if(rst)
```

Therefore:

**Asynchronous active-high reset**

```text
RST = 1 → Q = 0
```

### `rc_4.v`

The current implementation should be checked carefully because its reset sensitivity and reset condition are not aligned. Before treating it as final RTL, the reset polarity should be made consistent.

---

## Parameterization

The current counter implementations are primarily fixed 4-bit designs.

For example:

```text
q[3:0]
```

represents four counter bits.

A generalized counter can instead be written using:

```verilog
parameter N = 4
```

with:

```verilog
output [N-1:0] q;
```

Then:

```text
N = 3 → MOD-8
N = 4 → MOD-16
N = 5 → MOD-32
N = 8 → MOD-256
```

This allows one RTL module to support multiple counter widths.

A future modulo-parameterized implementation could additionally define:

```text
WIDTH
MODULUS
RESET_POLARITY
COUNT_DIRECTION
```

to make the counter more reusable.

---

## Verification

Each counter has a dedicated testbench:

```text
rc_2.v
   └──► rc_2_tb.v

rc_3.v
   └──► rc_3_tb.v

rc_4.v
   └──► rc_4_tb.v

ripple_counter.v
   └──► ripple_counter_tb.v

truncate.v
   └──► truncate_tb.v
```

The testbenches verify:

- Reset behavior
- Counting sequence
- Clock response
- Flip-flop cascading
- Toggle operation
- Truncated counting
- Output state transitions
- Frequency-division behavior

Waveforms are dumped using:

```verilog
$fsdbDumpvars();
```

and can be inspected using a waveform viewer.

---

## What to Observe in Waveforms

For an asynchronous counter, the final count alone is not sufficient.

Important observations include:

### Clock Cascade

```text
CLK → FF0 → FF1 → FF2 → FF3
```

### Ripple Delay

Check that later stages change after earlier stages.

### Frequency Division

```text
Q0 → CLK/2
Q1 → CLK/4
Q2 → CLK/8
Q3 → CLK/16
```

### Multi-Bit Transitions

Pay particular attention to:

```text
0111 → 1000
1111 → 0000
```

to observe the ripple behavior and intermediate transitions.

---

## Advantages

- Simple architecture
- Low combinational hardware
- Easy to construct from JK/T flip-flops
- Natural frequency division
- Useful for low-speed counting applications
- Good for understanding sequential timing and ripple behavior

---

## Limitations

- Accumulated propagation delay
- Lower maximum operating frequency
- Intermediate/glitch states
- Clock skew between stages
- More difficult timing analysis
- Not preferred for high-speed synchronous datapaths

The propagation-delay limitation is the main reason to move from asynchronous counters to **synchronous counters**.

---

## Applications

Asynchronous counters can be used for:

- Low-speed event counting
- Frequency division
- Simple timers
- Clock-divider circuits
- Basic sequencing
- Educational and architectural demonstrations
- Applications where ripple delay is acceptable

---

## Future Implementations

Possible extensions of this folder include:

### Counter Variants

- Parameterized N-bit ripple counter
- Asynchronous up counter
- Asynchronous down counter
- Asynchronous up/down counter
- Programmable modulo counter

### Modulo Counters

- MOD-3
- MOD-5
- MOD-6
- MOD-10
- MOD-12
- MOD-60
- Generic MOD-N counter

### Additional Designs

- Frequency divider
- Ring counter
- Johnson counter
- Programmable ripple counter

### RTL Improvements

- Parameterized counter width
- Parameterized modulus
- Configurable count direction
- Consistent reset polarity
- Reusable JK/T flip-flop modules
- Clean hierarchical module dependencies

---

## Asynchronous Counter Design Flow

```text
Select Flip-Flop
       │
       ▼
Configure for Toggle
       │
       ▼
Connect first FF to external clock
       │
       ▼
Cascade FF outputs as subsequent clocks
       │
       ▼
Add reset
       │
       ▼
Add state decoding if truncation is required
       │
       ▼
Verify ripple transitions and timing
```

---

## Relationship to Synchronous Counters

The main limitation observed in this folder is:

```text
FF0 → FF1 → FF2 → FF3
```

where every stage waits for the previous stage.

A synchronous counter removes this ripple clocking:

```text
             ┌──► FF0
             │
             ├──► FF1
CLK ─────────┼──► FF2
             │
             └──► FF3
```

All flip-flops receive the same clock, while combinational logic determines which flip-flops toggle.

Therefore:

```text
Asynchronous Counter
        ↓
Understand ripple operation
        ↓
Understand propagation delay
        ↓
Synchronous Counter
        ↓
Common clock + next-state logic
```

The `Synchronous` folder will cover this architecture separately.

---

## Key Takeaways

- An asynchronous counter is also called a **ripple counter**.
- Only the first flip-flop receives the external clock.
- Subsequent flip-flops are clocked by preceding flip-flop outputs.
- JK flip-flops can be configured for toggle operation using `J=K=1`.
- T flip-flops naturally provide the required toggle operation using `T=1`.
- `Q` versus `Q̅` and the active clock edge determine how the ripple propagates.
- Each stage divides the input frequency by two.
- A 4-bit binary counter is MOD-16.
- Truncated counters use state decoding to obtain a smaller modulus.
- Ripple propagation introduces accumulated clock-to-Q delay.
- Intermediate states can occur during multi-bit transitions.
- Asynchronous counters are simple but are generally unsuitable for high-speed synchronous datapaths.
- `ripple_counter.v` demonstrates reuse of the existing `Flip_Flops/jk.v` module.
- The current RTL should be cleaned for consistent port connections and reset behavior before final repository submission.
