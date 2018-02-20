// Each LSRAM block can store up to 18,432 bits of data and can be configured in any of the following
// depth x width combinations: 512 x 36, 512 x 32, 1k x 18, 1k x 16, 2k x 9, 2k x 8, 4k x 4, 8k x 2, or 16k x 1.
// Each LSRAM block contains two independent data ports—Port A and Port B.
// Supports maximum frequency up to 400 MHz.
// An optional pipeline register is available at the read data port to improve the clock-to-out delay.
// LSRAM can be operated in two memory modes: Dual-port mode,Two-port mode
// Read from both ports at the same location is allowed.
// Read and write on the same location at the same time is not allowed. There is no built in collision prevention or detection circuit in LSRAM.
package LSRAM_package;
  
  typedef enum {
    RAM16Kx1,
    RAM8Kx2,
    RAM4Kx4,
    RAM2Kx9,
    RAM2Kx8,
    RAM1Kx18,
    RAM1Kx16,
    RAM512x36,
    RAM512x32
  } mode_type;
  
  function automatic addr_depth_fn (input mode_type mode);
    int i;
    unique case (mode)
      RAM16Kx1   : i = 16*1024;
      RAM8Kx2    : i = 8*1024;
      RAM4Kx4    : i = 4*1024;
      RAM2Kx9    : i = 2*1024;
      RAM2Kx8    : i = 2*1024;
      RAM1Kx18   : i = 1*1024;
      RAM1Kx16   : i = 1*1024;
      default : i = 512;
    endcase
    return i;
  endfunction
  
  function automatic data_width_fn (input mode_type mode);
    int i;
    unique case (mode)
      RAM16Kx1   : i = 1;
      RAM8Kx2    : i = 2;
      RAM4Kx4    : i = 4;
      RAM2Kx9    : i = 9;
      RAM2Kx8    : i = 8;
      RAM1Kx18   : i = 18;
      RAM512x36  : i = 36;
      RAM512x32  : i = 32;
      default : i = 18;
    endcase
    return i;
  endfunction
  
endpackage
// Dual-port mode : 1k x 18, 1k x 16, 2k x 9, 2k x 8, 4k x 4, 8k x 2, or 16k x 1.
import LSRAM_package::*;
module LSRAM_RAM1KX18_dualport_mode #(
  parameter LSRAM_package::mode_type mode = RAM16Kx1,
  parameter int DATA_WIDTH = LSRAM_package::data_width_fn(mode),
  parameter int ADDR_DEPTH = LSRAM_package::addr_depth_fn(mode),
  parameter int ADDR_WIDTH = $clog2(ADDR_DEPTH)
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
import LSRAM_package::*;
module LSRAM_RAM1KX18_twoport_mode #(
  parameter LSRAM_package::mode_type mode = RAM16Kx1,
  parameter int DATA_WIDTH = LSRAM_package::data_width_fn(mode),
  parameter int ADDR_DEPTH = LSRAM_package::addr_depth_fn(mode),
  parameter int ADDR_WIDTH = $clog2(ADDR_DEPTH)
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
