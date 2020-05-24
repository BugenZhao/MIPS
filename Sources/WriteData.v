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
    writeData = (opcode == `OPC_LB || opcode == `OPC_LW) ? memoryOut : aluOut;
end

endmodule // WriteData
