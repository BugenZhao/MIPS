// -------------------------------------------------------
// -- RegUse.v - Decide whether an inst uses registers
// -------------------------------------------------------
// Bugen Zhao 2020
// -------------------------------------------------------

`timescale 1ns / 1ps
`include "ISA.v"

module RegUse(
    input wire [`WORD] instruction,
    output reg useRs, useRt
);

wire [`OPC] opcode = `GET_OPC(instruction);
wire [`FUN] funct  = `GET_FUN(instruction);

always @(*) begin
    useRs = 1;
    useRt = 1;

    if (opcode == `OPC_J || opcode == `OPC_JAL) begin
        useRs = 0;
        useRt = 0;
    end
    
    if (opcode == `OPC_REGIMM) useRt = 0;
end

endmodule // RegUse
