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
           input wire [`WORD] memALUOut, wbALUOut, wbMemOut,
           input wire [`WORD] memNewPC, wbNewPC,

           input wire [`WORD] exInstruction, memInstruction, wbInstruction,

           output reg         rsFwd, rtFwd,
           output reg [`WORD] rsFwdData, rtFwdData
       );

wire [`REG] rs = `GET_RS(exInstruction);
wire [`REG] rt = `GET_RT(exInstruction);

wire memIsLink, wbIsLink;
IsLink u_IsLink_mem(
           .instruction (memInstruction ),
           .isLink      (memIsLink      )
       );
IsLink u_IsLink_wb(
           .instruction (wbInstruction ),
           .isLink      (wbIsLink      )
       );

wire useRs, useRt;
RegUse u_RegUse(
           .instruction (exInstruction ),
           .useRs       (useRs         ),
           .useRt       (useRt         )
       );

always @(*) begin
    rsFwd = 0;
    rtFwd = 0;

    // forward form WB
    if (wbWriteReg != 0) begin
        if (wbIsLink) begin
            // forward wbNewPC from WB
            if (wbWriteReg == rs) begin
                rsFwd = 1;
                rsFwdData = wbNewPC;
            end
            if (wbWriteReg == rt) begin
                rtFwd = 1;
                rtFwdData = wbNewPC;
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

    // forward from MEM, or stall
    if (memWriteReg != 0) begin
        if (memIsLink) begin
            // forward memNewPC from MEM
            if (memWriteReg == rs) begin
                rsFwd = 1;
                rsFwdData = memNewPC;
            end
            if (memWriteReg == rt) begin
                rtFwd = 1;
                rtFwdData = memNewPC;
            end
        end
        else if (memMemRead) begin
            // load and use, should never occur
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
end

endmodule // Forward
