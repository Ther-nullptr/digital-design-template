/////////////////////////////////////////////////////////////
// Created by: Synopsys DC Expert(TM) in wire load mode
// Version   : P-2019.03-SP5-6
// Date      : Thu Nov 23 14:24:10 2023
/////////////////////////////////////////////////////////////


module top ( clk, rst, out );
  output [3:0] out;
  input clk, rst;


  counter_0 cnt ( .clk(clk), .rst(rst), .out(out) );
endmodule


module counter_0 ( clk, rst, out );
  output [3:0] out;
  input clk, rst;
  wire   N2, N3, N4, n1, n2, n3, n4;

  INVX6BA10TR U9 ( .A(rst), .Y(n2) );
  DFFRPQX4MA10TR out_reg_1_ ( .D(N2), .CK(clk), .R(n2), .Q(out[1]) );
  DFFRPQX4MA10TR out_reg_2_ ( .D(N3), .CK(clk), .R(n2), .Q(out[2]) );
  DFFRPQX4MA10TR out_reg_0_ ( .D(n1), .CK(clk), .R(n2), .Q(out[0]) );
  DFFRPQX4MA10TR out_reg_3_ ( .D(N4), .CK(clk), .R(n2), .Q(out[3]) );
  NAND2X0P5MA10TR U3 ( .A(out[1]), .B(out[0]), .Y(n4) );
  XNOR2X0P5MA10TR U4 ( .A(out[1]), .B(n1), .Y(N2) );
  XNOR2X0P5MA10TR U5 ( .A(out[2]), .B(n4), .Y(N3) );
  XOR2X0P5MA10TR U6 ( .A(out[3]), .B(n3), .Y(N4) );
  NOR2BX1MA10TR U7 ( .AN(out[2]), .B(n4), .Y(n3) );
  INVX0P5BA10TR U8 ( .A(out[0]), .Y(n1) );
endmodule

