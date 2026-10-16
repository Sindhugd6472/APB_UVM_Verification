`timescale 1ns/1ps

module top;
  
  import uvm_pkg::*;
  import apb_pkg::*;
  
  // Clock and reset
  logic pclk;
  logic preset_n;
  
  // APB interface instance
  apb_interface intf(pclk, preset_n);
  
  // DUT instance
  apb_slave dut (
    .pclk(pclk),
    .preset_n(preset_n),
    .psel(intf.psel),
    .penable(intf.penable),
    .pwrite(intf.pwrite),
    .paddr(intf.paddr),
    .pwdata(intf.pwdata),
    .prdata(intf.prdata),
    .pready(intf.pready),
    .pslverr(intf.pslverr)
  );
  
  // Clock generation
  initial begin
    pclk = 0;
    forever #5 pclk = ~pclk;  // 10ns period = 100MHz
  end
  
  // Reset generation
  initial begin
    preset_n = 0;
    repeat (2) @(negedge pclk);
    preset_n = 1;
  end
  
  // UVM configuration and test start
  initial begin
    uvm_config_db#(virtual apb_interface)::set(null, "*", "vif", intf);
    
    // Run the test (change test name here to run different tests)
    run_test("apb_random_test"); // +UVM_TESTNAME overrides this default
  end
  
  // Waveform dump
  initial begin
    $dumpfile("apb_test.vcd");
    $dumpvars(0, top);
  end
  
  initial begin #1000000; $fatal(1, "APB UVM timeout"); end
endmodule

