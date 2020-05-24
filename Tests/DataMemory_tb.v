// -------------------------------------------------------
// -- DataMemory_tb.v
// -------------------------------------------------------
// Bugen Zhao 2020
// -------------------------------------------------------

`timescale 1ns / 1ps
`include "ISA.v"
`include "Debug.v"

module DataMemory_tb;

/*iverilog */
initial begin
    $dumpfile("wave.vcd");
    $dumpvars;
end
/*iverilog */

reg clk;
reg  [31:0] address;
reg  [31:0] writeData;
reg         memRead;
reg         memWrite;
wire [31:0] readData;


parameter PERIOD = 100;
always #(PERIOD) clk = !clk;

DataMemory u_DataMemory(
	.clk       (clk       ),
    .address   (address   ),
    .writeData (writeData ),
    .memRead   (memRead   ),
    .memWrite  (memWrite  ),
    .readData  (readData  )
);

initial begin
    clk = 1;

    #80; // 80
    memRead  = 0;
    memWrite = 1;
    address  = 10;
    writeData = 'hdead0000;

    #200; // 280
    memRead  = 1;
    memWrite = 1;
    address  = 18;
    writeData = 'h0000beef;

    #200; // 480
    memRead  = 0;
    memWrite = 0;
    address  = 18;
    writeData = 'h12345678;

    #40; // 520
    memRead  = 1;
    memWrite = 0;
    address = 10;

    #20; // 540
    `assert(readData, 'hdead0000);
    address = 18;

    #20; // 560
    `assert(readData, 'h0000beef);

    $finish;
end


endmodule
