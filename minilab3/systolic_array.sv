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

  wire signed [BITS_AB-1:0] horizontal [DIM-1:0][DIM-1:0];
  wire signed [BITS_AB-1:0] vertical [DIM-1:0][DIM-1:0];

  wire signed [BITS_C-1:0] grid_cout [DIM-1:0][DIM-1:0];

  generate
    genvar row, col;
    for (row = 0; row < DIM; row = row + 1) begin : rowgen
      for (col = 0; col < DIM; col = col + 1) begin : colgen

        wire signed [BITS_AB-1:0] Ain, Bin, Aout, Bout;
        wire signed [BITS_C-1:0] mac_cout;

        wire mac_WrEn;

        tpumac #(BITS_AB, BITS_C) mac (
          .clk(clk),
          .rst_n(rst_n),
          .WrEn(mac_WrEn),
          .en(en),
          .Ain(Ain),
          .Bin(Bin),
          .Cin(Cin[row]),
          .Aout(Aout),
          .Bout(Bout),
          .Cout(mac_cout)
        );

        assign grid_cout[row][col] = mac_cout;
        assign mac_WrEn = (Crow == row) ? WrEn : 1'b0;

        if (col == 0) begin
          assign Ain = A[row];
          assign horizontal[0][row] = Aout;
        end else begin
          assign Ain = horizontal[col - 1][row];
          assign horizontal[col][row] = Aout;
        end
        if (row == 0) begin
          assign Bin = B[col];
          assign vertical[0][col] = Bout;
        end else begin
          assign Bin = vertical[row - 1][col];
          assign vertical[row][col] = Bout;
        end
      end
    end
  endgenerate

  assign Cout = grid_cout[Crow];

endmodule
