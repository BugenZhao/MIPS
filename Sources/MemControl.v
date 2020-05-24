// -------------------------------------------------------
// -- MemControl.v - Decide whether to write or read DM
// -------------------------------------------------------
// Bugen Zhao 2020
// -------------------------------------------------------

`timescale 1ns / 1ps
`include "ISA.v"

module MemControl(
           input wire [31:0] instruction,
           output reg        memRead, memWrite,
           output reg [ 1:0] mode
       );

wire [5:0] opcode = `GET_OPC(instruction);

always @(*) begin
    memRead  = 0;
    memWrite = 0;
    case (opcode)
        `OPC_LB, `OPC_LBU: begin
            memRead = 1;
            mode    = `MEM_BYTE;
        end
        `OPC_LW: begin
            memRead = 1;
            mode    = `MEM_WORD;
        end
        `OPC_SB: begin
            memWrite = 1;
            mode     = `MEM_BYTE;
        end
        `OPC_SW: begin
            memWrite = 1;
            mode     = `MEM_WORD;
        end
    endcase
end

endmodule // MemControl
