// -------------------------------------------------------
// -- Cache.v - Cache for instruction memory
// -------------------------------------------------------
// Bugen Zhao 2020
// -------------------------------------------------------

`timescale 1ns / 1ps
`include "ISA.v"

module Cache (
           input wire [`WORD] pc,
           output reg [`WORD] inst,
           output reg         instReady,

           output reg [ `WORD] imAddr,
           input wire [`QWORD] imQdata,
           input wire          imInstReady
       );

`define ADDR_OFFSET   3:2
`define ADDR_INDEX    9:4
`define ADDR_TAG     31:10

reg [`WORD] blocks[0:63][0:3];
reg [21: 0] tags  [0:63];
reg         valid [0:63];

initial begin: init
    integer i, j;
    for (i = 0; i < 64; i = i + 1) begin
        tags[i] = 0;
        valid[i] = 0;
        for (j = 0; j < 4; j = j + 1) begin
            blocks[i][j] = 0;
        end
    end
    instReady = 0;
end

wire [1:0] offset = pc[`ADDR_OFFSET];
wire [5:0] index = pc[`ADDR_INDEX];
wire [24:0] tag  = pc[`ADDR_TAG];

reg [1:0] hit;

always @(pc, offset, index, tag, imInstReady, imQdata) begin
    if (tags[index] == tag && valid[index] == 1) begin
        instReady = 1;
        inst = blocks[index][offset];
        hit = 1;
    end
    else begin
        if (imInstReady == 1 && imAddr[31:4] == pc[31:4]) begin
            {blocks[index][0], blocks[index][1], blocks[index][2], blocks[index][3]} = imQdata;
            valid[index] = 1;
            tags[index] = tag;
            instReady = 1;
            inst = blocks[index][offset];
            hit = 2;
        end
        else begin
            imAddr = pc;
            valid[index] = 0;
            instReady = 0;
            inst = 32'h0;
            hit = 0;
        end
    end
end


endmodule // Cache
