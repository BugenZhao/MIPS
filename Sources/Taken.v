// -------------------------------------------------------
// -- Taken.v - Decide whether to take branch
// -------------------------------------------------------
// Bugen Zhao 2020
// -------------------------------------------------------

`timescale 1ns / 1ps
`include "ISA.v"

module Taken (
           input wire [31:0] instruction,
           input wire        aluZero, // SUB, SLT, SLE
           output reg        taken
       );

wire [5:0] opcode = instruction[31:26];
wire [4:0] rt     = instruction[20:16];

wire set = ~aluZero; // SLT, SLE

always @(*) begin
    case (opcode)
        `OPC_REGIMM: begin
            case (rt)
                `RT_BLTZ, `RT_BLTZAL:
                    taken = set;
                `RT_BGEZ, `RT_BGEZAL:
                    taken = ~set;
                default: begin
                    $warning("%m: rt not recognized: %05b", rt);
                    taken = 0;
                end
            endcase
        end
        `OPC_BGTZ:
            taken = ~set;
        `OPC_BLEZ:
            taken = set;
        `OPC_BEQ:
            taken = aluZero;
        `OPC_BNE:
            taken = ~aluZero;
        default:
            taken = 'bx;
    endcase
end
endmodule // Taken
