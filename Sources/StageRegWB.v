// -------------------------------------------------------
// -- StageRegWB.v - Stage register of WB
// -------------------------------------------------------
// Bugen Zhao 2020
// -------------------------------------------------------

`timescale 1ns / 1ps
`include "ISA.v"

module StageRegWB(
           input clk,

           input wire  [`WORD] memNewPC, memInstruction,
           input wire  [`WORD] memAluOut, memMemOut,

           output wire [`WORD] wbNewPC, wbInstruction,
           output wire [`WORD] wbAluOut, wbMemOut
       );

reg [`WORD] newPC, instruction;
reg [`WORD] aluOut, memOut;

always @(negedge clk) begin
    newPC = memNewPC;
    instruction = memInstruction;
    aluOut = memAluOut;
    memOut = memMemOut;
end

assign wbNewPC = newPC;
assign wbInstruction = instruction;
assign wbAluOut = aluOut;
assign wbMemOut = memOut;

endmodule // StageRegWB
