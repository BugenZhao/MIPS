// -------------------------------------------------------
// -- InstMemory.v - Instruction memory
// -------------------------------------------------------
// Bugen Zhao 2020
// -------------------------------------------------------

`timescale 1ns / 1ps

module InstMemory(
           input wire  [31:0] pc,
           output wire [31:0] instruction
       );

parameter memSize = 'hfffff;
reg [31:0] memFile[0:memSize];

assign instruction = memFile[pc];

endmodule
