// -------------------------------------------------------
// -- Alu.v - ALU
// -------------------------------------------------------
// Bugen Zhao 2020
// -------------------------------------------------------

`include "ISA.v"

module Alu(
           input wire [31:0] opA, opB,
           input wire [ 5:0] aluFunct,
           output reg [31:0] out,
           output reg        zero
       );

always @(*) begin
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
        `FUN_SLL, `FUN_SLLV:
            out = opA << opB;
        `FUN_SRL, `FUN_SRLV:
            out = opA >> opB;
        `FUN_SRA, `FUN_SRAV:
            out = opA >>> opB;
        `FUN_JR:
            out = opA + opB; // opB == 0
        `FUN_NO:
            out = 0;

        default: begin
            $warning("%m: aluFunct not recognized: %06b", aluFunct);
            out = 0;
        end
    endcase

    zero = out == 0 ? 1 : 0;
end

endmodule // Alu
