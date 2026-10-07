# Mealy FSM

A Mealy Finite State Machine is an FSM in which the output depends on both the **current state** and the **current input**.

```text
Output = f(Current State, Input)
```

Because the output is generated directly from the current state and input, a Mealy FSM can often detect an input sequence **without requiring a separate detection state**.

This folder contains Mealy FSM implementations for:

- Overlapping `1001` sequence detection
- Non-overlapping `1001` sequence detection

---

## Folder Structure

```text
FSM/
└── Mealy/
    ├── ov1001.v
    ├── ov1001_tb.v
    ├── ov_1001_n.v
    ├── ov_1001_n_tb.v
    └── README.md
```

| File | Description |
|---|---|
| `ov1001.v` | Overlapping Mealy `1001` sequence detector |
| `ov1001_tb.v` | Testbench for overlapping detector |
| `ov_1001_n.v` | Non-overlapping Mealy `1001` sequence detector |
| `ov_1001_n_tb.v` | Testbench for non-overlapping detector |
| `README.md` | Mealy FSM documentation |

---

## What Is a Mealy FSM?

A Mealy FSM generates its output based on:

```text
Current State + Input
```

Therefore:

```text
Output = f(Current State, Input)
```

The basic structure is:

```text
                  Input
                    │
                    │
                    ▼
            ┌───────────────┐
            │ Next-State    │
            │ Logic         │
            └───────┬───────┘
                    │
                    ▼
            ┌───────────────┐
            │ State         │
            │ Register      │
            └───────┬───────┘
                    │
                    ▼
              Current State
                    │
                    │
          ┌─────────┴─────────┐
          │                   │
          ▼                   ▼
       Input             Output Logic
          │                   │
          └─────────┬─────────┘
                    ▼
                  Output
```

The important point is that the output logic receives **both current state and input**.

---

## Mealy FSM vs Moore FSM

| Feature | Mealy FSM | Moore FSM |
|---|---|---|
| Output depends on | State + Input | State only |
| Detection output | Can occur on transition | Usually requires detection state |
| Number of states | Usually fewer | Usually more |
| Response | Faster | Usually one state transition later |
| Output sensitivity | Input changes can affect output | Output changes with state |
| Output logic | State + input | State |

For sequence detection, this difference is particularly important.

---

# Mealy FSM for Sequence Detection

A sequence detector examines a serial input stream and generates an output when the required pattern is detected.

For this folder, the target sequence is:

```text
1001
```

The FSM remembers how much of the sequence has already been matched.

For example:

```text
Input:

1 0 0 1
```

The FSM progresses through states representing:

```text
Nothing matched
     ↓
1 matched
     ↓
10 matched
     ↓
100 matched
     ↓
1001 detected
```

In a Mealy FSM, the final `1` can directly generate the detection output.

Therefore, a separate `1001 detected` state is not necessary.

---

# State Representation

For the overlapping detector, four states are used:

```text
S_1 = 00
S_2 = 01
S_3 = 10
S_4 = 11
```

The states represent the progress toward detecting `1001`.

Conceptually:

```text
S_1 → Nothing matched

S_2 → 1 matched

S_3 → 10 matched

S_4 → 100 matched
```

When the FSM is in `S_4` and receives `1`:

```text
S_4 + 1
   ↓
100 + 1
   ↓
1001 detected
```

The output becomes:

```text
det = 1
```

---

# Overlapping Mealy `1001`

The implementation is:

```text
ov1001.v
```

The module is:

```verilog
module ov_mealy_1001(
    input wire clk,
    input wire rst,
    input wire in,
    output reg det
);
```

### Ports

| Port | Direction | Width | Description |
|---|---|---:|---|
| `clk` | Input | 1 | Clock |
| `rst` | Input | 1 | Asynchronous active-low reset |
| `in` | Input | 1 | Serial input |
| `det` | Output | 1 | Sequence detection output |

---

## State Register

The current state is stored in:

```verilog
reg [1:0] cs,ns;
```

where:

```text
cs = Current State
ns = Next State
```

The state register is:

```verilog
always @(posedge clk or negedge rst) begin
    if(!rst)
        cs<=S_1;
    else 
        cs<=ns;
end
```

Therefore:

```text
posedge clk → Update state

negedge rst → Immediately reset state
```

The reset is:

```text
Asynchronous active-low reset
```

---

## Reset Behavior

When:

```text
rst = 0
```

the FSM immediately enters:

```text
S_1 = 00
```

When:

```text
rst = 1
```

the FSM operates normally.

The reset does not wait for a clock edge.

---

# Overlapping `1001` State Transitions

The state transitions are:

```text
             1
       ┌─────────────┐
       │             ▼
     S_1 ──────────► S_2
      ▲               │
      │               │ 0
      │               ▼
      │             S_3
      │               │
      │               │ 0
      │               ▼
      │             S_4
      │               │
      │            1 / det=1
      │               │
      │               ▼
      └───────────── S_2
```

The important overlapping transition is:

```text
S_4 + 1 → S_2
```

with:

```text
det = 1
```

The FSM moves to `S_2` rather than returning to `S_1`.

This allows the final `1` of the detected sequence to also serve as the beginning of another possible `1001`.

---

## Complete Overlapping Transition Table

| Current State | Input | Next State | `det` |
|---|---:|---|---:|
| `S_1` | 0 | `S_1` | 0 |
| `S_1` | 1 | `S_2` | 0 |
| `S_2` | 0 | `S_3` | 0 |
| `S_2` | 1 | `S_2` | 0 |
| `S_3` | 0 | `S_4` | 0 |
| `S_3` | 1 | `S_2` | 0 |
| `S_4` | 0 | `S_1` | 0 |
| `S_4` | 1 | `S_2` | 1 |

The detection occurs specifically at:

```text
Current State = S_4
Input = 1
```

because:

```text
S_4 represents 100
```

and:

```text
100 + 1 = 1001
```

---

# Why `det` Is Asserted in the Transition

The important Mealy behavior is:

```verilog
S_4: begin
    if(in) begin
        ns=S_2;
        det=1'b1;
    end
```

The output is determined by:

```text
Current State = S_4
Input = 1
```

Therefore:

```text
det = f(cs,in)
```

This is the defining characteristic of a Mealy FSM.

A Moore FSM would normally require entering a separate detection state and generating the output from that state.

---

# Overlapping Detection Example

Consider:

```text
Input = 1001001
```

The first occurrence is:

```text
1001
```

The second occurrence begins before the previous detected sequence has completely become irrelevant.

The FSM therefore retains useful state information.

Conceptually:

```text
1001
   1001
```

The final `1` of the first detection can also contribute to the next sequence.

This is why:

```text
S_4 + 1 → S_2
```

rather than:

```text
S_4 + 1 → S_1
```

---

# Non-Overlapping Mealy `1001`

The implementation is:

```text
ov_1001_n.v
```

The module is:

```verilog
module mealy_1001_non_ov(
    input wire clk,
    input wire rst,
    input wire in,
    output reg det
);
```

### Ports

| Port | Direction | Width | Description |
|---|---|---:|---|
| `clk` | Input | 1 | Clock |
| `rst` | Input | 1 | Asynchronous active-low reset |
| `in` | Input | 1 | Serial input |
| `det` | Output | 1 | Sequence detection output |

---

## Non-Overlapping State Encoding

The FSM uses:

```text
S_0 = 00
S_1 = 01
S_2 = 10
S_3 = 11
```

The states represent:

```text
S_0 → Nothing matched

S_1 → 1 matched

S_2 → 10 matched

S_3 → 100 matched
```

---

## Non-Overlapping State Transitions

The important detection transition is:

```text
S_3 + 1
   ↓
100 + 1
   ↓
1001 detected
```

The FSM then returns to:

```text
S_0
```

Therefore, the detected sequence is not reused for another overlapping detection.

---

## Complete Non-Overlapping Transition Table

| Current State | Input | Next State | `det` |
|---|---:|---|---:|
| `S_0` | 0 | `S_0` | 0 |
| `S_0` | 1 | `S_1` | 0 |
| `S_1` | 0 | `S_2` | 0 |
| `S_1` | 1 | `S_1` | 0 |
| `S_2` | 0 | `S_3` | 0 |
| `S_2` | 1 | `S_1` | 0 |
| `S_3` | 0 | `S_0` | 0 |
| `S_3` | 1 | `S_0` | 1 |

The key difference from the overlapping detector is:

```text
Overlapping:

S_4 + 1 → S_2
det = 1
```

while:

```text
Non-overlapping:

S_3 + 1 → S_0
det = 1
```

---

# Overlapping vs Non-Overlapping

| Feature | Overlapping | Non-Overlapping |
|---|---|---|
| Target sequence | `1001` | `1001` |
| Detection | `S_4 + 1` | `S_3 + 1` |
| Output | `det = 1` | `det = 1` |
| State after detection | `S_2` | `S_0` |
| Reuses detected sequence | Yes | No |
| Supports overlapping patterns | Yes | No |

---

# Example Comparison

Consider the input:

```text
1001001
```

### Overlapping Detector

The sequence `1001` can be detected again using the final `1` as part of the next sequence.

```text
1001
   1001
```

The FSM retains useful state information.

### Non-Overlapping Detector

After detecting the first:

```text
1001
```

the FSM returns to the initial state.

The next detection must begin from a fresh sequence.

---

# Next-State Logic

The next-state logic is combinational.

The implementation uses:

```verilog
always @(*) begin
    det=1'b0;
    ns=S_1;

    case(cs)
        ...
    endcase
end
```

The general relationship is:

```text
ns = f(cs,in)
```

and for the Mealy output:

```text
det = f(cs,in)
```

Both next state and output therefore depend on the current state and input.

---

# Why `always @(*)` Is Used

The next-state and output logic are combinational.

Therefore:

```verilog
always @(*)
```

is used.

The block should respond whenever any signal used inside it changes.

This prevents an incomplete sensitivity list from causing simulation mismatches.

---

# Default Assignments

The combinational block begins with default assignments:

```verilog
det=1'b0;
ns=S_1;
```

or:

```verilog
det=0;
ns=S_0;
```

These defaults ensure that:

- `det` always receives a defined value
- `ns` always receives a defined value
- Unspecified conditions do not infer latches
- The `default` state can safely recover the FSM

---

# Default State Recovery

The implementations include a `default` case.

For example:

```verilog
default:begin
    ns=S_1;
    det=1'b0;
end
```

If the FSM somehow enters an invalid state, it returns to a known valid state.

This is useful for robust RTL design.

---

# Non-Blocking Assignment

The state register uses:

```verilog
cs <= ns;
```

The non-blocking assignment operator `<=` is appropriate for sequential logic.

It models the behavior of flip-flops, where the state is updated on the active clock edge.

---

# Blocking Assignment in Combinational Logic

The combinational block uses assignments such as:

```verilog
ns = S_1;
det = 1'b0;
```

Blocking assignment `=` is commonly used in combinational procedural logic because statements execute sequentially within the procedural block.

Therefore, the general coding pattern is:

```text
Sequential logic     → <=

Combinational logic  → =
```

---

# Mealy FSM Timing

The state register updates on the positive clock edge:

```text
posedge clk
     │
     ▼
Current State
```

The input and current state then determine:

```text
Next State
Output
```

Conceptually:

```text
Clock Edge
    │
    ▼
State Register
    │
    ▼
Current State
    │
    ├─────────────┐
    │             │
    ▼             ▼
Next-State      Output
Logic           Logic
    │             │
    ▼             ▼
Next State       det
```

---

# Mealy Output Timing

Because:

```text
det = f(Current State, Input)
```

the output can change when the input changes.

This is different from a Moore FSM, where:

```text
det = f(Current State)
```

Therefore, Mealy FSMs can provide a faster response but require greater care when the output drives timing-sensitive logic.

---

# Sequence Detection Timing

For the target sequence:

```text
1001
```

the detection happens when the final `1` arrives.

```text
Input:
1    0    0    1
│    │    │    │
▼    ▼    ▼    ▼
S1   S2   S3   S4
              │
              └── det = 1
```

The Mealy FSM does not need to wait for another state transition to generate the detection signal.

---

# Testbench - Overlapping Detector

The testbench is:

```text
ov1001_tb.v
```

The DUT is instantiated as:

```verilog
ov_mealy_1001 dut(clk,rst,in,det);
```

The clock is generated using:

```verilog
clk=1'b0;
forever #5 clk=~clk;
```

Therefore:

```text
Clock half-period = 5 time units

Clock period = 10 time units
```

---

## Overlapping Test Sequence

The testbench applies:

```text
1
0
0
1
0
0
1
1
0
0
```

This allows the overlapping `1001` detector to be exercised multiple times.

The testbench uses:

```verilog
$monitor(...)
```

to display:

```text
Time
Reset
Input
Detected
```

and:

```verilog
$fsdbDumpvars();
```

for waveform analysis.

---

# Testbench - Non-Overlapping Detector

The testbench is:

```text
ov_1001_n_tb.v
```

The testbench uses a task:

```verilog
task drive(input i);
begin
    @(negedge clk);
    in=i;
end
endtask
```

This changes the input on the negative edge of the clock.

Therefore, the input is established before the next positive edge where the FSM state updates.

---

## Why Drive Input on the Negative Edge?

The FSM state updates on:

```text
posedge clk
```

The testbench changes the input on:

```text
negedge clk
```

Therefore:

```text
negedge → Input changes
        ↓
Input remains stable
        ↓
posedge → FSM samples input
```

This creates a clean testbench timing relationship.

---

# Verification

The Mealy FSM implementations should be verified for:

- Reset behavior
- Correct state transitions
- Correct `1001` detection
- Overlapping detection
- Non-overlapping detection
- Correct output assertion
- Correct output deassertion
- Invalid-state recovery
- Input timing
- Counter/sequence rollover behavior

The most important waveform signals are:

```text
clk
rst
in
cs
ns
det
```

---

# Advantages of Mealy FSMs

- Usually requires fewer states than an equivalent Moore FSM
- Output can respond immediately to an input condition
- Efficient sequence detection
- Can reduce state-register hardware
- Useful when low-latency output generation is required

---

# Limitations of Mealy FSMs

- Output depends directly on input
- Output can change between clock edges
- More susceptible to input-related glitches
- Output timing can be more difficult to analyze
- Requires careful handling when driving synchronous downstream logic

---

# Applications

Mealy FSMs are commonly used for:

- Sequence detectors
- Protocol controllers
- Communication interfaces
- Handshake logic
- UART control
- SPI control
- I2C control
- DMA control
- Bus controllers
- CPU control logic
- Packet processing
- Control sequencing

---

# Current Implementations

The Mealy folder currently contains two implementations of the `1001` sequence detector.

```text
Mealy/
│
├── ov1001.v
│   └── Overlapping 1001 detector
│
├── ov1001_tb.v
│   └── Testbench
│
├── ov_1001_n.v
│   └── Non-overlapping 1001 detector
│
└── ov_1001_n_tb.v
    └── Testbench
```

---

# Future Implementations

Possible future Mealy FSM implementations include:

- Generic parameterized sequence detector
- N-bit pattern detector
- UART transmitter FSM
- UART receiver FSM
- SPI controller
- I2C controller
- APB controller
- AXI control FSM
- DMA controller FSM
- FIFO control FSM
- Protocol decoder
- Handshake controller
- Error recovery FSM

---

# Key Takeaways

- A Mealy FSM output depends on:

```text
Output = f(Current State, Input)
```

- The current state is stored in flip-flops.
- Next-state logic is combinational.
- Output logic is also combinational.
- Mealy FSMs often require fewer states than Moore FSMs.
- Sequence detection can occur directly on the final input transition.
- The repository implements both overlapping and non-overlapping `1001` detection.
- In the overlapping detector, the post-detection state retains useful sequence information.
- In the non-overlapping detector, the FSM returns to the initial state after detection.
- The current implementations use an asynchronous active-low reset.
- Sequential logic uses non-blocking assignment `<=`.
- Combinational logic uses blocking assignment `=`.
- Mealy outputs can respond faster but require careful consideration of glitches and timing.
- Mealy FSMs are widely used in **sequence detection, protocol control, communication interfaces, and digital control systems**.
