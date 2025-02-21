// -------------------------------------------------------
// -- System_tb.v
// -------------------------------------------------------
// Bugen Zhao 2020
// -------------------------------------------------------

`timescale 1ns / 1ps
`include "ISA.v"
`include "Debug.v"

module SArithLogic_tb;

parameter textDump = "/Users/bugenzhao/Developer/Codes/Verilog/MIPS/Resources/Products/ArithLogic.mem";
parameter PERIOD   = 10;

System #(textDump, PERIOD) u_System();

`define memFile u_System.u_DataMemory.memFile
`define regFile u_System.u_CPU.u_RegisterFile.regFile

reg [`WORD] word;

initial begin: test
    integer i;

    $dumpfile("wave.vcd");
    $dumpvars;
    for (i = 1; i < 32; i = i + 1) $dumpvars(1, `regFile[i]);

    #1000;
    `assert(`regFile[`T1], 'h88);
    `assert(`regFile[`T2], 'hef);
    `assert(`regFile[`T3], 'h10);
    `assert(`regFile[`T4], 'hff);
    `assert(`regFile[`T5], 'h10);
    `assert(`regFile[`T6], 'h1000);
    `assert(`regFile[`T7], 'h100000);
    
    $finish;
end

endmodule // SArithLogic_tb
