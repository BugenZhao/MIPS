// -------------------------------------------------------
// -- PC.v - Program counter
// -------------------------------------------------------
// Bugen Zhao 2020
// -------------------------------------------------------

`timescale 1ns / 1ps
`include "ISA.v"

module PC(
           input clk,
           input wire [`WORD] newPC,
           output reg [`WORD] pc
       );

initial begin: init
    pc = 32'h0;
end

always @(negedge clk) begin
    pc <= newPC;
end

endmodule
