class apb_driver extends uvm_driver #(apb_transaction);
  
  `uvm_component_utils(apb_driver)
  
  virtual apb_interface vif;
  
  function new(string name = "apb_driver", uvm_component parent = null);
    super.new(name, parent);
  endfunction
  
  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    if(!uvm_config_db#(virtual apb_interface)::get(this, "", "vif", vif))
      `uvm_fatal(get_type_name(), "Virtual interface not found!")
  endfunction
  
  task run_phase(uvm_phase phase);
    vif.psel = 0; vif.penable = 0; vif.pwrite = 0;
    vif.paddr = 0; vif.pwdata = 0;
    wait (vif.preset_n === 1);
    forever begin
      seq_item_port.get_next_item(req);
      drive_transaction(req);
      seq_item_port.item_done();
    end
  endtask
  
  task drive_transaction(apb_transaction trans);
    // IDLE state - deassert signals
    vif.driver_cb.psel    <= 0;
    vif.driver_cb.penable <= 0;
    @(vif.driver_cb);
    
    // SETUP phase
    vif.driver_cb.psel   <= 1;
    vif.driver_cb.paddr  <= trans.paddr;
    vif.driver_cb.pwrite <= trans.pwrite;
    if(trans.pwrite)
      vif.driver_cb.pwdata <= trans.pwdata;
    @(vif.driver_cb);
    
    // ACCESS phase
    vif.driver_cb.penable <= 1;
    @(vif.driver_cb);
    
    // Wait for PREADY
    while(vif.driver_cb.pready == 0)
      @(vif.driver_cb);
    
    trans.pslverr = vif.driver_cb.pslverr;

    // Capture read data if it's a read transaction
    if(!trans.pwrite)
      trans.prdata = vif.driver_cb.prdata;
    
  endtask
  
endclass

