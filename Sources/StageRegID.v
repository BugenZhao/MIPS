// -------------------------------------------------------
// -- StageRegID.v - Stage register of ID
// -------------------------------------------------------
// Bugen Zhao 2020
// -------------------------------------------------------

`timescale 1ns / 1ps
`include "ISA.v"

module StageRegID(
           input clk,

           input wire [`WORD] ifNewPC, ifInstruction,
           input wire         flush,

           output reg [`WORD] idNewPC, idInstruction
       );

// reg [`WORD] newPC, instruction;

always @(negedge clk) begin
    if (flush) begin
        idNewPC <= ifNewPC;
        idInstruction <= 0;
    end
    else begin
        idNewPC <= ifNewPC;
        idInstruction <= ifInstruction;
    end
end

// assign idNewPC = newPC;
// assign idInstruction = instruction;

endmodule // StageRegID
