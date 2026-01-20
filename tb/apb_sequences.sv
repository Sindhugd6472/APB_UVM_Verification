// Base sequence
class apb_base_sequence extends uvm_sequence #(apb_transaction);
  
  `uvm_object_utils(apb_base_sequence)
  
  function new(string name = "apb_base_sequence");
    super.new(name);
  endfunction
  
endclass

// Write sequence
class apb_write_sequence extends apb_base_sequence;
  
  `uvm_object_utils(apb_write_sequence)
  
  function new(string name = "apb_write_sequence");
    super.new(name);
  endfunction
  
  task body();
    repeat(10) begin
      req = apb_transaction::type_id::create("req");
      start_item(req);
      assert(req.randomize() with {pwrite == 1;});
      finish_item(req);
    end
  endtask
  
endclass

// Read sequence
class apb_read_sequence extends apb_base_sequence;
  
  `uvm_object_utils(apb_read_sequence)
  
  function new(string name = "apb_read_sequence");
    super.new(name);
  endfunction
  
  task body();
    repeat(10) begin
      req = apb_transaction::type_id::create("req");
      start_item(req);
      assert(req.randomize() with {pwrite == 0;});
      finish_item(req);
    end
  endtask
  
endclass

// Random mixed sequence
class apb_random_sequence extends apb_base_sequence;
  
  `uvm_object_utils(apb_random_sequence)
  
  function new(string name = "apb_random_sequence");
    super.new(name);
  endfunction
  
  task body();
    repeat(20) begin
      req = apb_transaction::type_id::create("req");
      start_item(req);
      assert(req.randomize());
      finish_item(req);
    end
  endtask
  
endclass

