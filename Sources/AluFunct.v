// -------------------------------------------------------
// -- AluFunct.v - Generate function code for ALU
// -------------------------------------------------------
// Bugen Zhao 2020
// -------------------------------------------------------

`timescale 1ns / 1ps
`include "ISA.v"

module AluFunct(
           input wire [5:0] opcode, funct,
           output reg [5:0] aluFunct
       );

always @(*) begin
    case (opcode)
        `OPC_SPECIAL:
            aluFunct = funct; // JR: NO
        `OPC_ADDI:
            aluFunct = `FUN_ADD;
        `OPC_ADDIU:
            aluFunct = `FUN_ADDU;
        `OPC_ANDI:
            aluFunct = `FUN_AND;
        `OPC_ORI:
            aluFunct = `FUN_OR;
        `OPC_XORI:
            aluFunct = `FUN_XOR;
        `OPC_LUI:
            aluFunct = `FUN_LUI;
        `OPC_SLTI:
            aluFunct = `FUN_SLT;
        `OPC_SLTIU:
            aluFunct = `FUN_SLTU;
        `OPC_REGIMM: // BGEZ, BGEZAL, BLTZ, BLTZAL, (BAL)
            aluFunct = `FUN_SLT; // opB will be 0
        `OPC_BGTZ, `OPC_BLEZ:
            aluFunct = `FUN_SLE; // opB will be 0
        `OPC_BEQ, `OPC_BNE:
            aluFunct = `FUN_SUB;
        `OPC_LB, `OPC_LBU, `OPC_LH, `OPC_LHU, `OPC_LW, `OPC_SB, `OPC_SH, `OPC_SW:
            aluFunct = `FUN_ADD;
        `OPC_J, `OPC_JAL:
            aluFunct = `FUN_NO;

        default: begin
            $warning("%m: opcode not recognized: %06b", opcode);
            aluFunct = `FUN_NO;
        end
    endcase
end

endmodule // AluFunct
