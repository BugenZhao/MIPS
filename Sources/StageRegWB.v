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
           input wire          memMemRead,

           output wire [`WORD] wbNewPC, wbInstruction,
           output wire [`WORD] wbAluOut, wbMemOut,
           output wire [ `REG] wbWriteReg,
           output wire         wbMemRead
       );

reg [`WORD] newPC, instruction;
reg [`WORD] aluOut, memOut;
reg [ `REG] writeReg;
reg         memRead;

always @(negedge clk) begin
    newPC = memNewPC;
    instruction = memInstruction;
    aluOut = memAluOut;
    memOut = memMemOut;
    writeReg = memWriteReg;
    memRead = memMemRead;
end

assign wbNewPC = newPC;
assign wbInstruction = instruction;
assign wbAluOut = aluOut;
assign wbMemOut = memOut;
assign wbWriteReg = writeReg;
assign wbMemRead = memRead;

endmodule // StageRegWB
