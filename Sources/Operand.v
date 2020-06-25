// -------------------------------------------------------
// -- Operand.v - Decide which Operand to use
// -------------------------------------------------------
// Bugen Zhao 2020
// -------------------------------------------------------

`timescale 1ns / 1ps
`include "ISA.v"

module Operand(
           input wire [`WORD] instruction,
           input wire [`WORD] rsData, rtData, extendedImm,
           output reg [`WORD] opA, opB
       );

wire [`OPC] opcode = `GET_OPC(instruction);
wire [`FUN] funct  = `GET_FUN(instruction);
wire [`SHA] shamt  = `GET_SHAMT(instruction);

// opA:
always @(*) begin
    case (opcode)
        `OPC_SPECIAL: begin
            case (funct)
                `FUN_SLL, `FUN_SRL, `FUN_SRA:
                    opA = {{27{1'b0}}, shamt};
                default:
                    opA = rsData;
            endcase
        end
        default:
            opA = rsData;
    endcase
end

// opB:
always @(*) begin
    case (opcode)
        `OPC_REGIMM, `OPC_BGTZ, `OPC_BLEZ: // slt, sle
            opB = 0;
        `OPC_SPECIAL, `OPC_BEQ, `OPC_BNE: // alu
            opB = rtData;
        `OPC_ADDI, `OPC_ADDIU, `OPC_ANDI, `OPC_ORI, `OPC_XORI, `OPC_LUI, `OPC_SLTI, `OPC_SLTIU: //imm
            opB = extendedImm;
        `OPC_LB, `OPC_LBU, `OPC_LH, `OPC_LHU, `OPC_LW, `OPC_SB, `OPC_SH, `OPC_SW: // l, s
            opB = extendedImm;
        default: // j, jal
            opB = 32'hxxxxxxxx;
    endcase
end

endmodule // Operand
