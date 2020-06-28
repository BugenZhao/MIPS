// -------------------------------------------------------
// -- RegisterFile.v - Register file
// -------------------------------------------------------
// Bugen Zhao 2020
// -------------------------------------------------------

`timescale 1ns / 1ps
`include "ISA.v"

module RegisterFile(
           input clk,
           input wire  [ `OPC] opcode,
           input wire  [ `FUN] funct,
           input wire  [ `REG] readReg1,
           input wire  [ `REG] readReg2,
           input wire  [ `REG] writeReg,
           input wire          writeLoHi,
           input wire  [`WORD] writeData,
           input wire  [`WORD] writeDataHi,
           input wire          regWrite,
           output wire [`WORD] readData1,
           output wire [`WORD] readData2
       );

reg [`WORD] regFile[0:31];
reg [`WORD] lo, hi;

wire readHi = opcode == `OPC_SPECIAL && funct == `FUN_MFHI;
wire readLo = opcode == `OPC_SPECIAL && funct == `FUN_MFLO;

initial begin: init
    integer i;
    for (i = 0; i < 32; i++) begin
        regFile[i] = 0;
    end
    lo = 0;
    hi = 0;
end

always @(posedge clk) begin
    if (writeLoHi) begin
        lo <= writeData;
        hi <= writeDataHi;
    end
    else if (regWrite) begin
        regFile[writeReg] <= writeData;
    end
end

assign readData1 = readHi ? hi :
                   readLo ? lo :
                   readReg1 == 0 ? 0 : regFile[readReg1];
                   
assign readData2 = readReg2 == 0 ? 0 : regFile[readReg2];

endmodule
