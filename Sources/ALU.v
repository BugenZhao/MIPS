// -------------------------------------------------------
// -- ALU.v - ALU
// -------------------------------------------------------
// Bugen Zhao 2020
// -------------------------------------------------------

`timescale 1ns / 1ps
`include "ISA.v"

module ALU(
           input wire [`WORD] opA, opB,
           input wire [ `FUN] aluFunct,
           output reg [`WORD] out, outHi,
           output reg         zero
       );

always @(*) begin
    outHi = 32'hxxxxxxxx;

    case (aluFunct)
        `FUN_ADD:
            out = opA + opB;
        `FUN_ADDU:
            out = opA + opB;
        `FUN_SUB:
            out = opA - opB;
        `FUN_SUBU:
            out = opA - opB;
        `FUN_SLT:
            out = $signed(opA) < $signed(opB) ? 1 : 0;
        `FUN_SLTU:
            out = opA < opB ? 1 : 0;
        `FUN_AND:
            out = opA & opB;
        `FUN_OR:
            out = opA | opB;
        `FUN_XOR:
            out = opA ^ opB;
        `FUN_NOR:
            out = ~(opA | opB);
        `FUN_SLL:
            out = opB << opA; // rt << sa(opA)
        `FUN_SLLV:
            out = opB << (opA[`SHA]); // rt << rs
        `FUN_SRL:
            out = opB >> opA;
        `FUN_SRLV:
            out = opB >> (opA[`SHA]);
        `FUN_SRA:
            out = $signed(opB) >>> opA;
        `FUN_SRAV:
            out = $signed(opB) >>> (opA[`SHA]);
        `FUN_LUI:
            out = opB << 16;
        `FUN_SLE:
            out = $signed(opA) <= $signed(opB) ? 1 : 0;
        `FUN_MFHI, `FUN_MFLO:
            out = opA;
        `FUN_MULTU:
            {outHi, out} = opA * opB;
        `FUN_MULT:
            {outHi, out} = $signed(opA) * $signed(opB);
        `FUN_JR, `FUN_JALR, `FUN_NO:
            out = 32'hxxxxxxxx;

        default: begin
            if (aluFunct != 6'bxxxxxx) $warning("%m: aluFunct not recognized: %06b", aluFunct);
            out = 0;
        end
    endcase

    zero = out == 0 ? 1 : 0;
end

endmodule // ALU
