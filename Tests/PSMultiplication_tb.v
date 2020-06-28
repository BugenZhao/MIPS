// -------------------------------------------------------
// -- PipeSystem_tb.v
// -------------------------------------------------------
// Bugen Zhao 2020
// -------------------------------------------------------

`timescale 1ns / 1ps
`include "ISA.v"
`include "Debug.v"

module PSMultiplication_tb;

parameter textDump = "/Users/bugenzhao/Developer/Codes/Verilog/MIPS/Resources/Products/Multiplication.mem";
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
    $dumpvars(u_PipeSystem.u_PipeCPU.u_RegisterFile.hi);
    $dumpvars(u_PipeSystem.u_PipeCPU.u_RegisterFile.lo);

    `wordAt(0) = 111111;
    `wordAt(4) = 222222;
    #300;
    `assert(`dwordAt(8), 64'd24_691_308_642);
    $finish;
end

endmodule // PSMultiplication_tb
