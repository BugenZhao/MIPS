// -------------------------------------------------------
// -- StageRegWB.v - Stage register of WB
// -------------------------------------------------------
// Bugen Zhao 2020
// -------------------------------------------------------

`timescale 1ns / 1ps
`include "ISA.v"

module StageRegWB(
           input clk,

           input wire [`WORD] memNewPC, memInstruction,
           input wire [`WORD] memAluOut, memMemOut,
           input wire [ `REG] memWriteReg,
           input wire         memMemRead,

           output reg [`WORD] wbNewPC, wbInstruction,
           output reg [`WORD] wbAluOut, wbMemOut,
           output reg [ `REG] wbWriteReg,
           output reg         wbMemRead
       );

always @(negedge clk) begin
    wbNewPC <= memNewPC;
    wbInstruction <= memInstruction;
    wbAluOut <= memAluOut;
    wbMemOut <= memMemOut;
    wbWriteReg <= memWriteReg;
    wbMemRead <= memMemRead;
end

endmodule // StageRegWB
