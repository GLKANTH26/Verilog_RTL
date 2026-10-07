# One-Hot Encoded FSM

This folder contains a **One-Hot encoded Finite State Machine (FSM)** implementation in Verilog RTL.

The design demonstrates how FSM states can be represented using **one flip-flop per state**, with exactly one state bit asserted at a time.

## Folder Structure

```text
One_Hot/
├── onehot.v
├── onehot_tb.v
└── README.md
```

| File | Description |
|---|---|
| `onehot.v` | One-Hot encoded FSM RTL |
| `onehot_tb.v` | Testbench for the One-Hot FSM |
| `README.md` | Documentation for the implementation |

## What Is One-Hot Encoding?

In One-Hot encoding, **each FSM state is represented by one dedicated flip-flop**.

For an FSM with four states:

```text
State    One-Hot Encoding

S0       0001
S1       0010
S2       0100
S3       1000
```

Only **one bit is `1` at any given time**.

```text
Number of States = N
Number of State Bits = N
```

This is different from binary state encoding, where multiple states are represented using the minimum number of bits.

## Binary vs One-Hot Encoding

For `N` states:

```text
Binary:

Number of bits = ceil(log2(N))

One-Hot:

Number of bits = N
```

For example, for 8 states:

```text
Binary:
8 states → 3 bits

One-Hot:
8 states → 8 bits
```

Therefore, One-Hot encoding uses more flip-flops but can simplify the combinational logic required for state decoding.

## One-Hot FSM Structure

```text
                 Input
                   |
                   v
          +-------------------+
          | Next-State Logic  |
          +---------+---------+
                    |
                    v
          +-------------------+
          | State Registers   |
          |                   |
          | S0 S1 S2 S3 ...   |
          +---------+---------+
                    |
                    v
             One-Hot State
                    |
                    v
          +-------------------+
          |   Output Logic    |
          +-------------------+
                    |
                    v
                 Output
```

Each state is directly represented by a state bit.

## State Representation

Consider a four-state FSM:

```text
S0 = 0001
S1 = 0010
S2 = 0100
S3 = 1000
```

The state transitions can be represented as:

```text
S0 → S1 → S2 → S3 → S0
```

The corresponding state register contents become:

```text
0001 → 0010 → 0100 → 1000 → 0001
```

At every valid point:

```text
Number of 1s = 1
```

## Why Use One-Hot Encoding?

One-Hot encoding is particularly useful when the number of FSM states is relatively small and fast state decoding is important.

### Advantages

- Simple state representation.
- Simple state decoding.
- Often reduces combinational logic depth.
- Can provide good timing performance on FPGA architectures.
- Each state has a directly identifiable state bit.
- Easier to inspect in simulation waveforms.
- State transition logic can be straightforward.

### Limitations

- Requires one flip-flop per state.
- Uses more sequential resources as the number of states increases.
- May not be area-efficient for very large FSMs.
- Illegal states can occur if more than one state bit becomes `1` or all bits become `0`.

## One-Hot State Validity

For a valid One-Hot FSM:

```text
Exactly one state bit must be 1
```

For four states:

```text
0001 → Valid
0010 → Valid
0100 → Valid
1000 → Valid
```

Examples of invalid states:

```text
0000 → No state active

0011 → Two states active

1010 → Two states active

1111 → Multiple states active
```

Therefore, robust One-Hot FSM implementations should consider invalid-state recovery.

## State Register

The state register stores the current One-Hot state.

A typical sequential structure is:

```verilog
always @(posedge clk or negedge rst) begin
    if (!rst)
        state <= INITIAL_STATE;
    else
        state <= next_state;
end
```

The state changes only on the active clock edge.

```text
posedge clk
     |
     v
State Register
     |
     v
Current One-Hot State
```

The reset places the FSM into a known valid One-Hot state.

## Next-State Logic

The next-state logic determines which state bit should become active during the next clock cycle.

Conceptually:

```text
Current State + Input
          |
          v
   Next-State Logic
          |
          v
     Next State
```

For example:

```text
Current State = 0001
Input         = 1

Next State    = 0010
```

After the next clock edge:

```text
0001 → 0010
```

## State Transition Example

For a four-state cyclic FSM:

```text
        Input condition
              |
              v
        +-----------+
        |           |
        v           |
      S0 → S1 → S2 → S3
       ^              |
       |______________|
```

One-Hot representation:

```text
0001 → 0010 → 0100 → 1000
  ↑                    |
  |____________________|
```

The state register therefore directly indicates which state is active.

## One-Hot Output Decoding

One of the major benefits of One-Hot encoding is simple state decoding.

For example, if `S2` is represented as:

```text
0100
```

then the output associated with `S2` can simply depend on that state bit.

Conceptually:

```text
Output = state[S2]
```

instead of requiring a binary comparison such as:

```text
state == 2'b10
```

This can simplify the combinational logic.

## One-Hot vs Binary FSM

| Feature | Binary Encoding | One-Hot Encoding |
|---|---:|---:|
| State bits | ceil(log2(N)) | N |
| Flip-flops | Fewer | More |
| State decoding | More logic | Simpler |
| Area for small FSM | Usually lower | Usually higher |
| Timing | Depends on logic | Often favorable |
| Debugging | Requires decoding | Direct state visibility |
| FPGA suitability | Good | Often very good |
| Large FSM suitability | Generally better | Can become expensive |

The best encoding depends on the target implementation technology and design constraints.

## Reset

The FSM uses reset to initialize the state register.

The reset establishes a known One-Hot state:

```text
Reset
  |
  v
Initial State
  |
  v
0001
```

The initial state must contain exactly one asserted bit.

For example:

```text
Initial State = 0001
```

is valid, whereas:

```text
Initial State = 0000
```

would leave the FSM with no active state.

## Invalid-State Recovery

A robust One-Hot FSM should account for illegal states.

Examples:

```text
0000
0011
0101
1111
```

A recovery mechanism can return the FSM to the initial state:

```text
Invalid State
     |
     v
Initial State
```

This prevents the FSM from remaining permanently stuck in an illegal encoding.

## RTL Coding Practices

The implementation follows standard synthesizable RTL practices:

- Use `always @(posedge clk or negedge rst)` for sequential state storage.
- Use non-blocking assignments (`<=`) in sequential logic.
- Use combinational logic for next-state generation.
- Provide default values in combinational blocks.
- Include a `default` case for invalid-state recovery.
- Keep state transitions synchronized to the clock.
- Use meaningful state names instead of unexplained binary values.

## Timing Considerations

The basic synchronous FSM timing requirement is:

```text
T_CLK ≥ t_CLK→Q + t_COMB + t_SETUP
```

where:

```text
t_CLK→Q = Clock-to-Q delay of state flip-flops
t_COMB  = Next-state combinational logic delay
t_SETUP = Setup time of destination flip-flops
```

One-Hot encoding can reduce the amount of state decoding logic and may therefore help reduce `t_COMB` in suitable designs.

However, the actual timing improvement depends on:

- Synthesis tool
- Target technology
- Number of states
- Logic structure
- Fanout
- Placement and routing
- Timing constraints

## Verification

The testbench:

```text
onehot_tb.v
```

is used to verify the FSM behavior.

Important signals to observe in simulation include:

| Signal | Purpose |
|---|---|
| `clk` | FSM clock |
| `rst` | Reset |
| `input` | FSM input |
| `state` | Current One-Hot state |
| `next_state` | Next state |
| `output` | FSM output |

The waveform should show only one active state bit during normal operation.

For example:

```text
Clock Cycle     State

1               0001
2               0010
3               0100
4               1000
5               0001
```

## Verification Checks

The testbench should verify:

- Correct reset state.
- Correct state transitions.
- Exactly one state bit active.
- Correct response to each input condition.
- Correct output generation.
- Proper recovery from invalid states if implemented.
- No unintended state transitions between clock edges.

A useful One-Hot validity condition is:

```text
Number of active state bits = 1
```

Conceptually:

```text
$onehot(state)
```

can be used in SystemVerilog-based verification to check this property.

## Applications

One-Hot FSMs are commonly used in:

- FPGA control logic
- Protocol controllers
- Bus controllers
- Communication interfaces
- Arbitration logic
- Peripheral controllers
- Memory controllers
- Pipeline control
- Instruction/control sequencing
- Hardware state machines

## Current Implementation

The `One_Hot/` folder currently contains:

```text
One_Hot/
├── onehot.v
├── onehot_tb.v
└── README.md
```

The implementation demonstrates:

```text
FSM
 ↓
State Encoding
 ↓
One-Hot Representation
 ↓
State Transition Logic
 ↓
State Register
 ↓
Output Generation
```

## Future Improvements

Possible extensions include:

- SystemVerilog `enum`-based One-Hot states.
- Parameterized number of states.
- Explicit invalid-state recovery.
- `$onehot()` assertions.
- Functional coverage.
- Binary vs One-Hot synthesis comparison.
- Area comparison.
- Timing comparison.
- Power comparison.
- FPGA resource utilization comparison.
- Larger protocol-controller FSMs.

## Key Takeaways

- One-Hot encoding uses **one flip-flop per FSM state**.
- Only **one state bit should be `1` at a time**.
- One-Hot encoding uses more flip-flops than binary encoding.
- State decoding is generally simpler.
- One-Hot FSMs can provide timing advantages when reduced decode logic is beneficial.
- They are particularly attractive for many FPGA-based FSM implementations.
- Invalid states such as `0000` or multi-hot values should be considered in robust designs.
- Proper reset and invalid-state recovery are important for deterministic operation.
- The choice between **Binary, One-Hot, and other state encodings** should be based on the target technology, timing, area, and power requirements.
