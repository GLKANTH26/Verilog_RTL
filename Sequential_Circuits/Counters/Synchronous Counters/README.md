# Synchronous Counters

Synchronous counters are sequential circuits in which all flip-flops are driven by the same clock signal. Unlike asynchronous/ripple counters, all state bits update on the same active clock edge.

This folder contains:

- Ring Counter
- Johnson Counter / Twisted Ring Counter

---

## Folder Structure

```text
Counters/
├── Asynchronous/
│   └── ...
│
└── Synchronous/
    ├── ring.v
    ├── ring_tb.v
    ├── twisted.v
    ├── twisted_tb.v
    └── README.md
```

| File | Description |
|---|---|
| `ring.v` | Parameterized N-bit Ring Counter |
| `ring_tb.v` | Testbench for Ring Counter |
| `twisted.v` | Parameterized N-bit Johnson Counter |
| `twisted_tb.v` | Testbench for Johnson Counter |
| `README.md` | Documentation |

> Note: `twisted.v` contains the module named `johnson`.

---

## What Is a Synchronous Counter?

A synchronous counter is a sequential circuit where all flip-flops receive the same clock signal.

```text
                 ┌──────────────┐
CLK ────────────►│  Flip-Flop 0 │──► Q0
       │         └──────────────┘
       │
       │         ┌──────────────┐
       ├────────►│  Flip-Flop 1 │──► Q1
       │         └──────────────┘
       │
       │         ┌──────────────┐
       └────────►│  Flip-Flop 2 │──► Q2
                 └──────────────┘
```

All flip-flops respond to the same clock edge.

The feedback signals are used as data inputs and not as clocks.

---

## Synchronous vs Asynchronous Counters

| Feature | Asynchronous Counter | Synchronous Counter |
|---|---|---|
| Clock | Rippled between flip-flops | Common clock |
| State transition | Stage-by-stage | Same clock edge |
| Propagation delay | Accumulates | Lower |
| Maximum operating speed | Lower | Higher |
| Timing analysis | More difficult | Easier |
| Hardware | Simpler | May require more logic |
| Typical use | Simple frequency division | High-speed digital systems |

---

# Ring Counter

A ring counter is a shift register in which the output of the last stage is fed back to the input of the first stage.

A single `1` circulates through the register.

For a 4-bit ring counter:

```text
0001
  ↓
0010
  ↓
0100
  ↓
1000
  ↓
0001
```

Therefore, an N-bit ring counter has N valid states.

---

## Ring Counter Architecture

```text
                  ┌─────────────────────────┐
                  │                         │
                  │                         ▼
              ┌───────┐  ┌───────┐  ┌───────┐
CLK ─────────►│ FF3   │─►│ FF2   │─►│ FF1   │─► FF0
              └───────┘  └───────┘  └───────┘
                  ▲                         │
                  └─────────────────────────┘
```

The feedback operation is implemented using:

```verilog
q <= {q[N-2:0],q[N-1]};
```

The previous MSB is fed back into the LSB.

---

## Ring Counter Implementation - ring.v

```verilog
module ring(en,clk,rst,q);
	parameter N=4;
	input en,clk,rst;
	output reg [N-1:0]q;

	always @(posedge clk or negedge rst) begin
		if(!rst)
			q<=4'b0001;
		else if(en)
			q<={q[N-2:0],q[N-1]};
	end
endmodule
```

---

## Ring Counter Parameters and Pins

### Parameter

| Parameter | Default | Description |
|---|---:|---|
| `N` | `4` | Number of counter bits |

### Inputs

| Signal | Width | Description |
|---|---:|---|
| `en` | 1 bit | Enables counter operation |
| `clk` | 1 bit | Positive-edge-triggered clock |
| `rst` | 1 bit | Asynchronous active-low reset |

### Output

| Signal | Width | Description |
|---|---:|---|
| `q` | N bits | Current ring-counter state |

---

## Ring Counter Reset

The sequential block is:

```verilog
always @(posedge clk or negedge rst)
```

This means:

- `clk` triggers normal state updates.
- `negedge rst` triggers an immediate reset.
- Reset is asynchronous.
- Reset is active-low.

When:

```text
rst = 0
```

the counter is set to:

```text
q = 0001
```

For the default 4-bit implementation:

```text
q = 4'b0001
```

The initial `1` is important because the ring counter depends on a non-zero one-hot state.

---

## Ring Counter Enable

The counter advances only when:

```text
en = 1
```

When:

```text
en = 0
```

there is no assignment to `q` inside the clocked block, so the current state is retained.

```text
en = 0 → Hold current state
en = 1 → Advance to next state
```

Example:

```text
Current state = 0100

en = 0 → 0100
en = 1 → 1000
```

---

## Ring Counter Shift Operation

The main operation is:

```verilog
q <= {q[N-2:0],q[N-1]};
```

For example:

```text
Current q = 0100
```

The individual portions are:

```text
q[N-2:0] = 100
q[N-1]   = 0
```

Therefore:

```text
q <= {100,0}
```

giving:

```text
q = 1000
```

The MSB is therefore circulated back into the LSB.

---

## Why `<=` Is Used

The statement:

```verilog
q <= ...
```

uses a non-blocking assignment.

Non-blocking assignments are used for sequential logic because the right-hand side is evaluated using the current state and the register update occurs after the current simulation event.

This models flip-flop behavior correctly.

---

## Ring Counter State Sequence

For N = 4:

| Clock | State |
|---:|---|
| Reset | `0001` |
| 1 | `0010` |
| 2 | `0100` |
| 3 | `1000` |
| 4 | `0001` |
| 5 | `0010` |
| ... | ... |

The counter therefore has:

```text
N

valid states.
```

For:

```text
N = 4
```

the modulus is:

```text
MOD = 4
```

In general:

```text
MOD = N
```

---

## Ring Counter Frequency Division

If the input clock frequency is `f_CLK` and the counter advances once per clock, each state lasts one clock period.

For an N-bit ring counter:

```text
f_state = f_CLK / N
```

For example, if:

```text
f_CLK = 100 MHz

N = 4
```

then:

```text
f_state = 100 MHz / 4
        = 25 MHz
```

The complete ring-counter sequence therefore repeats every N clock cycles.

---

## Ring Counter Important Condition

A ring counter must start with a valid one-hot non-zero state.

Valid states for a 4-bit ring counter are:

```text
0001
0010
0100
1000
```

The all-zero state is invalid:

```text
0000
```

If the counter enters:

```text
0000
```

then the feedback also remains zero:

```text
0000 → 0000 → 0000 → ...
```

Therefore, the counter becomes stuck.

A ring counter should therefore be initialized to a valid one-hot state.

---

# Johnson Counter

A Johnson counter is also called a:

- Twisted Ring Counter
- Switch-tail Ring Counter

It is similar to a ring counter, but instead of feeding the MSB directly back to the LSB, its complement is fed back.

The RTL operation is:

```verilog
q <= {q[N-2:0],~q[N-1]};
```

---

## Johnson Counter Architecture

```text
                  ┌──────────────────────────────┐
                  │                              │
                  │                         NOT  │
                  │                          │   │
                  │                          ▼   │
              ┌───────┐  ┌───────┐  ┌───────┐
CLK ─────────►│ FF3   │─►│ FF2   │─►│ FF1   │─► FF0
              └───────┘  └───────┘  └───────┘
                  ▲                              │
                  └────────── Feedback ──────────┘
```

The feedback path contains an inversion.

---

## Johnson Counter Implementation - twisted.v

The file is named `twisted.v`, while the module inside it is named `johnson`.

```verilog
module johnson#(parameter N=4)(en,clk,rst,q);
	input en,clk,rst;
	output reg [N-1:0]q;

	always @(posedge clk or negedge rst) begin
		if(!rst)
			q<=0;
		else if(en)
			q<={q[N-2:0],~q[N-1]};
	end
endmodule
```

---

## Johnson Counter Parameters and Pins

### Parameter

| Parameter | Default | Description |
|---|---:|---|
| `N` | `4` | Number of counter bits |

### Inputs

| Signal | Width | Description |
|---|---:|---|
| `en` | 1 bit | Enables counter operation |
| `clk` | 1 bit | Positive-edge-triggered clock |
| `rst` | 1 bit | Asynchronous active-low reset |

### Output

| Signal | Width | Description |
|---|---:|---|
| `q` | N bits | Current Johnson-counter state |

---

## Johnson Counter Reset

The sequential block is:

```verilog
always @(posedge clk or negedge rst)
```

Therefore:

- Clocking occurs on the positive edge of `clk`.
- Reset occurs asynchronously.
- Reset is active-low.

When:

```text
rst = 0
```

the counter is cleared:

```text
q = 0000
```

For an N-bit counter:

```text
q = 0
```

---

## Johnson Counter Enable

The counter advances only when:

```text
en = 1
```

When:

```text
en = 0
```

the current state is retained.

```text
en = 0 → Hold
en = 1 → Advance
```

---

## Johnson Counter Shift Operation

The main operation is:

```verilog
q <= {q[N-2:0],~q[N-1]};
```

The difference from the ring counter is the inversion of the feedback bit.

Ring counter:

```text
q <= {q[N-2:0],q[N-1]}
```

Johnson counter:

```text
q <= {q[N-2:0],~q[N-1]}
```

Therefore:

```text
Ring    → feedback = q[N-1]
Johnson → feedback = ~q[N-1]
```

---

## Johnson Counter State Sequence

For N = 4:

```text
0000
  ↓
0001
  ↓
0011
  ↓
0111
  ↓
1111
  ↓
1110
  ↓
1100
  ↓
1000
  ↓
0000
```

The complete sequence contains:

```text
2N

valid states.
```

For:

```text
N = 4
```

the number of states is:

```text
2N = 2 × 4 = 8
```

Therefore:

```text
MOD = 8
```

In general:

```text
MOD = 2N
```

---

## Johnson Counter Frequency Division

A Johnson counter requires 2N clock cycles to complete one complete sequence.

Therefore:

```text
f_state = f_CLK / 2N
```

For example:

```text
f_CLK = 100 MHz

N = 4
```

then:

```text
f_state = 100 MHz / 8
        = 12.5 MHz
```

The complete Johnson-counter sequence therefore repeats every 2N clock cycles.

---

# Ring Counter vs Johnson Counter

| Feature | Ring Counter | Johnson Counter |
|---|---|---|
| Feedback | Direct | Inverted |
| Feedback expression | `q[N-1]` | `~q[N-1]` |
| Number of states | N | 2N |
| 4-bit states | 4 | 8 |
| Reset state | One-hot | All zeros |
| Sequence | One `1` circulates | Continuous 0/1 pattern |
| Additional inversion | No | Yes |
| Hardware efficiency | Lower state utilization | Better state utilization |

---

# Why These Counters Are Synchronous

Both designs use:

```verilog
always @(posedge clk or negedge rst)
```

All bits of `q` are therefore updated from the same clock edge.

The feedback signal is treated as data.

It is not used as a clock.

### Synchronous Design

```text
                 ┌──────────────┐
CLK ────────────►│ All Flip-Flops│
                 └──────────────┘
                         ▲
                         │
                    Data Feedback
```

### Asynchronous Ripple Counter

```text
CLK ──► FF0 ──► FF1 ──► FF2 ──► FF3
          Clock     Clock     Clock
```

In a ripple counter, the clock effectively propagates from one stage to another. In these synchronous counters, all stages share the same clock.

---

# Ring Counter vs Binary Counter

A ring counter does not produce a normal binary counting sequence.

Binary counter:

```text
000
001
010
011
100
101
110
111
```

Ring counter:

```text
001
010
100
001
```

The ring counter therefore uses more flip-flops for the number of states it provides, but its state decoding is very simple.

---

# Johnson Counter vs Binary Counter

A Johnson counter also does not generate a normal binary sequence.

For N = 4:

```text
Binary:

0000
0001
0010
0011
0100
0101
0110
0111
...
```

Johnson:

```text
0000
0001
0011
0111
1111
1110
1100
1000
```

A 4-bit Johnson counter generates 8 states.

---

# Parameterization

Both counters use the parameter:

```verilog
parameter N=4;
```

This allows the number of flip-flops to be changed.

For example:

```verilog
ring#(8) r8(en,clk,rst,q);
```

creates an 8-bit ring counter.

Similarly:

```verilog
johnson#(8) j8(en,clk,rst,q);
```

creates an 8-bit Johnson counter.

---

## Parameterization Limitation in `ring.v`

The current `ring.v` contains:

```verilog
q<=4'b0001;
```

The counter width is parameterized using `N`, but the reset value is fixed at 4 bits.

For example, when:

```text
N = 6
```

the 4-bit value:

```text
0001
```

is assigned to the 6-bit register and becomes:

```text
000001
```

This works for the current testbench, but the reset value itself is not fully parameterized.

A more generic implementation would be:

```verilog
q <= {{(N-1){1'b0}},1'b1};
```

This gives:

```text
N = 4 → 0001
N = 6 → 000001
N = 8 → 00000001
```

For complete arbitrary-width support, the N = 1 case should also be handled separately.

---

# Ring Counter Testbench

The testbench is:

```text
ring_tb.v
```

It uses:

```verilog
localparam N=6;
```

Therefore, the testbench verifies a 6-bit ring counter.

The DUT is instantiated using:

```verilog
ring#(N) r6(en,clk,rst,q);
```

---

## Ring Counter Testbench Operation

Initially:

```text
rst = 0
en  = 0
```

The counter is therefore held in reset.

After 8 time units:

```text
rst = 1
```

Reset is released.

After another 10 time units:

```text
en = 1
```

The counter starts advancing on the positive clock edges.

---

## Ring Counter Clock Generation

The testbench contains:

```verilog
clk=0;
forever #5 clk=~clk;
```

Therefore:

```text
Clock half-period = 5 time units
Clock period      = 10 time units
```

The counter updates on every positive edge of `clk` when `en = 1`.

---

# Johnson Counter Testbench

The testbench is:

```text
twisted_tb.v
```

It uses:

```verilog
localparam N=4;
```

The DUT is instantiated using:

```verilog
johnson#(N) tr(en,clk,rst,q);
```

---

## Johnson Counter Testbench Operation

Initially:

```text
rst = 0
en  = 0
```

After 8 time units:

```text
rst = 1
```

Reset is released.

After another 10 time units:

```text
en = 1
```

The Johnson counter starts advancing on each positive clock edge.

---

# Verification

The testbenches verify:

- Asynchronous reset
- Enable functionality
- State progression
- State holding
- Circular feedback
- Johnson feedback inversion
- Correct state sequence
- Parameterized counter width

The testbenches use:

```verilog
$monitor(...)
```

to display:

```text
Time
Clock
Reset
Enable
Counter state
```

They also use:

```verilog
$fsdbDumpvars();
```

for waveform dumping.

---

# Expected Ring Counter Sequence

For a 4-bit ring counter:

```text
Reset → 0001

Clock 1 → 0010
Clock 2 → 0100
Clock 3 → 1000
Clock 4 → 0001
Clock 5 → 0010
...
```

The sequence repeats every 4 clock cycles.

---

# Expected Johnson Counter Sequence

For a 4-bit Johnson counter:

```text
Reset → 0000

Clock 1 → 0001
Clock 2 → 0011
Clock 3 → 0111
Clock 4 → 1111
Clock 5 → 1110
Clock 6 → 1100
Clock 7 → 1000
Clock 8 → 0000
...
```

The sequence repeats every 8 clock cycles.

---

# Timing Considerations

Although these counters are synchronous, the feedback path still has to satisfy the timing requirements of the flip-flops.

For a synchronous path:

```text
T_CLK ≥ t_CLK→Q + t_COMB + t_SETUP
```

where:

```text
t_CLK→Q = Clock-to-Q delay of the flip-flop

t_COMB = Combinational logic delay

t_SETUP = Setup time of the receiving flip-flop
```

In an ASIC implementation, clock skew, clock uncertainty, PVT variation, and other timing margins must also be considered.

---

# Advantages

## Ring Counter

- Simple RTL
- Simple feedback
- One-hot state representation
- Easy state decoding
- Predictable sequence
- Useful for timing and control generation

## Johnson Counter

- 2N states using N flip-flops
- Simple feedback structure
- Simple state decoding
- Easy sequence generation
- Useful for timing and frequency division

---

# Limitations

## Ring Counter

- Requires a valid one-hot initial state
- Uses N flip-flops for N states
- Poor state utilization
- Invalid states can cause incorrect operation

## Johnson Counter

- Provides only 2N valid states
- Remaining states are invalid
- Requires correct initialization
- Not suitable when normal binary counting is required

---

# Applications

## Ring Counter

- One-hot FSMs
- Sequence generators
- Timing generators
- Control sequencing
- Clock phase generation
- Memory control
- Digital switching
- Control signal generation

## Johnson Counter

- Frequency division
- Sequence generation
- Timing generation
- Control circuits
- FSM state generation
- Digital control logic
- Decoder-friendly state generation

---

# Future Implementations

Possible future synchronous-counter implementations include:

- Binary Up Counter
- Binary Down Counter
- Up/Down Counter
- Mod-N Counter
- Decade Counter
- Programmable Counter
- Gray-Code Counter
- Saturating Counter
- Counter with Terminal Count
- Counter with Overflow/Underflow Flags
- Counter with Programmable Modulus
- Counter with Synchronous Reset
- Counter with Clock Enable
- Parameterized Counter

---

# Key Takeaways

- Synchronous counters use a **common clock** for all flip-flops.
- Ring counters circulate a single `1` through the register.
- An N-bit ring counter has:

```text
MOD = N
```

- Johnson counters circulate the **inverted MSB**.
- An N-bit Johnson counter has:

```text
MOD = 2N
```

- Ring counter sequence frequency:

```text
f_state = f_CLK / N
```

- Johnson counter sequence frequency:

```text
f_state = f_CLK / 2N
```

- `en = 0` holds the current state.
- `en = 1` advances the counter.
- Both implementations use an asynchronous active-low reset.
- Sequential state updates use non-blocking assignment `<=`.
- Ring counters require a valid non-zero one-hot initial state.
- Johnson counters can start naturally from all zeros.
- Both are useful for **sequence generation, timing generation, control logic, and frequency division**.
