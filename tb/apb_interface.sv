interface apb_interface(input logic pclk, input logic preset_n);
  
  // APB signals
  logic        psel;      
  logic        penable;   
  logic        pwrite;    
  logic [31:0] paddr;     
  logic [31:0] pwdata;    
  logic [31:0] prdata;    
  logic        pready;    
  logic        pslverr;   
  
  // Clocking block for driver
  clocking driver_cb @(posedge pclk);
    default input #1 output #1;
    output psel;
    output penable;
    output pwrite;
    output paddr;
    output pwdata;
    input  prdata;
    input  pready;
    input  pslverr;
  endclocking
  
  // Clocking block for monitor
  clocking monitor_cb @(posedge pclk);
    default input #1;
    input psel;
    input penable;
    input pwrite;
    input paddr;
    input pwdata;
    input prdata;
    input pready;
    input pslverr;
  endclocking
  
  modport DRIVER  (clocking driver_cb, input pclk, input preset_n);
  modport MONITOR (clocking monitor_cb, input pclk, input preset_n);
  
endinterface

