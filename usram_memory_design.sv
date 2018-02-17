// Each μSRAM block stores up to 1 Kbits (1,152 bits) of data and can be configured in any of the
// following depth × width combinations: 64 × 18, 64 × 16, 128 × 9, 128 × 8, 256 × 4, 512 × 2 and 1,024 × 1.
// Each μSRAM has 2 read data ports (Port A and Port B) and 1 write data port (Port C).
// Read operations can be performed in both Synchronous and Asynchronous modes. The write operation is always synchronous.
// μSRAM can operate up to 400 MHz in Synchronous-Synchronous read mode through Port A and Port B, including a write operation at 400 MHz through Port C.
// Simultaneous read and write operations at the same location are not allowed.
package USRAM_package;
  
  typedef enum {
    1Kx1,
    512x2,
    256x4,
    128x9,
    128x8,
    64x18,
    64x16
  } mode_type;
  
  function int addr_width_fn (input mode_type mode);
    int i = 0;
    unique case (mode)
      1Kx1    : i = 1024;
      512x2   : i = 512;
      256x4   : i = 256;
      128x9   : i = 128;
      128x8   : i = 128;
      64x18   : i = 64;
      64x16   : i = 64;
      default : i = 128;
    endcase
    return $clog2(i);
  endfunction
  
  function int data_width_fn (input mode_type mode);
    int i = 0;
    unique case (mode)
      1Kx1    : i = 1;
      512x2   : i = 2;
      256x4   : i = 4;
      128x9   : i = 9;
      128x8   : i = 8;
      64x18   : i = 18;
      64x16   : i = 16;
      default : i = 9;
    endcase
    return i;
  endfunction
  
endpackage

module USRAM_RAM1KX1_triport_mode #(
  parameter USRAM_package::mode_type mode = 16Kx1,
  parameter int DATA_WIDTH = USRAM_package::data_width_fn(mode),
  parameter int ADDR_WIDTH = USRAM_package::addr_width_fn(mode)
  ) (
  input  logic aclk,
  input  logic awe,
  input  logic [ADDR_WIDTH-1:0] aaddr,
  input  logic [DATA_WIDTH-1:0] adin,
  input  logic bclk,
  input  logic [ADDR_WIDTH-1:0] baddr,
  output logic [DATA_WIDTH-1:0] bdout,
  input  logic cclk,
  input  logic [ADDR_WIDTH-1:0] caddr,
  output logic [DATA_WIDTH-1:0] cdout
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
  always_ff @(posedge cclk) begin
    cdout <= mem[caddr];
  end
  
endmodule
