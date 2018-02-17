// Each LSRAM block can store up to 18,432 bits of data and can be configured in any of the following
// depth x width combinations: 512 x 36, 512 x 32, 1k x 18, 1k x 16, 2k x 9, 2k x 8, 4k x 4, 8k x 2, or 16k x 1.
// Dual-port mode : 1k x 18, 1k x 16, 2k x 9, 2k x 8, 4k x 4, 8k x 2, or 16k x 1.
module LSRAM_RAM1KX18_dualport_mode #(
  parameter DATA_WIDTH = 18,
  parameter ADDR_WIDTH = 10
  ) (
  input  logic aclk,
  input  logic awe, // 0/1 = Read/Write
  input  logic [ADDR_WIDTH-1:0] aaddr,
  input  logic [DATA_WIDTH-1:0] adin,
  output logic [DATA_WIDTH-1:0] adout,
  input  logic bclk,
  input  logic bwe, // 0/1 = Read/Write
  input  logic [ADDR_WIDTH-1:0] baddr,
  input  logic [DATA_WIDTH-1:0] bdin,
  output logic [DATA_WIDTH-1:0] bdout
  );
  
  logic [DATA_WIDTH-1:0] mem [2**ADDR_WIDTH];
  always_ff @(posedge aclk) begin
    if (awe) begin
      mem[aaddr] <= adin;
    end
  end
  always_ff @(posedge aclk) begin
    adout <= mem[aaddr];
  end
  always_ff @(posedge bclk) begin
    if (bwe) begin
      mem[baddr] <= bdin;
    end
  end
  always_ff @(posedge bclk) begin
    bdout <= mem[baddr];
  end
  
endmodule
// Two-port mode : 512 x 36, 512 x 32, 1k x 18, 1k x 16, 2k x 9, 2k x 8, 4k x 4, 8k x 2, or 16k x 1.
module LSRAM_RAM1KX18_twoport_mode #(
  parameter DATA_WIDTH = 36,
  parameter ADDR_WIDTH = 9
  ) (
  input  logic aclk,
  input  logic awe, // 0/1 = Read/Write
  input  logic [ADDR_WIDTH-1:0] aaddr,
  input  logic [DATA_WIDTH-1:0] adin,
  input  logic bclk,
  input  logic [ADDR_WIDTH-1:0] baddr,
  output logic [DATA_WIDTH-1:0] bdout
  );
  
  logic [DATA_WIDTH-1:0] mem [2**ADDR_WIDTH];
  always_ff @(posedge aclk) begin
    if (awe) begin
      mem[aaddr] <= adin;
    end
  end
  always_ff @(posedge bclk) begin
    bdout <= mem[baddr];
  end
  
endmodule
