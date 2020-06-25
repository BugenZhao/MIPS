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
           input wire [`WORD] memAluOut, wbAluOut, wbMemOut,
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
            // forward wbAluOut from WB
            if (wbWriteReg == rs) begin
                rsFwd = 1;
                rsFwdData = wbAluOut;
            end
            if (wbWriteReg == rt) begin
                rtFwd = 1;
                rtFwdData = wbAluOut;
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
            $warning("LOAD & USE HAZARD NOT RESOLVED: pc = %08X", memNewPC);
        end
        else begin
            // forward memAluOut from MEM
            if (memWriteReg == rs) begin
                rsFwd = 1;
                rsFwdData = memAluOut;
            end
            if (memWriteReg == rt) begin
                rtFwd = 1;
                rtFwdData = memAluOut;
            end
        end
    end
end

endmodule // Forward
