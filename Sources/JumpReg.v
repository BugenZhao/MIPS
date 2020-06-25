// -------------------------------------------------------
// -- JumpReg.v - Detect JR
// -------------------------------------------------------
// Bugen Zhao 2020
// -------------------------------------------------------

`timescale 1ns / 1ps
`include "ISA.v"

module JumpReg(
           input wire [`WORD] instruction,
           output wire isJumpReg
       );

wire [`OPC] opcode = `GET_OPC(instruction);
wire [`FUN] funct  = `GET_FUN(instruction);

assign isJumpReg = opcode == `OPC_SPECIAL && (funct == `FUN_JR || funct == `FUN_JALR);

endmodule // JumpReg
