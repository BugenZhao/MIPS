// -------------------------------------------------------
// -- StageRegEX.v - Stage register of EX
// -------------------------------------------------------
// Bugen Zhao 2020
// -------------------------------------------------------

`timescale 1ns / 1ps
`include "ISA.v"

module StageRegEX(
           input clk,

           input wire [`WORD] idNextPC, idInstruction,
           input wire [`WORD] idReg1, idReg2,
           input wire [`WORD] idExtendedImm,
           input wire          flush,

           output reg [`WORD] exNextPC, exInstruction,
           output reg [`WORD] exReg1, exReg2,
           output reg [`WORD] exExtendedImm
       );

always @(negedge clk) begin
    if (flush) begin
        exNextPC <= idNextPC;
        exInstruction <= 0;
        exReg1 <= 0;
        exReg2 <= 0;
        exExtendedImm <= 0;
    end
    else begin
        exNextPC <= idNextPC;
        exInstruction <= idInstruction;
        exReg1 <= idReg1;
        exReg2 <= idReg2;
        exExtendedImm <= idExtendedImm;
    end
end

endmodule // StageRegEX
