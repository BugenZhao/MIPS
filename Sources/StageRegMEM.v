// -------------------------------------------------------
// -- StageRegMEM.v - Stage register of MEM
// -------------------------------------------------------
// Bugen Zhao 2020
// -------------------------------------------------------

`timescale 1ns / 1ps
`include "ISA.v"

module StageRegMEM(
           input clk,

           input wire [`WORD] exNewPC, exInstruction,
           input wire [`WORD] exALUOut, exWriteToMemData,
           input wire [ `REG] exWriteReg,
           input wire         exMemRead, exMemWrite,
           input wire [ `MMD] exMemMode,

           output reg [`WORD] memNewPC, memInstruction,
           output reg [`WORD] memALUOut, memWriteToMemData,
           output reg [ `REG] memWriteReg,
           output reg         memMemRead, memMemWrite,
           output reg [ `MMD] memMemMode
       );

always @(negedge clk) begin
    memNewPC <= exNewPC;
    memInstruction <= exInstruction;
    memALUOut <= exALUOut;
    memWriteToMemData <= exWriteToMemData;
    memWriteReg <= exWriteReg;
    memMemRead <= exMemRead;
    memMemWrite <= exMemWrite;
    memMemMode <= exMemMode;
end


endmodule // StageRegMEM
