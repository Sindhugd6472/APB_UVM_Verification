class apb_base_test extends uvm_test;
  
  `uvm_component_utils(apb_base_test)
  
  apb_env env;
  
  function new(string name = "apb_base_test", uvm_component parent = null);
    super.new(name, parent);
  endfunction
  
  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    env = apb_env::type_id::create("env", this);
  endfunction
  
  function void end_of_elaboration_phase(uvm_phase phase);
    uvm_top.print_topology();
  endfunction
  
endclass

// Write test
class apb_write_test extends apb_base_test;
  
  `uvm_component_utils(apb_write_test)
  
  function new(string name = "apb_write_test", uvm_component parent = null);
    super.new(name, parent);
  endfunction
  
  task run_phase(uvm_phase phase);
    apb_write_sequence seq;
    phase.raise_objection(this);
    seq = apb_write_sequence::type_id::create("seq");
    seq.start(env.agent.sequencer);
    #100;
    phase.drop_objection(this);
  endtask
  
endclass

// Read test
class apb_read_test extends apb_base_test;
  
  `uvm_component_utils(apb_read_test)
  
  function new(string name = "apb_read_test", uvm_component parent = null);
    super.new(name, parent);
  endfunction
  
  task run_phase(uvm_phase phase);
    apb_read_sequence seq;
    phase.raise_objection(this);
    seq = apb_read_sequence::type_id::create("seq");
    seq.start(env.agent.sequencer);
    #100;
    phase.drop_objection(this);
  endtask
  
endclass

// Random test
class apb_random_test extends apb_base_test;
  
  `uvm_component_utils(apb_random_test)
  
  function new(string name = "apb_random_test", uvm_component parent = null);
    super.new(name, parent);
  endfunction
  
  task run_phase(uvm_phase phase);
    apb_random_sequence seq;
    phase.raise_objection(this);
    seq = apb_random_sequence::type_id::create("seq");
    seq.start(env.agent.sequencer);
    #100;
    phase.drop_objection(this);
  endtask
  
endclass

