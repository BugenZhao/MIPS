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
           input wire  [ `REG] memWriteReg,

           output wire [`WORD] wbNewPC, wbInstruction,
           output wire [`WORD] wbAluOut, wbMemOut,
           output wire [ `REG] wbWriteReg
       );

reg [`WORD] newPC, instruction;
reg [`WORD] aluOut, memOut;
reg [ `REG] writeReg;

always @(negedge clk) begin
    newPC = memNewPC;
    instruction = memInstruction;
    aluOut = memAluOut;
    memOut = memMemOut;
    writeReg = memWriteReg;
end

assign wbNewPC = newPC;
assign wbInstruction = instruction;
assign wbAluOut = aluOut;
assign wbMemOut = memOut;
assign wbWriteReg = writeReg;

endmodule // StageRegWB
