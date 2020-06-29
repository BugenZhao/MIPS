// -------------------------------------------------------
// -- IsLink.v - Determine whether an instruction is Link
// -------------------------------------------------------
// Bugen Zhao 2020
// -------------------------------------------------------

`timescale 1ns / 1ps
`include "ISA.v"

module IsLink (
           input wire  [`WORD] instruction,
           output wire isLink
       );

wire [`OPC] opcode = `GET_OPC(instruction);
wire [`FUN] funct  = `GET_FUN(instruction);
wire [`REG] rt     = `GET_RT(instruction);

assign isLink = (opcode == `OPC_REGIMM && (rt == `RT_BGEZAL || rt == `RT_BLTZAL)) ||
                (opcode == `OPC_JAL) ||
                (opcode == `OPC_SPECIAL && funct == `FUN_JALR);

endmodule // IsLink
