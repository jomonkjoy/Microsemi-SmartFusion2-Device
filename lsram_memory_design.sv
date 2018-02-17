// Each LSRAM block can store up to 18,432 bits of data and can be configured in any of the following
// depth x width combinations: 512 x 36, 512 x 32, 1k x 18, 1k x 16, 2k x 9, 2k x 8, 4k x 4, 8k x 2, or 16k x 1.
package LSRAM_package;
  
  typedef enum {
    16Kx1,
    8Kx2,
    4Kx4,
    2Kx9,
    2Kx8,
    1Kx18,
    1Kx16,
    512x36,
    512x32
  } mode_type;
  
  function int addr_width_fn (input mode_type mode);
    int i = 0;
    unique case (mode)
      16Kx1   : i = 16*1024;
      8Kx2    : i = 8*1024;
      4Kx4    : i = 4*1024;
      2Kx9    : i = 2*1024;
      2Kx8    : i = 2*1024;
      1Kx18   : i = 1*1024;
      1Kx16   : i = 1*1024;
      default : i = 512;
    endcase
    return $clog2(i);
  endfunction
  
  function int data_width_fn (input mode_type mode);
    int i = 0;
    unique case (mode)
      16Kx1   : i = 1;
      8Kx2    : i = 2;
      4Kx4    : i = 4;
      2Kx9    : i = 9;
      2Kx8    : i = 8;
      1Kx18   : i = 18;
      512x36  : i = 36;
      512x32  : i = 32;
      default : i = 18;
    endcase
    return i;
  endfunction
  
endpackage
// Dual-port mode : 1k x 18, 1k x 16, 2k x 9, 2k x 8, 4k x 4, 8k x 2, or 16k x 1.
module LSRAM_RAM1KX18_dualport_mode #(
  parameter LSRAM_package::mode_type mode = 16Kx1,
  parameter int DATA_WIDTH = LSRAM_package::data_width_fn(mode),
  parameter int ADDR_WIDTH = LSRAM_package::addr_width_fn(mode)
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
  parameter LSRAM_package::mode_type mode = 16Kx1,
  parameter int DATA_WIDTH = LSRAM_package::data_width_fn(mode),
  parameter int ADDR_WIDTH = LSRAM_package::addr_width_fn(mode)
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
