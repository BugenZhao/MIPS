// -------------------------------------------------------
// -- StageRegID.v - Stage register of ID
// -------------------------------------------------------
// Bugen Zhao 2020
// -------------------------------------------------------

`timescale 1ns / 1ps
`include "ISA.v"

module StageRegID(
           input clk,

           input wire [`WORD] ifNextPC, ifInstruction,
           input wire         flush,

           output reg [`WORD] idNextPC, idInstruction
       );

always @(negedge clk) begin
    if (flush) begin
        idNextPC <= ifNextPC;
        idInstruction <= 0;
    end
    else begin
        idNextPC <= ifNextPC;
        idInstruction <= ifInstruction;
    end
end


endmodule // StageRegID
