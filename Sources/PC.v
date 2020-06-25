// -------------------------------------------------------
// -- PC.v - Program counter
// -------------------------------------------------------
// Bugen Zhao 2020
// -------------------------------------------------------

`timescale 1ns / 1ps
`include "ISA.v"

module PC(
           input clk,
           input wire  [`WORD] newPC,
           output wire [`WORD] pc
       );

reg [`WORD] pcFile;

initial begin: init
    pcFile = 32'h0;
end

always @(negedge clk) begin
    pcFile <= newPC;
end

assign pc = pcFile;

endmodule
