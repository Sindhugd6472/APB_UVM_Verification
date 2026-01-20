# UVM-based Verification Environment for AMBA APB Protocol

A complete UVM testbench for verifying the APB (Advanced Peripheral Bus) protocol, demonstrating constrained random testing, functional coverage, and protocol compliance checking.

## Project Overview

This project implements a full UVM verification environment for the AMBA APB protocol, including:
- Complete UVM testbench architecture
- APB slave DUT (Device Under Test)
- Constrained random transaction generation
- Scoreboard for automatic checking
- Multiple test scenarios (write-only, read-only, random mixed)

## Quick Demo

🚀 **[Run Live Simulation on EDA Playground](https://www.edaplayground.com/x/DqSP)**

Click "Run" to see the testbench in action with waveform generation!

## Features

- **Protocol**: AMBA APB (Advanced Peripheral Bus)
- **Methodology**: UVM 1.2
- **Language**: SystemVerilog
- **Transactions**: 20 random read/write operations
- **Verification**: Automatic scoreboard checking with 0 errors

## Repository Structure

```
APB_UVM_Verification/
├── rtl/
│ └── apb_slave.sv # APB slave design (DUT)
├── tb/
│ ├── apb_interface.sv # APB interface with clocking blocks
│ ├── apb_transaction.sv # Transaction class
│ ├── apb_sequencer.sv # UVM sequencer
│ ├── apb_driver.sv # UVM driver
│ ├── apb_monitor.sv # UVM monitor
│ ├── apb_sequences.sv # Test sequences
│ ├── apb_agent.sv # UVM agent
│ ├── apb_scoreboard.sv # Scoreboard for checking
│ ├── apb_env.sv # UVM environment
│ ├── apb_test.sv # Test classes
│ ├── apb_pkg.sv # Package file
│ └── top.sv # Top module
├── run.sh # Compilation script
└── README.md
```

## APB Protocol Details

The APB protocol uses a simple two-phase transfer:
1. **SETUP Phase**: PSEL=1, PENABLE=0 (address and control signals driven)
2. **ACCESS Phase**: PSEL=1, PENABLE=1, wait for PREADY=1 (data transfer)

### Signal Description
- `pclk`: Clock signal
- `preset_n`: Active-low reset
- `psel`: Peripheral select
- `penable`: Enable signal
- `pwrite`: Write (1) / Read (0) control
- `paddr[31:0]`: Address bus
- `pwdata[31:0]`: Write data
- `prdata[31:0]`: Read data
- `pready`: Ready signal from slave
- `pslverr`: Error signal

## Simulation Results

**Successful simulation with:**
- Total Transactions: 20
- Write Transactions: 10
- Read Transactions: 10
- UVM Errors: 0
- UVM Warnings: 0

## How to Run

### Option 1: EDA Playground (Recommended)
Run online: **[https://www.edaplayground.com/x/DqSP](https://www.edaplayground.com/x/DqSP)**

1. Click the link above
2. Click "Run" button
3. Check "Open EPWave after run" to view waveforms
4. Observe simulation results in Log window

### Option 2: Local Simulation
Requirements: ModelSim/Questa or compatible simulator with UVM support

```bash
chmod +x run.sh
./run.sh
```
## View waveforms:
```bash
gtkwave apb_test.vcd
```

## UVM Components

- **Transaction** : Defines APB transfer properties (read/write, address, data)

- **Driver** : Drives APB protocol timing on the interface

- **Monitor** : Observes bus activity and collects transactions

- **Sequencer** : Generates randomized test sequences

- **Scoreboard** : Validates read/write consistency using internal memory model

- **Agent** : Encapsulates driver, monitor, and sequencer

- **Environment** : Top-level testbench container

- **Tests** : Various test scenarios (write, read, random)

## Skills Demonstrated

✅ UVM methodology and architecture

✅ SystemVerilog for verification

✅ Protocol verification (AMBA APB)

✅ Constrained random verification

✅ Scoreboard-based checking

✅ Clocking blocks and interfaces

✅ Functional coverage concepts

✅ Transaction-level modeling

## Related Projects

- **[AXI4-Lite UVM Verification](https://github.com/Sindhugd6472/axi4-lite-uvm)** - More complex AMBA protocol verification

## License

This project is available for educational and portfolio purposes.
