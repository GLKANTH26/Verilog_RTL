# Finite State Machines (FSM)

This folder contains **Verilog RTL implementations of Finite State Machines (FSMs)**, including **Moore FSMs, Mealy FSMs, sequence detectors, and one-hot encoded FSMs**.

The implementations focus on understanding state-based control logic, state transitions, output generation, overlapping/non-overlapping sequence detection, and different state encoding techniques.

## Folder Structure

```text
Sequential_Circuits/
└── FSM/
    ├── Moore/
    │   ├── non_1001.v
    │   ├── non_1001_tb.v
    │   ├── ov_1001_2.v
    │   ├── ov_1001_2_tb.v
    │   └── README.md
    │
    ├── Mealy/
    │   ├── ov1001.v
    │   ├── ov1001_tb.v
    │   ├── ov_1001_n.v
    │   ├── ov_1001_n_tb.v
    │   └── README.md
    │
    ├── One_Hot/
    │   ├── onehot.v
    │   ├── onehot_tb.v
    │   └── README.md
    │
    └── README.md
```

## What Is an FSM?

A **Finite State Machine** is a sequential digital system that operates through a finite number of predefined states.

The next state depends on the:

```text
Current State
     +
   Input
     |
     v
Next-State Logic
     |
     v
Next State
```

The basic FSM consists of three major blocks:

```text
                    +-------------------+
          Input --->|                   |
                    |  Next-State Logic |
              +---->|                   |
              |     +---------+---------+
              |               |
              |               v
              |       +---------------+
              |       | State Register|
              |       +-------+-------+
              |               |
              |               v
              +--------- Current State
                              |
                              v
                       +-------------+
                       |Output Logic |
                       +------+------+
                              |
                              v
                           Output
```

## Main FSM Components

| Component | Purpose |
|---|---|
| State Register | Stores the current state |
| Next-State Logic | Determines the next state |
| Output Logic | Generates the FSM output |
| Clock | Controls state transitions |
| Reset | Initializes the FSM to a known state |
| Input | Influences state transitions |

The general relationship is:

```text
Next_State = f(Current_State, Input)
```

The output equation depends on the FSM type.

## Moore FSM

In a **Moore FSM**, the output depends only on the current state.

```text
Output = f(Current_State)
```

Therefore:

```text
Input ---> Next-State Logic ---> State Register
                                  |
                                  v
                            Current State
                                  |
                                  v
                             Output Logic
                                  |
                                  v
                               Output
```

The Moore implementations in this repository are **`1001` sequence detectors**.

### Implementations

```text
Moore/
├── non_1001.v
├── non_1001_tb.v
├── ov_1001_2.v
├── ov_1001_2_tb.v
└── README.md
```

They include:

- Non-overlapping `1001` sequence detector
- Overlapping `1001` sequence detector

A dedicated detection state is used to assert the output.

Detailed Moore FSM explanation, state transitions, and verification are documented in:

```text
Moore/README.md
```

## Mealy FSM

In a **Mealy FSM**, the output depends on both the current state and the input.

```text
Output = f(Current_State, Input)
```

Therefore:

```text
                 +-------------------+
Input ---------->|                   |
                 |  Next-State Logic |
Current State -->|                   |
                 +---------+---------+
                           |
                           v
                    State Register
                           |
                           v
                     Current State
                           |
                           +------------------+
                                              |
Input ----------------------------------------+
                                              v
                                      +---------------+
                                      | Output Logic  |
                                      +-------+-------+
                                              |
                                              v
                                           Output
```

The Mealy implementations in this repository detect the sequence `1001`.

### Implementations

```text
Mealy/
├── ov1001.v
├── ov1001_tb.v
├── ov_1001_n.v
├── ov_1001_n_tb.v
└── README.md
```

They include:

- Overlapping Mealy `1001` sequence detector
- Non-overlapping Mealy `1001` sequence detector

In the Mealy implementation, detection occurs on the transition corresponding to the final input bit.

Detailed Mealy FSM explanation, state transitions, output generation, and verification are documented in:

```text
Mealy/README.md
```

## Moore vs Mealy

| Feature | Moore | Mealy |
|---|---|---|
| Output depends on | Current state | Current state + input |
| Output equation | `Y = f(CS)` | `Y = f(CS, IN)` |
| Output changes | With state changes | Can change with input |
| Number of states | Usually more | Usually fewer |
| Detection output | Dedicated detection state | Can be generated during transition |
| Input-to-output combinational path | No direct path | Yes |
| Output stability | Generally higher | More sensitive to input changes |
| Typical use | Control-oriented FSMs | Fast response/control logic |

## Sequence Detection

A **sequence detector** identifies a predefined pattern in a serial input stream.

The sequence implemented in this repository is:

```text
1001
```

The FSM examines one input bit per clock cycle and maintains a state representing the portion of the sequence already matched.

For example:

```text
Input:
1 0 0 1

Progress:
1       -> First bit matched
10      -> First two bits matched
100     -> First three bits matched
1001    -> Complete sequence detected
```

## Overlapping Sequence Detection

In overlapping detection, bits from a previously detected sequence can also participate in the next sequence.

Example:

```text
Input:
1001001
```

The sequence `1001` occurs twice:

```text
1001
   1001
```

The final `1` of the first occurrence can become the first `1` of the next occurrence.

Therefore:

```text
1001001
```

produces:

```text
2 detections
```

The overlapping implementations preserve useful matching information after detection.

## Non-Overlapping Sequence Detection

In non-overlapping detection, the bits belonging to a completed sequence are not reused for another detection.

For example:

```text
Input:
1001001
```

The first:

```text
1001
```

is detected, and the FSM then starts a new search.

Therefore, the same input produces:

```text
1 detection
```

for a non-overlapping detector.

## Overlapping vs Non-Overlapping

| Feature | Overlapping | Non-Overlapping |
|---|---|---|
| Pattern | `1001` | `1001` |
| Reuses matched suffix | Yes | No |
| Shared bits allowed | Yes | No |
| `1001001` detections | 2 | 1 |
| Application | Continuous pattern streams | Independent pattern detection |

## State Representation

An FSM represents its operating condition using symbolic states.

For a sequence detector, the states generally represent how much of the target pattern has been matched.

For `1001`, the conceptual progress can be represented as:

```text
S0 → No match
S1 → 1 matched
S2 → 10 matched
S3 → 100 matched
S4 → 1001 detected
```

The exact state structure depends on the FSM implementation.

For example, a Moore detector generally requires a separate detection state, while a Mealy detector can assert the output during the transition corresponding to the final input bit.

## State Encoding

State encoding determines how symbolic states are represented using flip-flop bits.

Common encoding methods include:

- Binary encoding
- One-hot encoding
- Gray encoding

The repository currently includes a dedicated **One-Hot FSM** implementation.

## One-Hot FSM

In one-hot encoding, each state is represented by a separate flip-flop.

For four states:

```text
State   Encoding

S0      0001
S1      0010
S2      0100
S3      1000
```

Only one state bit is `1` at a time.

Therefore:

```text
Number of states = N
Number of state bits = N
```

For a binary encoded FSM:

```text
Number of state bits = ceil(log2(N))
```

### One-Hot Implementation

```text
One_Hot/
├── onehot.v
├── onehot_tb.v
└── README.md
```

The detailed implementation and explanation are provided in:

```text
One_Hot/README.md
```

## State Encoding Comparison

| Encoding | Flip-Flops | Decode Logic | Typical Advantage |
|---|---:|---|---|
| Binary | ceil(log2(N)) | Higher | Area efficient |
| One-Hot | N | Lower | Simple/faster state decoding |
| Gray | ceil(log2(N)) | Moderate | Reduced bit transitions |

The most appropriate encoding depends on the target technology, number of states, timing requirements, and synthesis strategy.

## FSM Coding Structure

The FSM implementations follow the standard RTL separation between sequential and combinational logic.

### State Register

```verilog
always @(posedge clk or negedge rst) begin
    if (!rst)
        cs <= INITIAL_STATE;
    else
        cs <= ns;
end
```

This block stores the current state.

### Next-State Logic

```verilog
always @(*) begin
    ns = INITIAL_STATE;

    case (cs)
        // State transitions
        ...
        default: begin
            ns = INITIAL_STATE;
        end
    endcase
end
```

This block determines the next state.

### Output Logic

For a Moore FSM:

```text
Output = f(Current_State)
```

For a Mealy FSM:

```text
Output = f(Current_State, Input)
```

Keeping these functions logically separated makes the RTL easier to understand, verify, and synthesize.

## Sequential and Combinational Logic

FSMs combine both types of digital logic.

### Sequential Logic

The state register is sequential logic.

```text
State_next is captured on the active clock edge.
```

### Combinational Logic

The following are generally combinational:

- Next-state logic
- Moore output decoding
- Mealy output logic

Therefore:

```text
Sequential:
State Register

Combinational:
Next-State Logic
Output Logic
```

## Reset

The FSM implementations use reset to place the machine into a known initial state.

The typical reset style used in these designs is:

```verilog
always @(posedge clk or negedge rst)
```

with:

```verilog
if (!rst)
    cs <= INITIAL_STATE;
```

This represents an:

```text
Asynchronous Active-Low Reset
```

Reset ensures that simulation and hardware do not begin from an unknown FSM state.

## Invalid-State Recovery

FSM implementations include a `default` transition to return the machine to a known state.

Conceptually:

```text
Invalid State
     |
     v
Initial State
```

This improves robustness against illegal or corrupted state encodings.

## Blocking vs Non-Blocking Assignments

The repository follows the standard RTL convention.

### Sequential Logic

Use:

```verilog
<=
```

for state registers.

Example:

```verilog
cs <= ns;
```

### Combinational Logic

Use:

```verilog
=
```

for combinational calculations.

Example:

```verilog
ns = S0;
```

This separation correctly models flip-flop behavior and combinational logic.

## FSM Timing

For a synchronous FSM:

```text
Input
  |
  v
Combinational Next-State Logic
  |
  v
State Register
  |
  v
Current State
```

The state register updates at the active clock edge.

The basic timing requirement follows the standard synchronous path:

```text
T_CLK ≥ t_CLK→Q + t_COMB + t_SETUP
```

where:

```text
t_CLK→Q = Clock-to-Q delay of state flip-flops
t_COMB  = Combinational logic delay
t_SETUP = Setup time of state flip-flops
```

For Mealy FSMs, the output can additionally have a combinational dependency on the input.

For Moore FSMs, the output depends only on the current state.

## Verification

Each FSM implementation has a corresponding testbench.

```text
Moore/
├── non_1001_tb.v
└── ov_1001_2_tb.v

Mealy/
├── ov1001_tb.v
└── ov_1001_n_tb.v

One_Hot/
└── onehot_tb.v
```

Verification should check:

- Reset behavior
- Correct initial state
- State transitions
- Correct sequence detection
- Overlapping behavior
- Non-overlapping behavior
- Invalid-state recovery
- Output timing
- Multiple occurrences of the target sequence

## Important Sequence Detector Test Cases

For the target sequence:

```text
1001
```

use test sequences such as:

| Input | Expected Overlapping Detections | Expected Non-Overlapping Detections |
|---|---:|---:|
| `1001` | 1 | 1 |
| `1001001` | 2 | 1 |
| `10011001` | 2 | 2 |
| `111000` | 0 | 0 |
| `1001001001` | 3 | 2 |

These cases verify both normal detection and suffix reuse behavior.

## Applications

FSMs are widely used in digital systems for:

- Control units
- Communication protocols
- Serial data processing
- Sequence detection
- Packet processing
- Bus controllers
- Memory controllers
- Peripheral controllers
- Arbitration logic
- Handshake controllers
- Error detection
- Embedded control systems

## Current Implementations

The FSM folder currently contains:

```text
Moore
├── Non-Overlapping 1001 Detector
└── Overlapping 1001 Detector

Mealy
├── Overlapping 1001 Detector
└── Non-Overlapping 1001 Detector

One-Hot
└── One-Hot Encoded FSM
```

These implementations cover the major concepts of:

```text
FSM Architecture
      ↓
State Representation
      ↓
Moore FSM
      ↓
Mealy FSM
      ↓
Sequence Detection
      ↓
Overlapping / Non-Overlapping Detection
      ↓
State Encoding
      ↓
One-Hot FSM
```

## Future Implementations

Possible extensions to this FSM section include:

- Parameterized sequence detector
- Multiple-pattern sequence detector
- Traffic-light controller
- Vending-machine FSM
- UART controller FSM
- AXI/APB protocol control FSMs
- FIFO control FSM
- Bus arbitration FSM
- Gray-encoded FSM
- Binary vs one-hot synthesis comparison
- SystemVerilog `enum`-based FSM coding
- FSM assertions and functional coverage
- Formal verification of state transitions

## Key Takeaways

- An FSM is a sequential control structure consisting of **state registers, next-state logic, and output logic**.
- **Moore FSM:** output depends only on the current state.
- **Mealy FSM:** output depends on the current state and input.
- Sequence detectors can be designed as **overlapping** or **non-overlapping** machines.
- Overlapping detectors preserve useful suffix information after a successful match.
- Non-overlapping detectors restart the search after a completed match.
- One-hot encoding uses one flip-flop per state and simplifies state decoding.
- Proper separation of sequential and combinational RTL is essential for synthesizable FSM design.
- Reset and invalid-state recovery ensure deterministic FSM behavior.
- The implementations in this folder provide the foundation for larger RTL control systems such as protocol controllers, arbiters, and processor peripherals.
