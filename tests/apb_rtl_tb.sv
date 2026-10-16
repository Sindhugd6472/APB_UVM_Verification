`timescale 1ns/1ps
module apb_rtl_tb;
  logic pclk=0; always #5 pclk=~pclk;
  logic preset_n=0,psel=0,penable=0,pwrite=0,pready,pslverr;
  logic [31:0] paddr=0,pwdata=0,prdata;
  apb_slave dut(.*);
  task automatic transfer(input bit wr,input logic [31:0] addr,input logic [31:0] data);
    @(negedge pclk);psel=1;penable=0;pwrite=wr;paddr=addr;pwdata=data;
    @(negedge pclk);penable=1;
    do @(posedge pclk); while(!pready);
    if (pslverr || (!wr && prdata !== data)) $fatal(1,"APB mismatch addr=%h got=%h expected=%h",addr,prdata,data);
    @(negedge pclk);psel=0;penable=0;
  endtask
  initial begin
    repeat(2) @(negedge pclk);preset_n=1;
    for(integer i=0;i<16;i++) transfer(1,i,i*17);
    for(integer i=0;i<16;i++) transfer(0,i,i*17);
    $display("PASS: APB memory write/read and completion timing");$finish;
  end
  initial begin #100000;$fatal(1,"APB timeout");end
endmodule
