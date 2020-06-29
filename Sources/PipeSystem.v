// -------------------------------------------------------
// -- PipeSystem.v - Pipelined MIPS System
// -------------------------------------------------------
// Bugen Zhao 2020
// -------------------------------------------------------

`timescale 1ns / 1ps
`include "ISA.v"

module PipeSystem #(parameter textDump = "path/to/text/dump",
                    parameter PERIOD   = 10);

// --- Clock ---
reg clk;
always #(PERIOD) clk = !clk;
initial clk = 1;

// --- Memory ---
wire [ `WORD] pc;
wire [ `WORD] instruction;
wire          instReady;
wire [ `WORD] imAddr;
wire [`QWORD] imQdata;
wire          imInstReady;

Cache u_Cache(
	.pc          (pc          ),
    .inst        (instruction ),
    .instReady   (instReady   ),
    .imAddr      (imAddr      ),
    .imQdata     (imQdata     ),
    .imInstReady (imInstReady )
);

InstMemory #(textDump) u_InstMemory(
	.clk   (clk   ),
    .addr  (imAddr  ),
    .qdata (imQdata ),
    .ready (imInstReady )
);


wire [`WORD] dataAddress;
wire [`WORD] writeData, readData;
wire [ `MMD] memMode;
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
PipeCPU u_PipeCPU(
	.clk          (clk          ),
    .pc           (pc           ),
    .inst         (instruction  ),
    .instReady    (instReady),
    .dataAddress  (dataAddress  ),
    .writeMemData (writeData    ),
    .memRead      (memRead      ),
    .memWrite     (memWrite     ),
    .memMode      (memMode      ),
    .readMemData  (readData     )
);

endmodule // PipeSystem
