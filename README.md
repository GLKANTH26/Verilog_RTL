# Verilog_RTL

A structured collection of **Verilog RTL implementations for fundamental digital logic and sequential circuit design**.

This repository is focused on building a strong foundation in **digital logic, Verilog RTL coding, simulation, and hardware-oriented design thinking**, progressing from basic gates and combinational circuits to sequential logic and finite state machines.

The repository is intentionally focused on **fundamental RTL implementations**. Larger standalone RTL projects such as ALUs, FIFOs, DMA controllers, UARTs, processors, and SoC components are maintained separately.

---

## Repository Scope

The learning progression followed in this repository is:

```text
Basic Digital Logic
        ↓
Combinational Circuits
        ↓
Sequential Circuits
        ↓
Latches
        ↓
Flip-Flops
        ↓
Registers
        ↓
Counters
        ↓
Finite State Machines
```

The repository ends at **FSMs** as the current fundamental RTL learning scope.

---

## Repository Structure

```text
Verilog_RTL/
│
├── Combinational_Circuits/
│   ├── Adders/
│   ├── Subtractors/
│   ├── Multiplexers/
│   ├── DeMultiplexers/
│   ├── Decoders/
│   └── Encoders/
│
├── Sequential_Circuits/
│   ├── Latches/
│   ├── Flip_Flops/
│   ├── Registers/
│   ├── Counters/
│   │   ├── Asynchronous/
│   │   └── Synchronous/
│   │
│   └── FSM/
│       ├── Moore/
│       ├── Mealy/
│       ├── One_Hot/
│       └── README.md
│
└── README.md
```

Each topic is kept in a dedicated directory to make the repository easy to navigate, study, simulate, and extend.

---

## Basic Digital Logic

The repository begins with fundamental digital logic building blocks.

These implementations establish the basic relationship between:

```text
Inputs
   ↓
Logic Function
   ↓
Output
```

The fundamental concepts include:

- Logic gates
- Boolean operations
- Truth tables
- Combinational logic
- Basic Verilog module structure
- Module instantiation
- Testbench-based verification

These concepts form the foundation for the larger combinational and sequential circuits in the repository.

---

## Combinational Circuits

The `Combinational_Circuits/` directory contains circuits whose outputs depend only on their present inputs.

```text
Combinational_Circuits/
├── Adders/
├── Subtractors/
├── Multiplexers/
├── DeMultiplexers/
├── Decoders/
└── Encoders/
```

### Covered Designs

- Adders
- Subtractors
- Multiplexers
- Demultiplexers
- Decoders
- Encoders

The designs demonstrate:

- Boolean logic implementation
- Arithmetic logic
- Selection logic
- Data routing
- Encoding and decoding
- Hierarchical module usage
- Combinational RTL coding

---

## Sequential Circuits

The `Sequential_Circuits/` directory introduces circuits that contain **state or storage**.

```text
Sequential_Circuits/
├── Latches/
├── Flip_Flops/
├── Registers/
├── Counters/
└── FSM/
```

Unlike combinational circuits, sequential circuits depend on previous state in addition to current inputs.

```text
Current Inputs
      +
Previous State
      ↓
Sequential Logic
      ↓
Next State / Output
```

The sequential section progresses from basic storage elements to structured control logic.

---

## Latches

The `Latches/` directory introduces **level-sensitive storage elements**.

```text
Latches/
├── sr.v
├── sr_tb.v
└── README.md
```

The implementation covers concepts such as:

- SR latch
- Set operation
- Reset operation
- Hold condition
- Invalid condition
- Level-sensitive storage
- Latch verification

---

## Flip-Flops

The `Flip_Flops/` directory contains common edge-triggered storage elements.

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

### Covered Designs

- SR flip-flop
- JK flip-flop
- D flip-flop
- T flip-flop

The designs introduce:

- Clocked storage
- Edge-triggered operation
- Reset behavior
- Characteristic behavior
- Flip-flop-based sequential logic

---

## Registers

The `Registers/` directory demonstrates how flip-flops can be combined to store and shift multiple bits.

```text
Registers/
├── n_bit_r.v
├── n_bit_r_tb.v
├── pipo.v
├── pipo_tb.v
├── piso.v
├── piso_tb.v
├── sipo.v
├── sipo_tb.v
├── siso.v
├── siso_tb.v
└── README.md
```

### Covered Designs

- N-bit register
- PIPO
- PISO
- SIPO
- SISO
- Shift-register based data movement

These implementations demonstrate parallel and serial data storage and transfer.

---

## Counters

The `Counters/` directory contains both asynchronous and synchronous counter designs.

```text
Counters/
├── Asynchronous/
│   ├── rc_2.v
│   ├── rc_3.v
│   ├── rc_4.v
│   ├── ripple_counter.v
│   ├── truncate.v
│   └── README.md
│
└── Synchronous/
    ├── ring.v
    ├── ring_tb.v
    ├── twisted.v
    ├── twisted_tb.v
    └── README.md
```

### Asynchronous Counters

The asynchronous section covers:

- Ripple counters
- Multi-bit asynchronous counters
- Frequency division
- Truncated counters
- Propagation-delay effects

For an N-bit binary counter:

```text
MOD = 2^N
```

The frequency division behavior follows:

```text
Q0 = f_CLK / 2
Q1 = f_CLK / 4
Q2 = f_CLK / 8
...
```

### Synchronous Counters

The synchronous section covers:

- Ring counter
- Johnson / twisted-ring counter
- Enable-controlled state transitions

For a ring counter:

```text
MOD = N
```

For a Johnson counter:

```text
MOD = 2N
```

The counter implementations also demonstrate the difference between **common-clock synchronous designs** and **ripple-based asynchronous designs**.

---

## Finite State Machines

The `FSM/` directory introduces structured sequential control logic.

```text
FSM/
├── Moore/
├── Mealy/
├── One_Hot/
└── README.md
```

The FSM section covers:

- Moore FSMs
- Mealy FSMs
- Sequence detection
- Overlapping sequence detection
- Non-overlapping sequence detection
- One-Hot state encoding

The implemented sequence detectors use:

```text
1001
```

as the target sequence.

### Moore FSM

```text
Moore/
├── non_1001.v
├── non_1001_tb.v
├── ov_1001_2.v
├── ov_1001_2_tb.v
└── README.md
```

Includes:

- Non-overlapping `1001` sequence detector
- Overlapping `1001` sequence detector

For a Moore FSM:

```text
Output = f(Current_State)
```

The output is determined only by the current state.

### Mealy FSM

```text
Mealy/
├── ov1001.v
├── ov1001_tb.v
├── ov_1001_n.v
├── ov_1001_n_tb.v
└── README.md
```

Includes:

- Overlapping `1001` sequence detector
- Non-overlapping `1001` sequence detector

For a Mealy FSM:

```text
Output = f(Current_State, Input)
```

The output can therefore depend directly on the current input.

### One-Hot FSM

```text
One_Hot/
├── onehot.v
├── onehot_tb.v
└── README.md
```

The One-Hot implementation demonstrates state encoding in which each state has a dedicated state bit.

Example:

```text
S0 = 0001
S1 = 0010
S2 = 0100
S3 = 1000
```

Detailed explanations are provided in the corresponding topic-level README files.

---

## Moore vs Mealy

| Feature | Moore | Mealy |
|---|---|---|
| Output depends on | Current state | Current state + input |
| Output equation | `Y = f(CS)` | `Y = f(CS, IN)` |
| Output changes | With state changes | Can change with input |
| Number of states | Usually more | Usually fewer |
| Direct input-to-output path | No | Yes |
| Output stability | Generally higher | More input-sensitive |
| Detection style | Dedicated detection state | Can detect during transition |

---

## Overlapping vs Non-Overlapping Detection

The sequence detectors demonstrate both approaches.

### Overlapping

Previously matched bits can participate in the next detection.

```text
Input:

1001001

Patterns:

1001
   1001
```

This produces:

```text
2 detections
```

### Non-Overlapping

Bits belonging to a completed sequence are not reused.

```text
Input:

1001001

First complete sequence:

1001
```

The FSM then begins a new search.

This produces:

```text
1 detection
```

---

## RTL and Testbench Organization

Design files and testbenches are kept separate.

The general convention is:

```text
design.v
design_tb.v
```

For example:

```text
ring.v
ring_tb.v
```

The RTL file contains the design under test.

The testbench contains:

- Clock generation
- Reset generation
- Input stimulus
- Monitoring
- Waveform dumping
- Simulation termination

This separation keeps the RTL focused on hardware implementation while keeping verification code independent.

---

## How to Use This Repository

The repository can be used progressively.

### Start With the Basics

Begin with:

```text
Combinational_Circuits/
```

Study the RTL and corresponding testbenches.

Then move to:

```text
Sequential_Circuits/
```

and progress through:

```text
Latches
   ↓
Flip_Flops
   ↓
Registers
   ↓
Counters
   ↓
FSMs
```

### For Each Design

Follow this process:

```text
Read README
    ↓
Understand the Circuit
    ↓
Read RTL
    ↓
Read Testbench
    ↓
Compile
    ↓
Simulate
    ↓
Analyze Waveform
    ↓
Verify Expected Behavior
```

---

## Simulation

The RTL can be simulated using different Verilog/SystemVerilog simulators.

Examples include:

- Icarus Verilog
- Verilator
- ModelSim / Questa
- Synopsys VCS
- Xilinx Vivado

The exact command depends on the simulator.

### Example Using Icarus Verilog

```bash
iverilog -o sim design.v design_tb.v
vvp sim
```

If a VCD waveform is generated:

```bash
gtkwave dump.vcd
```

---

## General Simulation Flow

```text
RTL
 ↓
Testbench
 ↓
Compilation
 ↓
Elaboration
 ↓
Simulation
 ↓
Console Output
 ↓
Waveform Analysis
```

For sequential designs, waveform analysis should particularly verify:

```text
Clock
Reset
Inputs
Outputs
Registers
State
Next State
Flags
```

---

## Hardware-Oriented RTL Thinking

Verilog should be treated as a **hardware description language**, not as a conventional software programming language.

For example:

```verilog
assign y = a & b;
```

represents combinational AND hardware.

Similarly:

```verilog
always @(posedge clk)
    q <= d;
```

represents clocked storage.

Therefore, every RTL statement should be understood in terms of the hardware it describes.

```text
Verilog RTL
    ↓
Hardware Structure
    ↓
Simulation
    ↓
Synthesis
```

---

## Synthesizable RTL Guidelines

Unless a file is explicitly a testbench, RTL should describe synthesizable hardware.

### Sequential Logic

Use non-blocking assignments:

```verilog
always @(posedge clk) begin
    q <= d;
end
```

### Combinational Logic

Use blocking assignments:

```verilog
always @(*) begin
    y = a & b;
end
```

### Combinational Completeness

All outputs of a combinational block should receive defined values for every possible execution path.

This avoids unintended latch inference.

### Simulation-Only Constructs

The following are generally intended for testbenches rather than synthesizable RTL:

```text
#delay
$display
$monitor
$finish
```

---

## Reset Guidelines

Reset behavior should always be clearly defined for sequential designs.

The repository contains designs using asynchronous reset styles such as:

```verilog
always @(posedge clk or negedge rst)
```

with:

```verilog
if (!rst)
```

representing an **asynchronous active-low reset**.

Future designs should clearly document:

- Reset polarity
- Synchronous or asynchronous reset
- Initial/reset state
- Reset behavior of outputs and registers

---

## Parameterization

Parameterization should be used where it provides useful reuse.

Example:

```verilog
module register #(parameter N = 8) (
    input clk,
    input rst,
    input [N-1:0] d,
    output reg [N-1:0] q
);
```

This allows the same design structure to support different widths.

However, simple educational circuits should not be unnecessarily complicated just to make them parameterized.

The priority is:

```text
Correctness
    ↓
Clarity
    ↓
Reusability
```

---

## Naming Conventions

Use descriptive and consistent names.

| Item | Recommended Convention | Example |
|---|---|---|
| Module | Descriptive name | `ripple_counter` |
| Testbench | `<design>_tb` | `ripple_counter_tb` |
| Clock | `clk` | `clk` |
| Reset | `rst` / `rst_n` | `rst_n` |
| Input | Descriptive | `data_in` |
| Output | Descriptive | `data_out` |
| Current state | `cs` / `state` | `state` |
| Next state | `ns` / `next_state` | `next_state` |
| Parameter | Uppercase descriptive | `WIDTH` |
| State constants | Descriptive | `IDLE`, `S1` |

Existing implementations may contain different naming styles because they were developed progressively. **New additions should follow a consistent convention wherever practical.**

---

## Verification Guidelines

Every new RTL implementation should ideally have a corresponding testbench.

The basic verification structure is:

```text
Design Under Test
       |
       v
   Testbench
       |
       +---- Clock
       |
       +---- Reset
       |
       +---- Stimulus
       |
       +---- Monitoring
       |
       +---- Expected Results
```

Verification should cover:

- Normal operation
- Reset behavior
- Boundary conditions
- Corner cases
- Invalid inputs where applicable
- Multiple operating conditions
- Expected outputs
- State transitions for sequential designs

For more advanced verification, self-checking testbenches and assertions can be introduced.

---

## Waveform Verification

Waveforms should be used to understand and debug the actual RTL behavior.

Important signals depend on the design, but commonly include:

```text
clk
rst
inputs
outputs
registers
state
next_state
flags
counters
```

For sequential circuits, verify that state changes occur at the intended clock edge.

For FSMs, verify:

```text
Current State
      ↓
Input
      ↓
Next State
      ↓
Output
```

---

## Recommended Design Workflow

Every new implementation should follow a consistent workflow:

```text
Specification
      ↓
Truth Table / State Diagram
      ↓
Logic Design
      ↓
RTL Implementation
      ↓
Testbench
      ↓
Compilation
      ↓
Simulation
      ↓
Waveform Analysis
      ↓
Verification
      ↓
Documentation
```

For simple circuits, some stages may be lightweight, but the overall hardware-design mindset should remain the same.

---

## Adding a New Design

When adding a new circuit:

### Identify the Category

Determine whether the design is:

```text
Combinational
```

or:

```text
Sequential
```

Then place it in the appropriate directory.

### Create the RTL

Use:

```text
design.v
```

### Create the Testbench

Use:

```text
design_tb.v
```

### Verify the Design

Run simulation and inspect the expected behavior.

### Document the Design

For substantial topics, create or update:

```text
README.md
```

### Review Before Commit

Check:

```text
RTL
Testbench
Simulation
Waveform
Documentation
File Placement
Naming
```

---

## Repository Rules

The following rules should be followed for future additions.

### Keep the Repository Fundamental

This repository is specifically for:

- Digital logic fundamentals
- Combinational circuits
- Sequential circuits
- Registers
- Counters
- FSMs
- Verilog RTL learning

Large standalone projects should **not** be added here.

Examples of projects that belong in a separate project repository:

```text
ALU
FIFO
DMA Controller
UART
RISC-V Processor
AES
AXI Interconnect
SoC
```

These should have their own project-oriented documentation and repository structure.

### Keep RTL and Verification Separate

Do not mix testbench-only constructs into synthesizable RTL.

### Verify Before Uploading

Every design should be simulated before being considered complete.

### Keep Documentation Close to the Design

Topic-specific explanations belong inside their corresponding folders.

### Avoid Unnecessary Duplication

The root README provides the repository-level overview.

Detailed theory should remain in the relevant topic README.

---

## Documentation Hierarchy

The repository follows three documentation levels.

```text
Root README
     |
     |--- Repository purpose
     |--- Repository structure
     |--- General rules
     |--- Usage
     |--- Verification workflow
     |
     ↓
Topic README
     |
     |--- Circuit theory
     |--- Implementations
     |--- Design details
     |--- Verification
     |
     ↓
RTL / Testbench
     |
     |--- Actual implementation
     |--- Simulation
```

This prevents the root README from becoming unnecessarily large while keeping every topic properly documented.

---

## Code Quality Principles

Future RTL should aim for:

- Correct hardware behavior
- Synthesizable coding style
- Readable RTL
- Descriptive signal names
- Consistent formatting
- Clear module interfaces
- Explicit reset behavior
- Proper sequential/combinational separation
- No unintended latches
- No unintended combinational loops
- Meaningful parameters
- Dedicated testbenches
- Verified simulation behavior

The repository prioritizes **understanding and correctness over unnecessary coding complexity**.

---

## Tool Compatibility

The designs are intended to be usable with common Verilog/SystemVerilog environments.

| Tool | Primary Use |
|---|---|
| Icarus Verilog | Lightweight Verilog simulation |
| Verilator | Fast RTL simulation and linting |
| ModelSim / Questa | RTL simulation |
| Synopsys VCS | Industry-oriented simulation |
| Xilinx Vivado | FPGA synthesis and implementation |
| GTKWave | Waveform visualization |

The exact toolchain can be selected according to the target environment.

---

## Learning Progression

The complete progression of the repository is:

```text
Basic Gates
    ↓
Adders / Subtractors
    ↓
MUX / DEMUX
    ↓
Decoders / Encoders
    ↓
Latches
    ↓
Flip-Flops
    ↓
Registers
    ↓
Asynchronous Counters
    ↓
Synchronous Counters
    ↓
Moore FSM
    ↓
Mealy FSM
    ↓
One-Hot FSM
```

This progression moves from simple Boolean logic to increasingly structured state-based hardware.

---

## What This Repository Is

`Verilog_RTL` is:

- A Verilog RTL learning repository
- A digital-design reference
- A collection of fundamental hardware implementations
- A simulation and verification practice repository
- A foundation for understanding RTL design
- A structured record of digital design implementations

---

## What This Repository Is Not

This repository is **not intended to be a collection of large RTL projects**.

Project-level designs such as:

```text
ALU
FIFO
DMA
UART
RISC-V
AES
AXI
SoC
```

are maintained separately as dedicated projects.

This keeps the purpose of `Verilog_RTL` clear:

```text
Fundamentals → RTL Understanding → Verification
```

rather than mixing fundamental exercises with complete project implementations.

---

## Design Philosophy

The central philosophy of this repository is:

```text
Understand
    ↓
Implement
    ↓
Simulate
    ↓
Verify
    ↓
Document
```

The objective is not simply to collect Verilog source files.

The objective is to understand:

```text
Digital Logic
      ↓
Hardware Behavior
      ↓
RTL Representation
      ↓
Simulation
      ↓
Verification
```

Every implementation should therefore be viewed as **hardware being described through Verilog**, rather than as software code.

---

## Final Scope

The current repository scope is intentionally complete at the FSM level:

```text
Verilog_RTL
│
├── Combinational Circuits
│
└── Sequential Circuits
    │
    ├── Latches
    ├── Flip-Flops
    ├── Registers
    ├── Counters
    │   ├── Asynchronous
    │   └── Synchronous
    │
    └── FSM
        ├── Moore
        ├── Mealy
        └── One-Hot
```

This provides a complete foundation in **fundamental Verilog RTL and digital sequential design**, while larger hardware projects remain separated into their own repositories.
