// -------------------------------------------------------
// -- System_tb.v
// -------------------------------------------------------
// Bugen Zhao 2020
// -------------------------------------------------------

`timescale 1ns / 1ps
`include "ISA.v"
`include "Debug.v"

module System_tb;

parameter textDump = "/Users/bugenzhao/Developer/Codes/Verilog/MIPS/Resources/Products/Accumulation.mem";
parameter PERIOD   = 10;

System #(textDump, PERIOD) u_System();

initial begin: test
    integer i;

    $dumpfile("wave.vcd");
    $dumpvars;
    $dumpvars(0, u_System.u_CPU.u_RegisterFile.regFile[4]);
    $dumpvars(0, u_System.u_CPU.u_RegisterFile.regFile[8]);
    for (i = 0; i < 'h10; i++) begin
        $dumpvars(0, u_System.u_DataMemory.memFile[i]);
    end

    #2000;
    `define memFile u_System.u_DataMemory.memFile
    `assert(`memFile[3], 45);
    $finish;
end

endmodule // System_tb
