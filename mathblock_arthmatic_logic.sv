// High-performance and power optimized multiplications operations
// Supports 18 x 18 signed multiplication natively
// Supports 17 x 17 unsigned multiplications
// Supports dot product: the multiplier computes(A[8:0] x B[17:9] + A[17:9] x B[8:0]) x 29
// Built-in addition, subtraction, and accumulation units to combine multiplication results efficiently
// Independent third input C with data width 44 bits completely registered.
// Supports both registered and unregistered inputs and outputs
// Supports signed and unsigned operations
// Internal cascade signals (44-bit CDIN and CDOUT) enable cascading of the math blocks to support
// larger accumulator, adder, and subtractor without extra logic
// Supports loopback capability
// Adder support: (A x B) + C or (A x B) + D or (A x B) + C + D
// Clock-gated input and output registers for power optimizations
// Width of adder and accumulator can be extended by implementing extra adders in the FPGA fabric.
module int_mul_add #(
  parameter I_DATA_WIDTH = 18
  parameter O_DATA_WIDTH = 44
) (
  input  logic clk,
  input  logic reset,
  input  logic en,
  input  logic [I_DATA_WIDTH-1:0] a,
  input  logic [I_DATA_WIDTH-1:0] b,
  input  logic [I_DATA_WIDTH-1:0] c,
  input  logic c_in,
  output logic [O_DATA_WIDTH-1:0] p
);
  
  logic signed [I_DATA_WIDTH-1:0] a_reg;
  logic signed [I_DATA_WIDTH-1:0] b_reg;
  logic signed [I_DATA_WIDTH-1:0] c_reg;
  logic signed [O_DATA_WIDTH-1:0] p_reg;
  logic c_in_reg;
  always_ff @(posedge clk) begin
    if (reset) begin
      a_reg <= {I_DATA_WIDTH{1'b0}};
      b_reg <= {I_DATA_WIDTH{1'b0}};
      c_reg <= {I_DATA_WIDTH{1'b0}};
      c_in_reg <= 1'b0;
    end else begin
      a_reg <= a;
      b_reg <= b;
      c_reg <= c;
      c_in_reg <= c_in;
    end
  end
  always_ff @(posedge clk) begin
    if (reset) begin
      p_reg <= {O_DATA_WIDTH{1'b0}};
    end else if (en) begin
      p_reg <= (a_reg * b_reg) + c_reg + c_in_reg;
    end
  end
  assign p = p_reg;

endmodule

module int_signed_mul #(
  parameter I_DATA_WIDTH = 18
  parameter O_DATA_WIDTH = 41
) (
  input  logic clk,
  input  logic reset,
  input  logic [I_DATA_WIDTH-1:0] a,
  input  logic [I_DATA_WIDTH-1:0] b,
  output logic [O_DATA_WIDTH-1:0] p
);
  
  logic signed [I_DATA_WIDTH-1:0] a_reg;
  logic signed [I_DATA_WIDTH-1:0] b_reg;
  logic signed [O_DATA_WIDTH-1:0] p_reg;
  always_ff @(posedge clk) begin
    if (reset) begin
      a_reg <= {I_DATA_WIDTH{1'b0}};
      a_reg <= {I_DATA_WIDTH{1'b0}};
      p_reg <= {O_DATA_WIDTH{1'b0}};
    end else begin
      a_reg <= a;
      b_reg <= b;
      p_reg <= (a_reg * b_reg);
    end
  end
  assign p = p_reg;

endmodule


module int_unsigned_mul #(
  parameter I_DATA_WIDTH = 17
  parameter O_DATA_WIDTH = 34
) (
  input  logic clk,
  input  logic reset,
  input  logic [I_DATA_WIDTH-1:0] a,
  input  logic [I_DATA_WIDTH-1:0] b,
  output logic [O_DATA_WIDTH-1:0] p
);
  
  logic unsigned [I_DATA_WIDTH-1:0] a_reg;
  logic unsigned [I_DATA_WIDTH-1:0] b_reg;
  logic unsigned [O_DATA_WIDTH-1:0] p_reg;
  always_ff @(posedge clk) begin
    if (reset) begin
      a_reg <= {I_DATA_WIDTH{1'b0}};
      a_reg <= {I_DATA_WIDTH{1'b0}};
      p_reg <= {O_DATA_WIDTH{1'b0}};
    end else begin
      a_reg <= a;
      b_reg <= b;
      p_reg <= (a_reg * b_reg);
    end
  end
  assign p = p_reg;

endmodule

module int_mul_add_clr #(
  parameter I_DATA_WIDTH = 18
  parameter O_DATA_WIDTH = 44
) (
  input  logic clk,
  input  logic reset,
  input  logic clr,
  input  logic [I_DATA_WIDTH-1:0] a,
  input  logic [I_DATA_WIDTH-1:0] b,
  input  logic [I_DATA_WIDTH-1:0] c,
  output logic [O_DATA_WIDTH-1:0] p
);
  
  logic signed [I_DATA_WIDTH-1:0] a_reg;
  logic signed [I_DATA_WIDTH-1:0] b_reg;
  logic signed [I_DATA_WIDTH-1:0] c_reg;
  logic signed [I_DATA_WIDTH-1:0] c_int;
  logic signed [O_DATA_WIDTH-1:0] p_reg;
  always_ff @(posedge clk) begin
    if (reset) begin
      a_reg <= {I_DATA_WIDTH{1'b0}};
      b_reg <= {I_DATA_WIDTH{1'b0}};
      c_reg <= {I_DATA_WIDTH{1'b0}};
    end else begin
      a_reg <= a;
      b_reg <= b;
      c_reg <= c;
    end
  end
  always_ff @(posedge clk) begin
    if (reset) begin
      p_reg <= {O_DATA_WIDTH{1'b0}};
    end else begin
      p_reg <= (a_reg * b_reg) + c_int;
    end
  end
  assign c_int = clr ? {I_DATA_WIDTH{1'b0}} : c_reg;
  assign p = p_reg;

endmodule

module int_mul_acc_clr #(
  parameter I_DATA_WIDTH = 18
  parameter O_DATA_WIDTH = 44
) (
  input  logic clk,
  input  logic reset,
  input  logic clr,
  input  logic [I_DATA_WIDTH-1:0] a,
  input  logic [I_DATA_WIDTH-1:0] b,
  output logic [O_DATA_WIDTH-1:0] p
);
  
  logic signed [I_DATA_WIDTH-1:0] a_reg;
  logic signed [I_DATA_WIDTH-1:0] b_reg;
  logic signed [O_DATA_WIDTH-1:0] c_int;
  logic signed [O_DATA_WIDTH-1:0] p_reg;
  always_ff @(posedge clk) begin
    if (reset) begin
      a_reg <= {I_DATA_WIDTH{1'b0}};
      b_reg <= {I_DATA_WIDTH{1'b0}};
    end else begin
      a_reg <= a;
      b_reg <= b;
    end
  end
  always_ff @(posedge clk) begin
    if (reset) begin
      p_reg <= {O_DATA_WIDTH{1'b0}};
    end else begin
      p_reg <= (a_reg * b_reg) + c_int;
    end
  end
  assign c_int = clr ? {O_DATA_WIDTH{1'b0}} : p_reg;
  assign p = p_reg;

endmodule
