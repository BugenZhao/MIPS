// -------------------------------------------------------
// -- StageRegWB.v - Stage register of WB
// -------------------------------------------------------
// Bugen Zhao 2020
// -------------------------------------------------------

`timescale 1ns / 1ps
`include "ISA.v"

module StageRegWB(
           input clk,

           input wire [`WORD] memNextPC, memInstruction,
           input wire [`WORD] memALUOut, memALUOutHi, memMemOut,
           input wire [ `REG] memWriteReg,
           input wire         memMemRead,
           input wire         memWriteLoHi,

           output reg [`WORD] wbNextPC, wbInstruction,
           output reg [`WORD] wbALUOut, wbALUOutHi, wbMemOut,
           output reg [ `REG] wbWriteReg,
           output reg         wbMemRead,
           output reg         wbWriteLoHi
       );

always @(negedge clk) begin
    wbNextPC <= memNextPC;
    wbInstruction <= memInstruction;
    wbALUOut <= memALUOut;
    wbALUOutHi <= memALUOutHi;
    wbMemOut <= memMemOut;
    wbWriteReg <= memWriteReg;
    wbMemRead <= memMemRead;
    wbWriteLoHi <= memWriteLoHi;
end

endmodule // StageRegWB
