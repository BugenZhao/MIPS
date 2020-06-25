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
           input wire  [`WORD] exAluOut, exMemWriteData,
           input wire  [ `REG] exWriteReg,
           input wire          exMemRead,

           output wire [`WORD] memNewPC, memInstruction,
           output wire [`WORD] memAluOut, memMemWriteData,
           output wire [ `REG] memWriteReg,
           output wire         memMemRead
       );

reg [`WORD] newPC, instruction;
reg [`WORD] aluOut, memWriteData;
reg [ `REG] writeReg;
reg         memRead;

always @(negedge clk) begin
    newPC = exNewPC;
    instruction = exInstruction;
    aluOut = exAluOut;
    memWriteData = exMemWriteData;
    writeReg = exWriteReg;
    memRead = exMemRead;
end

assign memNewPC = newPC;
assign memInstruction = instruction;
assign memAluOut = aluOut;
assign memMemWriteData = memWriteData;
assign memWriteReg = writeReg;
assign memMemRead = memRead;

endmodule // StageRegMEM
