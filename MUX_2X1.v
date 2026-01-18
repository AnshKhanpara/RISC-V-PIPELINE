`timescale 1ns / 1ps

module mux_2x1(
input [31:0] a,
input [31:0] b,
input sel,

output [31:0]y
    );
    
assign y = sel ? b : a;
endmodule
