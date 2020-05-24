// -------------------------------------------------------
// -- RegisterFile_tb.v
// -------------------------------------------------------
// Bugen Zhao 2020
// -------------------------------------------------------

`timescale 1ns / 1ps
`include "ISA.v"
`include "Debug.v"

module RegisterFile_tb;

/*iverilog */
initial begin
    $dumpfile("wave.vcd");
    $dumpvars;
end
/*iverilog */

reg clk;
reg  [ 4:0] readReg1;
reg  [ 4:0] readReg2;
reg  [ 4:0] writeReg;
reg  [31:0] writeData;
reg         regWrite;
wire [31:0] readData1;
wire [31:0] readData2;


parameter PERIOD = 100;
always #(PERIOD) clk = !clk;

RegisterFile u_RegisterFile(
	.clk       (clk       ),
    .readReg1  (readReg1  ),
    .readReg2  (readReg2  ),
    .writeReg  (writeReg  ),
    .writeData (writeData ),
    .regWrite  (regWrite  ),
    .readData1 (readData1 ),
    .readData2 (readData2 )
);

initial begin
    clk = 1;

    #80; // 80
    regWrite  = 1;
    writeReg  = 10;
    writeData = 'hdead0000;

    #200; // 280
    regWrite  = 1;
    writeReg  = 10;
    writeData = 'hbeef;

    #200; // 480
    regWrite  = 1;
    writeReg  = 0;
    writeData = 'h20200523;

    #40; // 520
    readReg1 = 10;
    readReg2 = 0;

    #40; // 560
    `assert(readData1, 'hbeef);
    `assert(readData2, 0);

    $finish;
end


endmodule