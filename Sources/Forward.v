// -------------------------------------------------------
// -- Forward.v - Decide whether and what to forward
// -------------------------------------------------------
// Bugen Zhao 2020
// -------------------------------------------------------

`timescale 1ns / 1ps
`include "ISA.v"

module Forward(
           input wire [ `REG] memWriteReg, wbWriteReg,
           input wire         memMemRead, wbMemRead,
           input wire         memWriteLoHi, wbWriteLoHi,
           input wire [`WORD] memALUOut, memALUOutHi,
           input wire [`WORD] wbALUOut, wbALUOutHi, wbMemOut,
           input wire [`WORD] memNextPC, wbNextPC,

           input wire [`WORD] exInstruction, memInstruction, wbInstruction,

           output reg         rsFwd, rtFwd,
           output reg [`WORD] rsFwdData, rtFwdData
       );

wire [`REG] rs = `GET_RS(exInstruction);
wire [`REG] rt = `GET_RT(exInstruction);

wire memIsLink, wbIsLink;
IsLink u_IsLink_mem(
           .instruction (memInstruction),
           .isLink      (memIsLink)
       );
IsLink u_IsLink_wb(
           .instruction (wbInstruction),
           .isLink      (wbIsLink)
       );

wire useRs, useRt, useLo, useHi;
RegUse u_RegUse(
           .instruction (exInstruction),
           .useRs       (useRs),
           .useRt       (useRt),
           .useLo       (useLo),
           .useHi       (useHi)
       );

always @(*) begin
    rsFwd = 0;
    rtFwd = 0;

    // forward form WB
    if (wbWriteReg != 0) begin
        if (wbIsLink) begin
            // forward wbNextPC from WB
            if (wbWriteReg == rs) begin
                rsFwd = 1;
                rsFwdData = wbNextPC;
            end
            if (wbWriteReg == rt) begin
                rtFwd = 1;
                rtFwdData = wbNextPC;
            end
        end
        else if (wbMemRead) begin
            // forward wbMemOut from WB
            if (wbWriteReg == rs) begin
                rsFwd = 1;
                rsFwdData = wbMemOut;
            end
            if (wbWriteReg == rt) begin
                rtFwd = 1;
                rtFwdData = wbMemOut;
            end
        end
        else begin
            // forward wbALUOut from WB
            if (wbWriteReg == rs) begin
                rsFwd = 1;
                rsFwdData = wbALUOut;
            end
            if (wbWriteReg == rt) begin
                rtFwd = 1;
                rtFwdData = wbALUOut;
            end
        end
    end

    // forward from MEM
    if (memWriteReg != 0) begin
        if (memIsLink) begin
            // forward memNextPC from MEM
            if (memWriteReg == rs) begin
                rsFwd = 1;
                rsFwdData = memNextPC;
            end
            if (memWriteReg == rt) begin
                rtFwd = 1;
                rtFwdData = memNextPC;
            end
        end
        else if (memMemRead) begin
            // load and use hazard, should never occur
        end
        else begin
            // forward memALUOut from MEM
            if (memWriteReg == rs) begin
                rsFwd = 1;
                rsFwdData = memALUOut;
            end
            if (memWriteReg == rt) begin
                rtFwd = 1;
                rtFwdData = memALUOut;
            end
        end
    end


    // FOR LO, HI => only rs will use them
    // forward lo, hi from WB
    if (wbWriteLoHi) begin
        if (useLo) begin
            rsFwd = 1;
            rsFwdData = wbALUOut;
        end
        if (useHi) begin
            rsFwd = 1;
            rsFwdData = wbALUOutHi;
        end
    end

    // forward lo, hi from MEM
    if (memWriteLoHi) begin
        if (useLo) begin
            rsFwd = 1;
            rsFwdData = memALUOut;
        end
        if (useHi) begin
            rsFwd = 1;
            rsFwdData = memALUOutHi;
        end
    end
end

endmodule // Forward
