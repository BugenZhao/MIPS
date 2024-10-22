// -------------------------------------------------------
// -- RegisterFile.v - Register file
// -------------------------------------------------------
// Bugen Zhao 2020
// -------------------------------------------------------

`timescale 1ns / 1ps
`include "ISA.v"

module RegisterFile(
           input clk,
           input wire  [ `REG] readReg1,
           input wire  [ `REG] readReg2,
           input wire  [ `REG] writeReg,
           input wire  [`WORD] writeData,
           input wire         regWrite,
           output wire [`WORD] readData1,
           output wire [`WORD] readData2
       );

reg [`WORD] regFile[0:31];

initial begin: init
    integer i;
    for (i = 0; i < 32; i = i + 1) begin
        regFile[i] = 0;
    end
end

always @(negedge clk) begin
    if (regWrite) regFile[writeReg] <= writeData;
end

assign readData1 = readReg1 == 0 ? 0 : regFile[readReg1];
assign readData2 = readReg2 == 0 ? 0 : regFile[readReg2];

endmodule
