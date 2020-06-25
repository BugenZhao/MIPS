// -------------------------------------------------------
// -- NewPC.v - Compute new PC
// -------------------------------------------------------
// Bugen Zhao 2020
// -------------------------------------------------------

`timescale 1ns / 1ps
`include "ISA.v"

module NewPC(
           input wire [`WORD] pc,
           input wire [`WORD] instruction,
           input wire [`WORD] jumpRegAddr,
           input wire [`WORD] extendedImm,
           input wire        taken,
           output reg [`WORD] newPC
       );

wire [`OPC] opcode    = instruction[31:26];
wire [`FUN] funct     = instruction[ 5: 0];
wire [25:0] jumpIndex = instruction[25: 0];

wire [`WORD] nextAddr   = pc + 4;
wire [`WORD] branchAddr = (extendedImm << 2) + nextAddr;
wire [`WORD] jumpAddr   = {nextAddr[31:28], (jumpIndex << 2)};

always @(*) begin
    case (opcode)
        `OPC_REGIMM, `OPC_BGTZ, `OPC_BLEZ, `OPC_BEQ, `OPC_BNE:
            newPC = taken ? branchAddr : nextAddr;
        `OPC_J, `OPC_JAL:
            newPC = jumpAddr;
        `OPC_SPECIAL: begin
            case (funct)
                `FUN_JR, `FUN_JALR: 
                    newPC = jumpRegAddr;
                default: 
                    newPC = nextAddr;
            endcase
        end
        default:
            newPC = nextAddr;
    endcase
end

endmodule
