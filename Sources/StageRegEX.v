// -------------------------------------------------------
// -- StageRegEX.v - Stage register of EX
// -------------------------------------------------------
// Bugen Zhao 2020
// -------------------------------------------------------

`timescale 1ns / 1ps
`include "ISA.v"

module StageRegEX(
           input clk,

           input wire  [`WORD] idNewPC, idInstruction,
           input wire  [`WORD] idReg1, idReg2,
           input wire  [`WORD] idExtendedImm,
           input wire          flush,

           output wire [`WORD] exNewPC, exInstruction,
           output wire [`WORD] exReg1, exReg2,
           output wire [`WORD] exExtendedImm
       );

reg [`WORD] newPC, instruction;
reg [`WORD] reg1, reg2;
reg [`WORD] extendedImm;

always @(negedge clk) begin
    if (flush) begin
        newPC = idNewPC;
        instruction = 0;
        reg1 = 0;
        reg2 = 0;
        extendedImm = 0;
    end
    else begin
        newPC = idNewPC;
        instruction = idInstruction;
        reg1 = idReg1;
        reg2 = idReg2;
        extendedImm = idExtendedImm;
    end
end

assign exNewPC = newPC;
assign exInstruction = instruction;
assign exReg1 = reg1;
assign exReg2 = reg2;
assign exExtendedImm = extendedImm;

endmodule // StageRegEX
