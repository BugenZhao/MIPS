// -------------------------------------------------------
// -- PipeSystem_tb.v
// -------------------------------------------------------
// Bugen Zhao 2020
// -------------------------------------------------------

`timescale 1ns / 1ps
`include "ISA.v"
`include "Debug.v"

module PSDataHazard_tb;

parameter textDump = "/Users/bugenzhao/Developer/Codes/Verilog/MIPS/Resources/Products/DataHazard.mem";
parameter PERIOD   = 10;

PipeSystem #(textDump, PERIOD) u_PipeSystem();

`define memFile u_PipeSystem.u_DataMemory.memFile
`define regFile u_PipeSystem.u_PipeCPU.u_RegisterFile.regFile

reg [`WORD] word;

initial begin: test
    integer i;

    $dumpfile("wave.vcd");
    $dumpvars;
    for (i = 1; i < 32; i++) $dumpvars(1, `regFile[i]);
    for (i = 0; i < 8; i++) $dumpvars(1, `memFile[i]);

    #1000;
    `assert(`regFile[`T1], 3);
    `assert(`regFile[`T2], 3);
    `assert(`regFile[`T3], 6);
    `assert(`regFile[`T4], 3);
    `assert(`regFile[`T5], 9);
    
    `assert(`memFile[3], 3);
    `assert(`memFile[7], 9);
    $finish;
end

endmodule // PSDataHazard_tb
