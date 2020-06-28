// -------------------------------------------------------
// -- PipeSystem_tb.v
// -------------------------------------------------------
// Bugen Zhao 2020
// -------------------------------------------------------

`timescale 1ns / 1ps
`include "ISA.v"
`include "Debug.v"

module PSArithLogic_tb;

parameter textDump = "/Users/bugenzhao/Developer/Codes/Verilog/MIPS/Resources/Products/ArithLogic.mem";
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

    #500;
    `assert(`regFile[`T1], 'h88);
    `assert(`regFile[`T2], 'hef);
    `assert(`regFile[`T3], 'h10);
    `assert(`regFile[`T4], 'hff);
    `assert(`regFile[`T5], 'h10);
    `assert(`regFile[`T6], 'h1000);
    `assert(`regFile[`T7], 'h100000);
    
    $finish;
end

endmodule // PSArithLogic_tb
