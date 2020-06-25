// -------------------------------------------------------
// -- SignExtend.v - Sign extend a 16-bit number to 32-bit
// -------------------------------------------------------
// Bugen Zhao 2020
// -------------------------------------------------------

`timescale 1ns / 1ps
`include "ISA.v"

module SignExtend(
           input wire  [15: 0] origin,
           output wire [`WORD] extended
       );

assign extended = { {16{origin[15]}}, origin };

endmodule
