// -------------------------------------------------------
// -- System_tb.v
// -------------------------------------------------------
// Bugen Zhao 2020
// -------------------------------------------------------

`timescale 1ns / 1ps
`include "ISA.v"
`include "Debug.v"

module System_tb;

// parameter textDump = "/Users/bugenzhao/Developer/Codes/Verilog/MIPS/Resources/Products/Add.mem";
parameter textDump = "/Users/bugenzhao/Developer/Codes/Verilog/MIPS/Resources/Products/Accumulation.mem";
parameter PERIOD   = 10;

System #(textDump, PERIOD) u_System();

`define memFile u_System.u_DataMemory.memFile
`define regFile u_System.u_CPU.u_RegisterFile.regFile

initial begin: test
    integer i;

    $dumpfile("wave.vcd");
    $dumpvars;
    for (i = 1; i < 32; i++) $dumpvars(1, `regFile[i]);
    for (i = 0; i < 16; i++) $dumpvars(1, `memFile[i]);

    #2000;
    // word = {`memFile[8], `memFile[9], `memFile[10], `memFile[11]};
    // `assert(word, 32'hdeadbeef);
    `assert(`regFile[2], 45);
    `assert(`memFile[3], 45);
    $finish;
end

endmodule // System_tb
