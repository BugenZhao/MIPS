// -------------------------------------------------------
// -- StageRegID.v - Stage register of ID
// -------------------------------------------------------
// Bugen Zhao 2020
// -------------------------------------------------------

`timescale 1ns / 1ps
`include "ISA.v"

module StageRegID(
           input clk,

           input wire  [`WORD] ifNewPC, ifInstruction,
           input wire          flush,

           output wire [`WORD] idNewPC, idInstruction
       );

reg [`WORD] newPC, instruction;

always @(negedge clk) begin
    if (flush) begin
        newPC = ifNewPC;
        instruction = 0;
    end
    else begin
        newPC = ifNewPC;
        instruction = ifInstruction;
    end
end

assign idNewPC = newPC;
assign idInstruction = instruction;

endmodule // StageRegID
