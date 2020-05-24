// -------------------------------------------------------
// -- NewPC.v - Compute new PC
// -------------------------------------------------------
// Bugen Zhao 2020
// -------------------------------------------------------

`timescale 1ns / 1ps
`include "ISA.v"

module NewPC(
           input wire [31:0] pc,
           input wire [31:0] instruction,
           input wire [31:0] jumpRegAddr,
           input wire        taken,
           output reg [31:0] newPC
       );

wire [ 5:0] opcode    = instruction[31:26];
wire [ 5:0] funct     = instruction[ 5: 0];
wire [25:0] jumpIndex = instruction[25: 0];
wire [15:0] immediate = instruction[15: 0];

wire [31:0] nextAddr   = pc + 4;
wire [31:0] branchAddr = (immediate << 2) + nextAddr;
wire [31:0] jumpAddr   = {nextAddr[31:28], (jumpIndex << 2)};

always @(*) begin
    case (opcode)
        `OPC_REGIMM, `OPC_BGTZ, `OPC_BLEZ, `OPC_BEQ, `OPC_BNE:
            newPC = taken ? branchAddr : nextAddr;
        `OPC_J, `OPC_JAL:
            newPC = jumpAddr;
        `OPC_SPECIAL: begin
            case (funct)
                `FUN_JR: newPC = jumpRegAddr;
                default: newPC = nextAddr;
            endcase
        end
        default:
            newPC = nextAddr;
    endcase
end

endmodule
