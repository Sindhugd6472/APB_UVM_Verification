module apb_slave (
  input  logic        pclk,
  input  logic        preset_n,
  input  logic        psel,
  input  logic        penable,
  input  logic        pwrite,
  input  logic [31:0] paddr,
  input  logic [31:0] pwdata,
  output logic [31:0] prdata,
  output logic        pready,
  output logic        pslverr
);

  // Simple memory array
  logic [31:0] mem [256];
  
  // Internal signals
  logic [7:0] addr_index;
  
  assign addr_index = paddr[7:0];  // Use lower 8 bits as index
  assign pslverr = 1'b0;           // No errors for this simple slave
  
  always_ff @(posedge pclk or negedge preset_n) begin
    if(!preset_n) begin
      pready <= 1'b0;
      prdata <= 32'h0;
    end
    else begin
      if(psel && penable) begin
        pready <= 1'b1;
        
        if(pwrite) begin
          // Write operation
          mem[addr_index] <= pwdata;
        end
        else begin
          // Read operation
          prdata <= mem[addr_index];
        end
      end
      else begin
        pready <= 1'b0;
      end
    end
  end

endmodule

