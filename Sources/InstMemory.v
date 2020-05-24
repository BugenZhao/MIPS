// -------------------------------------------------------
// -- InstMemory.v - Instruction memory
// -------------------------------------------------------
// Bugen Zhao 2020
// -------------------------------------------------------

`timescale 1ns / 1ps

module InstMemory #(parameter textDump = "path/to/text/dump") (
           input wire  [31:0] pc,
           output wire [31:0] instruction
       );

parameter memSize = 'h1ffff;
reg [31:0] memFile[0:memSize];

initial begin: init
    integer i;
    for (i = 0; i < memSize; i++) begin
        memFile[i] = 0;
    end
    $readmemh(textDump, memFile);
end

assign instruction = memFile[pc >> 2];

endmodule
