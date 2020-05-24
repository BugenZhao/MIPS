// -------------------------------------------------------
// -- WriteData.v - Decide which data to write back
// -------------------------------------------------------
// Bugen Zhao 2020
// -------------------------------------------------------

`timescale 1ns / 1ps
`include "ISA.v"

module WriteData(
           input wire [31:0] instruction,
           input wire [31:0] aluOut, memoryOut,
           output reg [31:0] writeData
       );

wire [5:0] opcode = `GET_OPC(instruction);

always @(*) begin
    case (opcode)
        `OPC_LB:
            writeData = {{24{memoryOut[7]}}, memoryOut[7:0]};
        `OPC_LW:
            writeData = memoryOut;
        default:
            writeData = aluOut;
    endcase
end

endmodule // WriteData
