#!/bin/bash
set -euo pipefail
: "${UVM_HOME:?Set UVM_HOME to your UVM source checkout}"

# Clean previous build
rm -rf work
rm -f *.vcd
rm -f transcript
rm -f vsim.wlf

# Create work library
vlib work

# Compile RTL
echo "Compiling RTL..."
vlog -sv rtl/apb_slave.sv

# Compile Testbench
echo "Compiling Testbench..."
vlog -sv +incdir+tb +incdir+"$UVM_HOME/src" \
         "$UVM_HOME/src/uvm_pkg.sv" \
         tb/apb_interface.sv \
         tb/apb_pkg.sv \
         tb/top.sv

# Run simulation
echo "Running Simulation..."
vsim -c -do "run -all; quit" top +UVM_TESTNAME=apb_random_test

echo "Simulation Complete! Check apb_test.vcd for waveforms"

