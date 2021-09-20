module systolic_array
  #(
    parameter BITS_AB=8,
    parameter BITS_C=16,
    parameter DIM=8
  )
  (
    input clk, rst_n, WrEn, en,
    input signed [BITS_AB-1:0] A [DIM-1:0],
    input signed [BITS_AB-1:0] B [DIM-1:0],
    input signed [BITS_C-1:0] Cin [DIM-1:0],
    input [$clog2(DIM)-1:0] Crow,
    output signed [BITS_C-1:0] Cout [DIM-1:0]
  );

  generate
    genvar row, col;
    for (row = 0; row < DIM; row = row + 1) begin : rowgen
      for (col = 0; col < DIM; col = col + 1) begin : colgen

      end
    end
  endgenerate
endmodule
