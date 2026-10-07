# Registers

This folder contains RTL implementations of **parallel and shift registers** using parameterized sequential logic.

The designs demonstrate how multiple flip-flops can be combined to store, shift, load, and transfer multi-bit data.

---

## 📁 Folder Structure

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

| File | Design |
|---|---|
| `n_bit_r.v` | N-bit Universal Shift Register |
| `n_bit_r_tb.v` | Testbench for Universal Shift Register |
| `pipo.v` | Parallel-In Parallel-Out Register |
| `pipo_tb.v` | PIPO testbench |
| `piso.v` | Parallel-In Serial-Out Shift Register |
| `piso_tb.v` | PISO testbench |
| `sipo.v` | Serial-In Parallel-Out Shift Register |
| `sipo_tb.v` | SIPO testbench |
| `siso.v` | Serial-In Serial-Out Shift Register |
| `siso_tb.v` | SISO testbench |

---

# 1. From Flip-Flops to Registers

A flip-flop stores **one bit**.

A register combines multiple flip-flops to store a multi-bit word.

```text
1 Flip-Flop
     ↓
  1 bit

N Flip-Flops
     ↓
 N-bit Register
```

For example, an 8-bit register contains eight 1-bit storage elements:

```text
D[7] ─► FF ─► Q[7]
D[6] ─► FF ─► Q[6]
D[5] ─► FF ─► Q[5]
D[4] ─► FF ─► Q[4]
D[3] ─► FF ─► Q[3]
D[2] ─► FF ─► Q[2]
D[1] ─► FF ─► Q[1]
D[0] ─► FF ─► Q[0]
```

All flip-flops normally share the same clock.

Therefore:

> **A register is a group of flip-flops used to store and manipulate a multi-bit data word.**

---

# 2. Why Do We Need Different Register Types?

The main difference is **how data enters and leaves the register**.

There are four fundamental forms:

| Register | Input | Output | Main Operation |
|---|---|---|---|
| **PIPO** | Parallel | Parallel | Store/transfer complete word |
| **SISO** | Serial | Serial | Shift data through |
| **SIPO** | Serial | Parallel | Serial-to-parallel conversion |
| **PISO** | Parallel | Serial | Parallel-to-serial conversion |

```text
             Data Input       Data Output

PIPO          Parallel  ───►  Parallel

SISO          Serial    ───►  Serial

SIPO          Serial    ───►  Parallel

PISO          Parallel  ───►  Serial
```

These are the four basic register/shift-register configurations implemented in this folder.

---

# 3. Common RTL Structure

The sequential designs use:

```verilog
always @(posedge clk or negedge rst)
```

Therefore they have:

- **Positive-edge-triggered operation**
- **Asynchronous active-low reset**

The general behavior is:

```text
RST = 0
   ↓
Q = 0 immediately

RST = 1
   ↓
Normal operation
   ↓
State changes at posedge CLK
```

---

# 4. Why `<=` Is Used

The register designs use **non-blocking assignment**:

```verilog
q <= d;
```

rather than:

```verilog
q = d;
```

For clocked sequential logic, non-blocking assignment is the standard RTL modeling style.

### Why?

All flip-flops connected to the same clock edge are conceptually updated **at the same time**.

For example:

```verilog
always @(posedge clk)
begin
    q[3] <= q[2];
    q[2] <= q[1];
    q[1] <= q[0];
    q[0] <= s_in;
end
```

With `<=`, every right-hand side is evaluated using the **old state**.

Therefore:

```text
Before clock:
Q = 1010

After shift:
Q = S_in 1 0 1
```

rather than allowing the newly assigned values to propagate through the same clock event.

This is especially important for shift registers.

---

# 5. PIPO Register

File:

```text
pipo.v
```

PIPO means:

> **Parallel-In Parallel-Out**

It loads an entire word simultaneously and provides the entire word simultaneously.

### Interface

```text
d[N-1:0] ─────►
               │
ld ───────────►│
clk ──────────►│  PIPO
rst ──────────►│
               │
          q[N-1:0] ───►
```

### Inputs

| Signal | Width | Purpose |
|---|---:|---|
| `d` | N | Parallel input data |
| `ld` | 1 | Load enable |
| `clk` | 1 | Clock |
| `rst` | 1 | Active-low asynchronous reset |

### Output

| Signal | Width | Purpose |
|---|---:|---|
| `q` | N | Stored parallel data |

---

## PIPO Operation

The RTL contains:

```verilog
if(!rst)
    q <= 0;
else if(ld)
    q <= d;
```

Therefore:

### Reset

```text
rst = 0
   ↓
q = 0
```

### Load

At the rising clock edge:

```text
ld = 1
   ↓
q <= d
```

The complete N-bit word is loaded simultaneously.

### Hold

When:

```text
ld = 0
```

there is no assignment to `q` in the clocked block, so the previous value is retained.

```text
ld = 0 → q remains unchanged
```

---

# 6. PIPO Example

Suppose:

```text
N = 8
d = 10101100
ld = 1
```

At the next rising clock edge:

```text
q = 10101100
```

If the input subsequently changes to:

```text
d = 11110000
ld = 0
```

the stored value remains:

```text
q = 10101100
```

because loading is disabled.

---

# 7. PIPO Applications

PIPO registers are used for:

- Temporary data storage
- CPU registers
- Pipeline registers
- Datapath storage
- Holding intermediate computation results
- Interface between synchronous logic blocks

---

# 8. SISO Shift Register

File:

```text
siso.v
```

SISO means:

> **Serial-In Serial-Out**

One bit enters per clock cycle and one bit leaves per clock cycle.

### Interface

```text
          ┌─────┐   ┌─────┐   ┌─────┐   ┌─────┐
s_in ───► │ FF3 │─► │ FF2 │─► │ FF1 │─► │ FF0 │──► s_out
          └─────┘   └─────┘   └─────┘   └─────┘
              ▲         ▲         ▲         ▲
              └──────────── CLK ────────────┘
```

The implementation uses:

```verilog
q_reg <= {s_in,q_reg[N-1:1]};
```

---

# 9. Understanding the Shift Operation

Consider:

```text
N = 4
```

and:

```text
q_reg = ABCD
```

where:

```text
A = q[3]
B = q[2]
C = q[1]
D = q[0]
```

After:

```verilog
q_reg <= {s_in,q_reg[3:1]};
```

the new state becomes:

```text
q_reg = s_in A B C
```

Therefore:

```text
Old:  A B C D
         ↓ ↓ ↓
New:  S A B C
```

The old `D = q[0]` leaves the register and becomes:

```text
s_out = q_reg[0]
```

So the register shifts toward the **LSB/output side**.

---

# 10. SISO Timing Example

Suppose the initial register is:

```text
0000
```

and the serial input sequence is:

```text
1 0 1 1
```

After successive clock edges:

```text
Initial       0000

Input = 1     1000
Input = 0     0100
Input = 1     1010
Input = 1     1101
```

The bit that reaches `q[0]` appears at `s_out`.

Therefore, data takes multiple clock cycles to propagate through the register.

---

# 11. SISO Applications

SISO registers are useful for:

- Serial data delay
- Digital delay lines
- Serial communication structures
- Bit-by-bit data transfer
- Timing/data alignment

---

# 12. SIPO Shift Register

File:

```text
sipo.v
```

SIPO means:

> **Serial-In Parallel-Out**

Data enters one bit at a time but becomes available as a complete parallel word.

### Interface

```text
                 ┌─────┐
s_in ──────────► │ SIPO│
                 └──┬──┘
                    │
              p_out[N-1:0]
```

The same shift operation is used:

```verilog
q_reg <= {s_in,q_reg[N-1:1]};
```

but instead of exposing only the final bit:

```verilog
assign s_out = q_reg[0];
```

the entire register is exposed:

```verilog
assign p_out = q_reg;
```

---

# 13. SIPO Example

For:

```text
N = 4
Initial = 0000
```

Serial input:

```text
1, 0, 1, 0
```

The register evolves as:

```text
Initial       0000

1             1000
0             0100
1             1010
0             0101
```

At this point:

```text
p_out = 0101
```

Thus, serial bits have been converted into a parallel word.

---

# 14. SIPO Applications

SIPO registers are commonly used for:

- Serial-to-parallel conversion
- Expanding the number of parallel outputs
- Interface circuits
- Serial communication receivers
- GPIO expansion
- Data collection from serial streams

---

# 15. PISO Shift Register

File:

```text
piso.v
```

PISO means:

> **Parallel-In Serial-Out**

It first loads an entire parallel word and then shifts it out one bit at a time.

### Interface

```text
p_in[N-1:0] ───►
                │
ld ────────────►│
en ────────────►│ PISO
clk ───────────►│
rst ───────────►│
                │
                └────► s_out
```

The register has two main operations:

1. **Parallel Load**
2. **Serial Shift**

---

# 16. PISO Control

The RTL contains:

```verilog
if(!rst)
    q_reg <= 0;
else if(ld)
    q_reg <= p_in;
else if(en)
    q_reg <= {1'b0,q_reg[N-1:1]};
```

The priority is:

```text
Reset
  ↓
Load
  ↓
Shift
```

### Reset

```text
rst = 0
→ q_reg = 0
```

### Load

```text
ld = 1
→ q_reg = p_in
```

### Shift

When:

```text
ld = 0
en = 1
```

the register shifts:

```text
q_reg <= {1'b0,q_reg[N-1:1]}
```

### Hold

When:

```text
ld = 0
en = 0
```

the register retains its previous value.

---

# 17. PISO Shift Direction

For:

```text
q_reg = ABCD
```

the shift operation:

```verilog
q_reg <= {1'b0,q_reg[N-1:1]};
```

produces:

```text
Before: A B C D
After:  0 A B C
```

Therefore:

```text
D = q_reg[0]
```

is the serial output before the shift.

The data moves toward the **LSB**.

---

# 18. PISO Example

Suppose:

```text
p_in = 1101
```

After loading:

```text
q_reg = 1101
s_out = 1
```

Then each enabled clock shifts the register:

```text
Initial       1101
Shift 1       0110
Shift 2       0011
Shift 3       0001
Shift 4       0000
```

The serial output is taken from:

```verilog
q_reg[0]
```

so the stored word is transmitted **LSB first**.

---

# 19. PISO Applications

PISO registers are useful for:

- Parallel-to-serial conversion
- Serial communication transmitters
- Data transmission over limited I/O lines
- Serializer structures
- Sending register contents serially

---

# 20. Universal Shift Register

File:

```text
n_bit_r.v
```

Module:

```verilog
module usr #(parameter N=8)
```

This is the most flexible register in this folder.

It supports:

- Hold
- Shift right
- Shift left
- Parallel load

Therefore it is called a:

> **Universal Shift Register**

---

# 21. Universal Shift Register Parameters

The module contains:

```verilog
parameter N=8
```

This makes the register width configurable.

For example:

```verilog
usr #(8)
```

creates an 8-bit register.

```verilog
usr #(16)
```

creates a 16-bit register.

```verilog
usr #(32)
```

creates a 32-bit register.

The internal storage automatically scales with `N`.

---

# 22. Universal Shift Register Inputs and Outputs

```text
                 ┌─────────────────────┐
d[N-1:0] ───────►│                     │
sr ─────────────►│                     │
sl ─────────────►│ Universal Shift     │
sel[1:0] ───────►│ Register            │
clk ────────────►│                     │
rst ────────────►│                     │
                 │                     │
                 └─────────► q[N-1:0] ┘
```

| Signal | Width | Purpose |
|---|---:|---|
| `d` | N | Parallel data input |
| `sr` | 1 | Serial input for right shift |
| `sl` | 1 | Serial input for left shift |
| `sel` | 2 | Operation selection |
| `clk` | 1 | Clock |
| `rst` | 1 | Active-low reset |
| `q` | N | Register output |

---

# 23. Universal Shift Register Control

The `sel` input determines the operation.

| `sel` | Operation |
|:---:|---|
| `00` | Hold |
| `01` | Shift Right |
| `10` | Shift Left |
| `11` | Parallel Load |

The RTL implements:

```verilog
case(sel)
    2'b00: q <= q;
    2'b01: q <= {sr,q[N-1:1]};
    2'b10: q <= {q[N-2:0],sl};
    2'b11: q <= d;
endcase
```

---

# 24. Hold Operation

```text
sel = 00
```

The register retains its current value:

```verilog
q <= q;
```

Example:

```text
Before = 10110010
After  = 10110010
```

No shifting or loading occurs.

---

# 25. Shift-Right Operation

```text
sel = 01
```

The RTL is:

```verilog
q <= {sr,q[N-1:1]};
```

For:

```text
q = ABCD
```

the result is:

```text
Before: A B C D
After:  S A B C
```

where `S = sr`.

Therefore:

```text
sr enters q[N-1]
q[0] leaves the register
```

---

# 26. Shift-Left Operation

```text
sel = 10
```

The RTL is:

```verilog
q <= {q[N-2:0],sl};
```

For:

```text
q = ABCD
```

the result is:

```text
Before: A B C D
After:  B C D S
```

where `S = sl`.

Therefore:

```text
sl enters q[0]
q[N-1] leaves the register
```

---

# 27. Parallel Load

```text
sel = 11
```

The complete word is loaded:

```verilog
q <= d;
```

For:

```text
d = 10101100
```

after the active clock edge:

```text
q = 10101100
```

---

# 28. Why the Universal Shift Register Is Important

The universal shift register combines the functionality of the other register types.

```text
                 Universal
              Shift Register
                    │
        ┌───────────┼───────────┐
        │           │           │
       Hold      Shift        Load
                  /   \
                Left  Right
```

It therefore provides a useful example of **multi-function sequential RTL controlled by a selection input**.

---

# 29. Shift Direction Summary

The designs in this folder use:

### Right Shift

```verilog
{sr,q[N-1:1]}
```

```text
Before: A B C D
After:  S A B C
```

### Left Shift

```verilog
{q[N-2:0],sl}
```

```text
Before: A B C D
After:  B C D S
```

The exact direction matters because it determines:

- Which bit is discarded
- Where the serial input enters
- Which bit becomes the serial output

---

# 30. Register Comparison

| Type | Input | Output | Main Function |
|---|---|---|---|
| PIPO | Parallel | Parallel | Store complete word |
| SISO | Serial | Serial | Serial delay/transfer |
| SIPO | Serial | Parallel | Serial → Parallel |
| PISO | Parallel | Serial | Parallel → Serial |
| Universal | Parallel + Serial | Parallel | Hold + Left/Right Shift + Load |

---

# 31. `ld` vs `en`

Two different control concepts are used in these designs.

### Load Enable

Used by PIPO and PISO:

```text
ld = 1
```

means:

> Load the parallel input data.

### Shift Enable

Used by SISO and SIPO:

```text
en = 1
```

means:

> Perform a shift on the next active clock edge.

For PISO:

```text
ld = 1 → Load
ld = 0, en = 1 → Shift
ld = 0, en = 0 → Hold
```

The control priority is important.

---

# 32. Why the Shift Happens Only at the Clock Edge

Consider:

```verilog
else if(en)
    q_reg <= {s_in,q_reg[N-1:1]};
```

Even if `en = 1`, the shift does **not happen immediately**.

It happens at:

```text
posedge clk
```

because the statement is inside:

```verilog
always @(posedge clk or negedge rst)
```

Therefore:

```text
en = 1
      │
      │ waits
      ▼
posedge clk
      │
      ▼
Shift occurs
```

This is fundamental to synchronous sequential logic.

---

# 33. Why Non-Blocking Assignment Matters During Shifting

Consider a 4-bit register:

```text
q = 1011
```

with:

```text
s_in = 0
```

The intended next state is:

```text
0101
```

Using:

```verilog
q <= {s_in,q[3:1]};
```

all bits are taken from the **old state**:

```text
Old q = 1 0 1 1
          ↓ ↓ ↓
New q = 0 1 0 1
```

This correctly models simultaneous flip-flop updates.

---

# 34. Reset Behavior

All designs use:

```verilog
always @(posedge clk or negedge rst)
```

with:

```verilog
if(!rst)
    q <= 0;
```

Therefore reset is:

- **Asynchronous**
- **Active-low**
- Forces all stored bits to zero

Example:

```text
rst = 0
   ↓
q = 00000000
```

for an 8-bit register.

---

# 35. Parameterization

Several designs use:

```verilog
parameter N=8
```

This allows the same RTL to support different widths.

For example:

```verilog
pipo #(8)
pipo #(16)
pipo #(32)
```

The testbenches demonstrate this concept using:

```verilog
localparam N=16;
```

for PIPO and:

```verilog
localparam N=4;
```

for the shift registers.

### Advantage

Instead of writing separate:

```text
4-bit register
8-bit register
16-bit register
32-bit register
```

one parameterized module can support all of them.

---

# 36. Verification

Each design has a dedicated testbench.

```text
n_bit_r.v   → n_bit_r_tb.v
pipo.v      → pipo_tb.v
piso.v      → piso_tb.v
sipo.v      → sipo_tb.v
siso.v      → siso_tb.v
```

The testbenches verify:

- Reset
- Load
- Hold
- Shift enable
- Left shift
- Right shift
- Serial input
- Serial output
- Parallel input
- Parallel output
- Different register widths

Waveforms are dumped using:

```verilog
$fsdbDumpvars();
```

and monitored using `$monitor`.

---

# 37. Applications

| Register | Typical Applications |
|---|---|
| PIPO | CPU registers, datapath storage, pipeline registers |
| SISO | Delay lines, serial data transfer |
| SIPO | Serial-to-parallel conversion, GPIO expansion |
| PISO | Parallel-to-serial conversion, data transmission |
| Universal Shift Register | Data manipulation, serial/parallel conversion, configurable shifting |

---

# 38. Future Implementations

Possible extensions for this section include:

### Registers

- Register with synchronous reset
- Register with asynchronous set/reset
- Register with load and clear
- Register with enable
- Multiple-register datapath
- Register file

### Shift Registers

- Bidirectional shift register
- Arithmetic right shift
- Logical left/right shift
- Rotate-left register
- Rotate-right register
- Rotate-through-carry
- Configurable shift direction

### Universal Shift Register

- Separate synchronous/asynchronous controls
- Additional operation modes
- Rotate operations
- Arithmetic shifting
- Cascaded multi-word shift registers

---

# 39. From Registers to Counters

Registers provide the **state storage** required by counters.

A counter can be viewed as:

```text
Current State
      │
      ▼
Next-State Logic
      │
      ▼
Register / Flip-Flops
      │
      └──────────────► Current State
```

For example:

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
```

Therefore, after registers and shift registers, the natural next topic is **Counters**.

---

# 40. Key Takeaways

- A register is a collection of flip-flops used for multi-bit storage.
- **PIPO** stores and outputs data in parallel.
- **SISO** shifts serial data from input to output.
- **SIPO** converts serial input into parallel output.
- **PISO** converts parallel input into serial output.
- A **Universal Shift Register** supports hold, left shift, right shift, and parallel load.
- `<=` is used for clocked sequential logic to model simultaneous state updates.
- Shift operations occur only on the active clock edge.
- Concatenation `{}` is used to implement the bit movement during shifting.
- `parameter N` makes the register width configurable.
- `ld` controls parallel loading, while `en` controls shifting.
- All current designs use **positive-edge-triggered operation with asynchronous active-low reset**.
- Registers are the fundamental storage elements used to build larger sequential systems such as **counters, FSMs, datapaths, and pipelines**.
