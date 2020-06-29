// -------------------------------------------------------
// -- InstMemory.v - Instruction memory
// -------------------------------------------------------
// Bugen Zhao 2020
// -------------------------------------------------------

`timescale 1ns / 1ps
`include "ISA.v"

module InstMemory #(parameter textDump = "path/to/text/dump") (
           input clk,
           input wire [ `WORD] addr,
           output reg [`QWORD] qdata,
           output reg          ready
       );

parameter memSize = 'h1ffff;
reg [`WORD] memFile[0:memSize];

initial begin: init
    integer i;
    for (i = 0; i < memSize; i++) begin
        memFile[i] = 0;
    end
    $readmemh(textDump, memFile);
    ready = 0;
end

wire [29:0] firstIndex = addr >> 4 << 2; // 4 instructions => 16 bytes per line
reg  [29:0] lineAddrBuffer = 0;

always @(posedge clk) begin
    if (lineAddrBuffer == firstIndex) begin
        ready <= 1;
        qdata <= { memFile[firstIndex], memFile[firstIndex + 1], memFile[firstIndex + 2], memFile[firstIndex + 3] };
    end
    else begin
        lineAddrBuffer <= firstIndex;
        ready <= 0;
        qdata <= 128'h0;
    end
end

endmodule
