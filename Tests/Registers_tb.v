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
reg  [ `OPC] opcode;
reg  [ `FUN] funct;
reg  [ `REG] readReg1;
reg  [ `REG] readReg2;
reg  [ `REG] writeReg;
reg          writeLoHi;
reg  [`WORD] writeData;
reg  [`WORD] writeDataHi;
reg          regWrite;
wire [`WORD] readData1;
wire [`WORD] readData2;



parameter PERIOD = 100;
always #(PERIOD) clk = !clk;

RegisterFile u_RegisterFile(
	.clk         (clk         ),
    .opcode      (opcode      ),
    .funct       (funct       ),
    .readReg1    (readReg1    ),
    .readReg2    (readReg2    ),
    .writeReg    (writeReg    ),
    .writeLoHi   (writeLoHi   ),
    .writeData   (writeData   ),
    .writeDataHi (writeDataHi ),
    .regWrite    (regWrite    ),
    .readData1   (readData1   ),
    .readData2   (readData2   )
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

    #120; // 680
    writeData = 'hbeefbeef;
    writeDataHi = 'hdeaddead;
    writeLoHi = 1;
    
    #200; // 880
    opcode = `OPC_SPECIAL;
    funct = `FUN_MFHI;

    #40;
    `assert(readData1, 'hdeaddead);
    
    #40;
    funct = `FUN_MFLO;

    #40;
    `assert(readData1, 'hbeefbeef);

    $finish;
end


endmodule
