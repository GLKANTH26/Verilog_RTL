# Moore Finite State Machines (FSMs)

This folder contains Verilog RTL implementations of Moore Finite State Machines designed to detect the binary sequence `1001`.

Two sequence detection approaches are implemented:

- Non-Overlapping Moore Sequence Detector
- Overlapping Moore Sequence Detector

Both designs use synchronous state transitions, asynchronous active-low reset, and state-dependent output generation.

## Folder Structure

```
Moore/
├── non_1001.v
├── non_1001_tb.v
├── ov_1001_2.v
├── ov_1001_2_tb.v
└── README.md
```

| File             | Description                                        |
| ---------------- | -------------------------------------------------- |
| `non_1001.v`     | Non-overlapping Moore sequence detector for `1001` |
| `non_1001_tb.v`  | Testbench for non-overlapping detection            |
| `ov_1001_2.v`    | Overlapping Moore sequence detector for `1001`     |
| `ov_1001_2_tb.v` | Testbench for overlapping detection                |
| `README.md`      | Documentation for Moore FSM implementations        |

## What Is a Moore FSM?

A Moore Finite State Machine is a sequential circuit in which the output depends only on the current state.

```
Output = f(Current_State)

Next_State = f(Current_State, Input)
```

The input determines the next state, while the current state determines the output.

### Moore FSM Architecture

```
                  +-------------------+
       Input ---->|                   |
                  |  Next-State Logic |----+
       +--------->|                   |    |
       |          +-------------------+    |
       |                                   v
       |                           +---------------+
       |                           | State Register|
       |                           |  (Flip-Flops) |
       |                           +---------------+
       |                                   |
       |                                   +---- Current State
       |                                   |
       |          +-------------------+    |
       +----------|                   |<---+
                  |   Output Logic    |
                  +-------------------+
                           |
                           v
                         Output
```

A Moore FSM consists of three main blocks:

| Block            | Function                                                   |
| ---------------- | ---------------------------------------------------------- |
| State Register   | Stores the current state                                   |
| Next-State Logic | Determines the next state from the current state and input |
| Output Logic     | Generates output based only on the current state           |

## Why Use a Moore FSM?

Moore FSMs are useful when outputs must remain stable between state transitions.

Advantages:

- Outputs depend only on registered states.
- Easier output timing analysis.
- Less susceptible to direct input glitches.
- Clear separation between state transitions and output decoding.
- Suitable for control-oriented RTL designs.

Limitation:

A Moore FSM generally requires an additional state to indicate successful sequence detection compared with an equivalent Mealy FSM.

## Moore vs Mealy FSM

| Feature                            | Moore FSM          | Mealy FSM                     |
| ---------------------------------- | ------------------ | ----------------------------- |
| Output dependency                  | Current state      | Current state and input       |
| Output equation                    | `Y = f(CS)`        | `Y = f(CS, IN)`               |
| Output changes                     | With state changes | Can change with input changes |
| Sequence detector states           | Usually more       | Usually fewer                 |
| Input-to-output combinational path | Absent             | Present                       |
| Output behavior                    | More stable        | Faster response possible      |
| Implemented here                   | Yes                | In the `Mealy/` folder        |

## Sequence Detection

A sequence detector continuously examines a serial binary input and identifies a predefined bit pattern.

The target sequence for both designs is:

```
1001
```

Each incoming bit is sampled on the active clock edge.

The FSM tracks the portion of the sequence matched so far.

For a Moore detector, successful detection is represented by entering a dedicated detection state.

## State Representation

A typical Moore sequence detector for `1001` uses five logical states.

| State | Meaning                           |
| ----- | --------------------------------- |
| `S0`  | No matching bits detected         |
| `S1`  | `1` matched                       |
| `S2`  | `10` matched                      |
| `S3`  | `100` matched                     |
| `S4`  | Complete sequence `1001` detected |

The detection output is:

```
det = 1 when Current_State = S4

det = 0 for all other states
```

With five states, a binary-encoded implementation requires at least three state bits.

```
State_Bits = ceil(log2(Number_of_States))

State_Bits = ceil(log2(5)) = 3
```

## Non-Overlapping Moore Sequence Detector

RTL File: `non_1001.v`

Testbench: `non_1001_tb.v`

### What Is Non-Overlapping Detection?

In non-overlapping detection, bits belonging to a successfully detected sequence cannot be reused as part of the next detection.

For the sequence `1001`, after a complete match, the FSM begins searching for a new sequence without reusing the final `1`.

### Example

```
Input Sequence:

1 0 0 1 1 0 0 1
|-----| |-----|
 1001    1001

Detection Count = 2
```

Each occurrence uses a separate set of four input bits.

### State Transitions

The following table describes a standard non-overlapping Moore detector.

| Current State | Input = 0 | Input = 1 | `det` |
| ------------- | --------- | --------- | ----- |
| `S0`          | `S0`      | `S1`      | 0     |
| `S1`          | `S2`      | `S1`      | 0     |
| `S2`          | `S3`      | `S1`      | 0     |
| `S3`          | `S0`      | `S4`      | 0     |
| `S4`          | `S0`      | `S1`      | 1     |

The detection state `S4` produces `det = 1`.

From `S4`, the next incoming input bit is treated as the start of a fresh search.

### Detection Flow

```
S0 --1--> S1 --0--> S2 --0--> S3 --1--> S4
                                          |
                                        det=1
```

### Important Characteristics

- Detects `1001`.
- Does not reuse bits from a completed match.
- Uses a dedicated detection state.
- Detection output depends only on the state.
- Suitable when each sequence occurrence must be independent.

## Overlapping Moore Sequence Detector

RTL File: `ov_1001_2.v`

Testbench: `ov_1001_2_tb.v`

### What Is Overlapping Detection?

In overlapping detection, the ending bits of a detected sequence may also form the beginning of the next sequence.

For `1001`, the last bit is `1`, which also matches the first bit of the sequence.

Therefore, after detection, the FSM can preserve this partial match.

### Example

```
Input Sequence:

1 0 0 1 0 0 1
|-----|
      |-----|
 1001   1001

Detection Count = 2
```

The two occurrences share the `1` at the fourth input position.

### State Transitions

The following table describes a standard overlapping Moore detector.

| Current State | Input = 0 | Input = 1 | `det` |
| ------------- | --------- | --------- | ----- |
| `S0`          | `S0`      | `S1`      | 0     |
| `S1`          | `S2`      | `S1`      | 0     |
| `S2`          | `S3`      | `S1`      | 0     |
| `S3`          | `S0`      | `S4`      | 0     |
| `S4`          | `S2`      | `S1`      | 1     |

### Why Does `S4` Transition to `S2` on Input `0`?

After detecting:

```
1001
```

The final `1` can be reused as the first bit of the next sequence.

If the next input is `0`, the effective matched suffix becomes:

```
10
```

Therefore:

```
S4 --0--> S2
```

If the next input is `1`, the newest matching suffix is:

```
1
```

Therefore:

```
S4 --1--> S1
```

This allows overlapping occurrences to be detected.

### Detection Flow

```
S0 --1--> S1 --0--> S2 --0--> S3 --1--> S4
                                          |
                                        det=1
                                          |
                                 +--------+--------+
                                 |                 |
                              Input=0           Input=1
                                 |                 |
                                 v                 v
                                S2                S1
```

### Important Characteristics

- Detects `1001`.
- Reuses valid suffix bits after successful detection.
- Supports overlapping occurrences.
- Uses a dedicated detection state.
- Avoids unnecessarily restarting the entire search.

## Overlapping vs Non-Overlapping Detection

| Feature                           | Non-Overlapping               | Overlapping                           |
| --------------------------------- | ----------------------------- | ------------------------------------- |
| Target sequence                   | `1001`                        | `1001`                                |
| Reuses matched bits               | No                            | Yes                                   |
| Dedicated detection state         | Yes                           | Yes                                   |
| Detection output                  | State-dependent               | State-dependent                       |
| Detection of `1001001`            | 1 occurrence                  | 2 occurrences                         |
| Detection-state transition on `0` | `S0`                          | `S2`                                  |
| Detection-state transition on `1` | `S1`                          | `S1`                                  |
| Main application                  | Independent pattern detection | Continuous stream pattern recognition |

## State Register

The state register stores the current FSM state.

A typical implementation is:

```
always @(posedge clk or negedge rst) begin
    if (!rst)
        cs <= S0;
    else
        cs <= ns;
end
```

### Operation

- `posedge clk`: Updates the current state on the rising clock edge.
- `negedge rst`: Supports asynchronous active-low reset.
- `cs`: Current state.
- `ns`: Next state.
- `<=`: Non-blocking assignment for sequential logic.

When reset is asserted:

```
rst = 0
cs  = S0
det = 0
```

## Next-State Logic

Next-state logic determines the state to be entered on the next clock edge.

```
Next_State = f(Current_State, Input)
```

A typical combinational implementation is:

```
always @(*) begin
    ns = S0;

    case (cs)
        // State transition conditions
    endcase
end
```

The next-state logic must account for every valid state and input combination.

### Why Use `always @(*)`?

- Automatically includes signals read by the combinational logic in the sensitivity list.
- Supports simulation of combinational behavior.
- Avoids manually maintaining sensitivity lists.

### Why Assign a Default Next State?

```
ns = S0;
```

This provides a defined value if no other transition overrides it.

It helps avoid unintended latch inference.

## Output Logic

The defining characteristic of a Moore FSM is that the output depends only on the current state.

```
always @(*) begin
    case (cs)
        S4: det = 1'b1;
        default: det = 1'b0;
    endcase
end
```

The output is asserted only while the FSM occupies the detection state.

```
Current_State = S4  --> det = 1

Current_State != S4 --> det = 0
```

Unlike a Mealy FSM, the output does not directly depend on `in`.

## Output Timing

Consider the input sequence:

```
1 0 0 1
```

The FSM progresses as follows:

| Clock Edge | Input Sampled | State After Edge | `det`                 |
| ---------- | ------------- | ---------------- | --------------------- |
| Reset      | —             | `S0`             | 0                     |
| 1          | 1             | `S1`             | 0                     |
| 2          | 0             | `S2`             | 0                     |
| 3          | 0             | `S3`             | 0                     |
| 4          | 1             | `S4`             | 1                     |
| 5          | Next bit      | Next state       | Depends on next state |

The detection output becomes high after the clock edge that captures the final `1` and updates the state to `S4`.

This is an important difference from a combinational Mealy detection output, which can respond to the final input before that clock edge.

## Testbench Verification

### Non-Overlapping Testbench

File: `non_1001_tb.v`

Verification should confirm that:

- The FSM starts in the reset state.
- The sequence `1001` is detected.
- The output is asserted in the detection state.
- Previously consumed bits are not reused.
- Multiple independent occurrences are detected.
- Incorrect input sequences do not generate false detections.

### Overlapping Testbench

File: `ov_1001_2_tb.v`

Verification should confirm that:

- The FSM detects the first `1001`.
- A shared suffix is retained after detection.
- The sequence `1001001` produces two detections.
- Back-to-back and partially matching input sequences are handled.
- Reset returns the FSM to its initial state.

### Recommended Test Sequences

| Input Sequence | Non-Overlapping Detections | Overlapping Detections |
| -------------- | -------------------------- | ---------------------- |
| `1001`         | 1                          | 1                      |
| `1001001`      | 1                          | 2                      |
| `10011001`     | 2                          | 2                      |
| `111000`       | 0                          | 0                      |
| `1001001001`   | 2                          | 3                      |

These are useful expected results for a self-checking testbench.

## Simulation and Waveform Analysis

Important signals to observe:

| Signal | Description               |
| ------ | ------------------------- |
| `clk`  | Clock signal              |
| `rst`  | Active-low reset          |
| `in`   | Serial input bit          |
| `cs`   | Current FSM state         |
| `ns`   | Next FSM state            |
| `det`  | Sequence detection output |

For the overlapping sequence `1001001`, the waveform should show two visits to the detection state.

For the non-overlapping implementation, the same input sequence should produce only one detection.

## RTL Coding Practices

The following practices are recommended for Moore FSM implementations:

- Use non-blocking assignments (`<=`) for sequential state registers.
- Use blocking assignments (`=`) for combinational next-state and output logic.
- Provide default assignments in combinational blocks.
- Include a `default` case for invalid state recovery.
- Use symbolic state parameters instead of hardcoded state values throughout the logic.
- Keep output decoding dependent only on the current state.
- Apply reset consistently across the design.
- Drive testbench inputs away from the sampling clock edge to avoid simulation races.

## Applications

Moore FSM sequence detectors are used in:

- Serial communication pattern detection.
- Packet header and delimiter recognition.
- Protocol control logic.
- Digital control systems.
- Synchronization pattern detection.
- Embedded hardware controllers.
- RTL design and verification exercises.

## Future Improvements

Potential extensions include:

- Parameterized sequence detection.
- Detection of multiple binary patterns.
- Self-checking testbenches with automatic pass/fail reporting.
- State transition coverage.
- Assertions for reset and detection behavior.
- FSM synthesis and state encoding comparison.
- Formal verification of overlapping and non-overlapping behavior.

## Key Takeaways

- A Moore FSM generates outputs based only on its current state.
- Both implemented detectors recognize the binary sequence `1001`.
- Non-overlapping detection does not reuse bits from a completed match.
- Overlapping detection preserves matching suffix bits for subsequent detection.
- Both implementations require a dedicated detection state.
- The detection output is asserted after the FSM enters that state.
- Moore FSMs provide predictable, state-dependent outputs and are widely used in digital control logic.
