// -------------------------------------------------------
// -- InstMemory.v - Instruction memory
// -------------------------------------------------------
// Bugen Zhao 2020
// -------------------------------------------------------

`timescale 1ns / 1ps
`include "ISA.v"

module InstMemory #(parameter textDump = "path/to/text/dump") (
           input wire  [`WORD] pc,
           output wire [`WORD] instruction
       );

parameter memSize = 'h1ffff;
reg [`WORD] memFile[0:memSize];

initial begin: init
    integer i;
    for (i = 0; i < memSize; i++) begin
        memFile[i] = 0;
    end
    $readmemh(textDump, memFile);
end

assign instruction = memFile[pc >> 2];

endmodule
