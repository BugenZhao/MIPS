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
           input wire         isJumpReg,
           input wire [`WORD] branchAddr,
           input wire         taken,
           input wire         stall,

           output reg [`WORD] newPC,
           output reg         flushID, flushEX
       );

wire [`OPC] opcode    = instruction[31:26];
wire [`FUN] funct     = instruction[ 5: 0];
wire [25:0] jumpIndex = instruction[25: 0];

wire [`WORD] nextAddr   = pc + 4;
wire [`WORD] jumpAddr   = {nextAddr[31:28], (jumpIndex << 2)};

always @(*) begin
    flushID = 0;
    flushEX = 0;

    if (stall) begin
        newPC = pc;
        flushEX = 1;
    end
    else if (taken) begin
        newPC = branchAddr;
        flushID = 1;
        flushEX = 1;
    end
    else if (isJumpReg) begin
        newPC = jumpRegAddr;
        flushID = 1;
        flushEX = 1;
    end
    else begin
        case (opcode)
            `OPC_J, `OPC_JAL:
                newPC = jumpAddr;
            default:
                newPC = nextAddr;
        endcase
    end
end

endmodule
