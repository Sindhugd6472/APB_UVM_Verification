class apb_transaction extends uvm_sequence_item;
  
  // Transaction fields
  rand bit        pwrite;      // 1 = Write, 0 = Read
  rand bit [31:0] paddr;       // Address
  rand bit [31:0] pwdata;      // Write data
  bit [31:0]      prdata;      // Read data (driven by slave)
  bit             pslverr;     // Error response
  
  // UVM automation macros
  `uvm_object_utils_begin(apb_transaction)
    `uvm_field_int(pwrite, UVM_ALL_ON)
    `uvm_field_int(paddr,  UVM_ALL_ON)
    `uvm_field_int(pwdata, UVM_ALL_ON)
    `uvm_field_int(prdata, UVM_ALL_ON)
    `uvm_field_int(pslverr, UVM_ALL_ON)
  `uvm_object_utils_end
  
  // Constructor
  function new(string name = "apb_transaction");
    super.new(name);
  endfunction
  
  // Constraints
  constraint addr_c { paddr inside {[32'h0000:32'h00FF]}; }  // Adjust range as needed
  
endclass

