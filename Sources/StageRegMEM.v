// -------------------------------------------------------
// -- StageRegMEM.v - Stage register of MEM
// -------------------------------------------------------
// Bugen Zhao 2020
// -------------------------------------------------------

`timescale 1ns / 1ps
`include "ISA.v"

module StageRegMEM(
           input clk,

           input wire [`WORD] exNextPC, exInstruction,
           input wire [`WORD] exALUOut, exALUOutHi,
           input wire [`WORD] exWriteToMemData,
           input wire [ `REG] exWriteReg,
           input wire         exWriteLoHi,
           input wire         exMemRead, exMemWrite,
           input wire [ `MMD] exMemMode,

           output reg [`WORD] memNextPC, memInstruction,
           output reg [`WORD] memALUOut, memALUOutHi,
           output reg [`WORD] memWriteToMemData,
           output reg [ `REG] memWriteReg,
           output reg         memWriteLoHi,
           output reg         memMemRead, memMemWrite,
           output reg [ `MMD] memMemMode
       );

always @(negedge clk) begin
    memNextPC <= exNextPC;
    memInstruction <= exInstruction;
    memALUOut <= exALUOut;
    memALUOutHi <= exALUOutHi;
    memWriteToMemData <= exWriteToMemData;
    memWriteReg <= exWriteReg;
    memWriteLoHi <= exWriteLoHi;
    memMemRead <= exMemRead;
    memMemWrite <= exMemWrite;
    memMemMode <= exMemMode;
end


endmodule // StageRegMEM
