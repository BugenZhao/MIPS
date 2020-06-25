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
           input wire         rsFwd, rtFwd,
           input wire [`WORD] rsFwdData, rtFwdData,

           output reg [`WORD] opA, opB,
           output reg [`WORD] writeToMemData
       );

wire [`OPC] opcode = `GET_OPC(instruction);
wire [`FUN] funct  = `GET_FUN(instruction);
wire [`SHA] shamt  = `GET_SHAMT(instruction);

wire [`WORD] zeroExtendedImm = {{16{1'b0}}, extendedImm[15:0]};

// opA:
always @(*) begin
    case (opcode)
        `OPC_SPECIAL: begin
            case (funct)
                `FUN_SLL, `FUN_SRL, `FUN_SRA:
                    opA = {{27{1'b0}}, shamt};
                default:
                    opA = rsFwd ? rsFwdData : rsData;
            endcase
        end
        default:
            opA = rsFwd ? rsFwdData : rsData;
    endcase
end

// opB:
always @(*) begin
    case (opcode)
        `OPC_REGIMM, `OPC_BGTZ, `OPC_BLEZ: // slt, sle
            opB = 0;
        `OPC_SPECIAL, `OPC_BEQ, `OPC_BNE: // alu
            opB = rtFwd ? rtFwdData : rtData;
        `OPC_ADDI, `OPC_ADDIU, `OPC_SLTI, `OPC_SLTIU: // imm
            opB = extendedImm;
        `OPC_ANDI, `OPC_ORI, `OPC_XORI, `OPC_LUI: // zero-ext imm
            opB = zeroExtendedImm;
        `OPC_LB, `OPC_LBU, `OPC_LH, `OPC_LHU, `OPC_LW, `OPC_SB, `OPC_SH, `OPC_SW: // l, s
            opB = extendedImm;
        default: // j, jal
            opB = 32'hxxxxxxxx;
    endcase
end

// memWriteData:
always @(*) begin
    writeToMemData = rtFwd ? rtFwdData : rtData;
end

endmodule // Operand
