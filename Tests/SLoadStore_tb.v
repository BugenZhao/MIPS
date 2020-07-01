// -------------------------------------------------------
// -- System_tb.v
// -------------------------------------------------------
// Bugen Zhao 2020
// -------------------------------------------------------

`timescale 1ns / 1ps
`include "ISA.v"
`include "Debug.v"

module SLoadStore_tb;

parameter textDump = "/Users/bugenzhao/Developer/Codes/Verilog/MIPS/Resources/Products/LoadStore.mem";
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

    #500;
    `assert(`regFile[`T2], 'hffff8000);
    `assert(`regFile[`T3], 'h00008000);
    `assert(`regFile[`T4], 'hffffffff);
    `assert(`regFile[`T5], 'h000000ff);
    `assert(`regFile[`T6], 'hffff8090);
    
    $finish;
end

endmodule // SLoadStore_tb
