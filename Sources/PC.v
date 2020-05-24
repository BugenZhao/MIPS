// -------------------------------------------------------
// -- PC.v - Program counter
// -------------------------------------------------------
// Bugen Zhao 2020
// -------------------------------------------------------

`timescale 1ns / 1ps

module PC(
           input clk,
           input wire  [31:0] newPC,
           output wire [31:0] pc
       );

reg [31:0] pcFile;

initial begin: init
    pcFile = 32'h0;
end

always @(negedge clk) begin
    pcFile <= newPC;
end

assign pc = pcFile;

endmodule
