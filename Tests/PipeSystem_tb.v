// -------------------------------------------------------
// -- PipeSystem_tb.v
// -------------------------------------------------------
// Bugen Zhao 2020
// -------------------------------------------------------

`timescale 1ns / 1ps
`include "ISA.v"
`include "Debug.v"

module PipeSystem_tb;

parameter textDump = "/Users/bugenzhao/Developer/Codes/Verilog/MIPS/Resources/Products/Accumulation.mem";
parameter PERIOD   = 10;

PipeSystem #(textDump, PERIOD) u_PipeSystem();

`define memFile u_PipeSystem.u_DataMemory.memFile
`define regFile u_PipeSystem.u_PipeCPU.u_RegisterFile.regFile

initial begin: test
    integer i;

    $dumpfile("wave.vcd");
    $dumpvars;
    for (i = 1; i < 32; i++) $dumpvars(1, `regFile[i]);
    for (i = 0; i < 16; i++) $dumpvars(1, `memFile[i]);

    #1500;
    `assert(`memFile[3], 45);
    $finish;
end

endmodule // PipeSystem_tb
