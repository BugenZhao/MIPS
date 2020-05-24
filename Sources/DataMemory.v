// -------------------------------------------------------
// -- DataMemory.v - Data memory
// -------------------------------------------------------
// Bugen Zhao 2020
// -------------------------------------------------------

`timescale 1ns / 1ps

module DataMemory(
           input clk,
           input wire  [31:0] address,
           input wire  [31:0] writeData,
           input wire         memRead,
           input wire         memWrite,
           output wire [31:0] readData
       );

parameter memSize = 'hfffff;
reg [31:0] memFile[0:memSize];

always @(negedge clk) begin
    if (memWrite) memFile[address] <= writeData;
end

assign readData = memRead ? memFile[address] : 0;

endmodule
