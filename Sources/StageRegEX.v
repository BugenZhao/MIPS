// -------------------------------------------------------
// -- StageRegEX.v - Stage register of EX
// -------------------------------------------------------
// Bugen Zhao 2020
// -------------------------------------------------------

`timescale 1ns / 1ps
`include "ISA.v"

module StageRegEX(
           input clk,

           input wire [`WORD] idNewPC, idInstruction,
           input wire [`WORD] idReg1, idReg2,
           input wire [`WORD] idExtendedImm,
           input wire          flush,

           output reg [`WORD] exNewPC, exInstruction,
           output reg [`WORD] exReg1, exReg2,
           output reg [`WORD] exExtendedImm
       );

// reg [`WORD] newPC, instruction;
// reg [`WORD] reg1, reg2;
// reg [`WORD] extendedImm;

always @(negedge clk) begin
    if (flush) begin
        exNewPC <= idNewPC;
        exInstruction <= 0;
        exReg1 <= 0;
        exReg2 <= 0;
        exExtendedImm <= 0;
    end
    else begin
        exNewPC <= idNewPC;
        exInstruction <= idInstruction;
        exReg1 <= idReg1;
        exReg2 <= idReg2;
        exExtendedImm <= idExtendedImm;
    end
end

// assign exNewPC = newPC;
// assign exInstruction = instruction;
// assign exReg1 = reg1;
// assign exReg2 = reg2;
// assign exExtendedImm = extendedImm;

endmodule // StageRegEX
