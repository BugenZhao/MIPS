// -------------------------------------------------------
// -- InstMemory.v - Instruction memory
// -------------------------------------------------------
// Bugen Zhao 2020
// -------------------------------------------------------

`timescale 1ns / 1ps
`include "ISA.v"

module InstMemory #(parameter textDump = "path/to/text/dump") (
           input clk,
           input wire [`WORD] pc,
           output reg [`WORD] instruction,
           output reg         instReady
       );

parameter memSize = 'h1ffff;
reg [`WORD] memFile[0:memSize];

initial begin: init
    integer i;
    for (i = 0; i < memSize; i++) begin
        memFile[i] = 0;
    end
    $readmemh(textDump, memFile);
    instReady = 0;
end

reg [`WORD] pcBuffer = 32'h00000000;

always @(posedge clk) begin
    if (pcBuffer == pc) begin
        instReady <= 1;
        instruction <= memFile[pc >> 2];
    end else begin
        pcBuffer <= pc;
        instReady <= 0;
        instruction <= 32'h00000000;
    end
end

endmodule
