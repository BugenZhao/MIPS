// -------------------------------------------------------
// -- RegisterFile.v - Register file
// -------------------------------------------------------
// Bugen Zhao 2020
// -------------------------------------------------------

`timescale 1ns / 1ps

module RegisterFile(
           input clk,
           input wire  [ 4:0] readReg1,
           input wire  [ 4:0] readReg2,
           input wire  [ 4:0] writeReg,
           input wire  [31:0] writeData,
           input wire         regWrite,
           output wire [31:0] readData1,
           output wire [31:0] readData2
       );

reg [31:0] regFile[0:31];

always @(negedge clk) begin
    if (regWrite) regFile[writeReg] <= writeData;
end

assign readData1 = readReg1 == 0 ? 0 : regFile[readReg1];
assign readData2 = readReg2 == 0 ? 0 : regFile[readReg2];

endmodule
