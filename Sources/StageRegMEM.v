// -------------------------------------------------------
// -- StageRegMEM.v - Stage register of MEM
// -------------------------------------------------------
// Bugen Zhao 2020
// -------------------------------------------------------

`timescale 1ns / 1ps
`include "ISA.v"

module StageRegMEM(
           input clk,

           input wire  [`WORD] exNewPC, exInstruction,
           input wire  [`WORD] exAluOut, exWriteToMemData,
           input wire  [ `REG] exWriteReg,
           input wire          exMemRead, exMemWrite,
           input wire  [ `MMD] exMemMode,

           output wire [`WORD] memNewPC, memInstruction,
           output wire [`WORD] memAluOut, memWriteToMemData,
           output wire [ `REG] memWriteReg,
           output wire         memMemRead, memMemWrite,
           output wire [ `MMD] memMemMode
       );

reg [`WORD] newPC, instruction;
reg [`WORD] aluOut, writeToMemData;
reg [ `REG] writeReg;
reg         memRead, memWrite;
reg [ `MMD] memMode;

always @(negedge clk) begin
    newPC = exNewPC;
    instruction = exInstruction;
    aluOut = exAluOut;
    writeToMemData = exWriteToMemData;
    writeReg = exWriteReg;
    memRead = exMemRead;
    memWrite = exMemWrite;
    memMode = exMemMode;
end

assign memNewPC = newPC;
assign memInstruction = instruction;
assign memAluOut = aluOut;
assign memWriteToMemData = writeToMemData;
assign memWriteReg = writeReg;
assign memMemRead = memRead;
assign memMemWrite = memMemWrite;
assign memMemMode = memMode;

endmodule // StageRegMEM
