// -------------------------------------------------------
// -- MemControl.v - Decide whether to write or read DM
// -------------------------------------------------------
// Bugen Zhao 2020
// -------------------------------------------------------

`timescale 1ns / 1ps
`include "ISA.v"

module MemControl(
           input wire [31:0] instruction,
           output reg        memRead, memWrite
       );

wire [5:0] opcode = `GET_OPC(instruction);

always @(*) begin
    memRead  = 0;
    memWrite = 0;
    case (opcode)
        `OPC_LB, `OPC_LW:
            memRead  = 1;
        `OPC_SB, `OPC_SW:
            memWrite = 1;
    endcase
end

endmodule // MemControl
