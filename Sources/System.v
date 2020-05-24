// -------------------------------------------------------
// -- System.v - MIPS System
// -------------------------------------------------------
// Bugen Zhao 2020
// -------------------------------------------------------

`timescale 1ns / 1ps
module System;

// --- Clock ---
reg clk;
parameter PEROID = 10;
always #(PEROID) clk = !clk;


// --- Memory ---
wire [31:0] pc;
wire [31:0] instruction;
InstMemory u_InstMemory(
	.pc          (pc          ),
    .instruction (instruction )
);

wire [31:0] dataAddress;
wire [31:0] writeData, readData;
wire [ 1:0] memMode;
wire        memRead, memWrite;
DataMemory u_DataMemory(
	.clk       (clk         ),
    .address   (dataAddress ),
    .writeData (writeData   ),
    .mode      (memMode     ),
    .memRead   (memRead     ),
    .memWrite  (memWrite    ),
    .readData  (readData    )
);


// --- MIPS CPU ---
CPU u_CPU(
	.clk         (clk         ),
    .inst        (instruction ),
    .data        (readData    ),
    .memMode     (memMode     ),
    .pc          (pc          ),
    .dataAddress (dataAddress )
);


endmodule // System
