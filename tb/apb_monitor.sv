class apb_monitor extends uvm_monitor;
  
  `uvm_component_utils(apb_monitor)
  
  virtual apb_interface vif;
  uvm_analysis_port #(apb_transaction) item_collected_port;
  
  apb_transaction trans_collected;
  
  function new(string name = "apb_monitor", uvm_component parent = null);
    super.new(name, parent);
    item_collected_port = new("item_collected_port", this);
  endfunction
  
  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    if(!uvm_config_db#(virtual apb_interface)::get(this, "", "vif", vif))
      `uvm_fatal(get_type_name(), "Virtual interface not found!")
  endfunction
  
  task run_phase(uvm_phase phase);
    forever begin
      collect_transaction();
    end
  endtask
  
  task collect_transaction();
    trans_collected = apb_transaction::type_id::create("trans_collected");
    
    // Wait for SETUP phase (PSEL asserted, PENABLE low)
    @(vif.monitor_cb);
    wait(vif.monitor_cb.psel == 1 && vif.monitor_cb.penable == 0);
    
    // Wait for ACCESS phase (PSEL and PENABLE both high)
    @(vif.monitor_cb);
    wait(vif.monitor_cb.penable == 1);
    
    // Wait for PREADY to complete transaction
    while(vif.monitor_cb.pready == 0)
      @(vif.monitor_cb);
    
    // Collect transaction data
    trans_collected.paddr   = vif.monitor_cb.paddr;
    trans_collected.pwrite  = vif.monitor_cb.pwrite;
    trans_collected.pslverr = vif.monitor_cb.pslverr;
    
    if(vif.monitor_cb.pwrite)
      trans_collected.pwdata = vif.monitor_cb.pwdata;
    else
      trans_collected.prdata = vif.monitor_cb.prdata;
    
    // Send to scoreboard via analysis port
    item_collected_port.write(trans_collected);
    
    `uvm_info(get_type_name(), $sformatf("Transaction collected: %s", trans_collected.sprint()), UVM_LOW)
    
  endtask
  
endclass

