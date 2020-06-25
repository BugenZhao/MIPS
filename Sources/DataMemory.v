// -------------------------------------------------------
// -- DataMemory.v - Data memory
// -------------------------------------------------------
// Bugen Zhao 2020
// -------------------------------------------------------

`timescale 1ns / 1ps
`include "ISA.v"

module DataMemory(
           input clk,
           input wire [31:0] address,
           input wire [31:0] writeData,
           input wire [ 1:0] mode,
           input wire        memRead,
           input wire        memWrite,
           output reg [31:0] readData
       );

parameter memSize = 'hfffff;
reg [7:0] memFile[0:memSize];

initial begin: init
    integer i;
    for (i = 0; i < memSize; i++) begin
        memFile[i] = 0;
    end
end

// FIXME: misaligned access should not be allowed

always @(negedge clk) begin
    if (memWrite) begin
        case (mode)
            `MEM_BYTE:
                memFile[address + 0] = writeData[ 7: 0];
            `MEM_HALF: begin
                memFile[address + 0] = writeData[15: 8];
                memFile[address + 1] = writeData[ 7: 0];
            end
            `MEM_WORD: begin
                memFile[address + 0] = writeData[31:24];
                memFile[address + 1] = writeData[23:16];
                memFile[address + 2] = writeData[15: 8];
                memFile[address + 3] = writeData[ 7: 0];
            end
        endcase
    end
end

always @(address, mode, memRead) begin
    if (memRead) begin
        case (mode)
            `MEM_BYTE:
                readData = {{24{1'b0}}, memFile[address]};
            `MEM_HALF:
                readData = {{16{1'b0}}, memFile[address], memFile[address + 1]};
            `MEM_WORD:
                readData = {memFile[address], memFile[address + 1], memFile[address + 2], memFile[address + 3]};
        endcase
    end
    else begin
        readData = 32'hxxxxxxxx;
    end
end
endmodule
