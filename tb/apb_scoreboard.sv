class apb_scoreboard extends uvm_scoreboard;
  
  `uvm_component_utils(apb_scoreboard)
  
  uvm_analysis_imp #(apb_transaction, apb_scoreboard) item_collected_export;
  
  int transaction_count = 0;
  int write_count = 0;
  int read_count = 0;
  
  // Simple memory model to check read/write consistency
  bit [31:0] memory [bit[31:0]];
  
  function new(string name = "apb_scoreboard", uvm_component parent = null);
    super.new(name, parent);
  endfunction
  
  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    item_collected_export = new("item_collected_export", this);
  endfunction
  
  function void write(apb_transaction trans);
    transaction_count++;
    
    if(trans.pwrite) begin
      // Write transaction
      write_count++;
      memory[trans.paddr] = trans.pwdata;
      `uvm_info(get_type_name(), $sformatf("WRITE: Addr=0x%0h Data=0x%0h", trans.paddr, trans.pwdata), UVM_MEDIUM)
    end
    else begin
      // Read transaction
      read_count++;
      if(memory.exists(trans.paddr)) begin
        if(memory[trans.paddr] == trans.prdata) begin
          `uvm_info(get_type_name(), $sformatf("READ PASS: Addr=0x%0h Expected=0x%0h Got=0x%0h", 
                    trans.paddr, memory[trans.paddr], trans.prdata), UVM_MEDIUM)
        end
        else begin
          `uvm_error(get_type_name(), $sformatf("READ FAIL: Addr=0x%0h Expected=0x%0h Got=0x%0h", 
                     trans.paddr, memory[trans.paddr], trans.prdata))
        end
      end
      else begin
        `uvm_info(get_type_name(), $sformatf("READ: Addr=0x%0h Data=0x%0h (first read)", trans.paddr, trans.prdata), UVM_MEDIUM)
      end
    end
  endfunction
  
  function void report_phase(uvm_phase phase);
    super.report_phase(phase);
    `uvm_info(get_type_name(), $sformatf("Total Transactions: %0d", transaction_count), UVM_LOW)
    `uvm_info(get_type_name(), $sformatf("Write Transactions: %0d", write_count), UVM_LOW)
    `uvm_info(get_type_name(), $sformatf("Read Transactions: %0d", read_count), UVM_LOW)
  endfunction
  
endclass

