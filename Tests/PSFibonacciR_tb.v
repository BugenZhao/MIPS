// -------------------------------------------------------
// -- PipeSystem_tb.v
// -------------------------------------------------------
// Bugen Zhao 2020
// -------------------------------------------------------

`timescale 1ns / 1ps
`include "ISA.v"
`include "Debug.v"

module PSFibonacciR_tb;

parameter textDump = "/Users/bugenzhao/Developer/Codes/Verilog/MIPS/Resources/Products/FibonacciR.mem";
parameter PERIOD   = 10;

PipeSystem #(textDump, PERIOD) u_PipeSystem();

`define memFile u_PipeSystem.u_DataMemory.memFile
`define regFile u_PipeSystem.u_PipeCPU.u_RegisterFile.regFile

initial begin: test
    $dumpfile("wave.vcd");
    $dumpvars;

    `memFile[3] = 10; // fibonacci[10] ...
    #150000;
    `assert(`memFile[7], 89); // == 89 ?

    $finish;
end

endmodule // PSFibonacciR_tb
