// -------------------------------------------------------
// -- IsMult.v - Determine whether an instruction is mult
// -------------------------------------------------------
// Bugen Zhao 2020
// -------------------------------------------------------

`timescale 1ns / 1ps
`include "ISA.v"

module IsMult (
           input wire  [`WORD] instruction,
           output wire isMult
       );

wire [`OPC] opcode = `GET_OPC(instruction);
wire [`FUN] funct  = `GET_FUN(instruction);

assign isMult = opcode == `OPC_SPECIAL && (funct == `FUN_MULT || funct == `FUN_MULTU);

endmodule // IsMult
