// -------------------------------------------------------
// -- SignExtend.v - Sign extend a 16-bit number to 32-bit
// -------------------------------------------------------
// Bugen Zhao 2020
// -------------------------------------------------------

`timescale 1ns / 1ps

module SignExtend(
           input wire  [15:0] origin,
           output wire [31:0] extended
       );

assign extended = { {16{origin[15]}}, origin };

endmodule
