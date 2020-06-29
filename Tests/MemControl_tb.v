// -------------------------------------------------------
// -- MemControl_tb.v 
// -------------------------------------------------------
// Bugen Zhao 2020
// -------------------------------------------------------

`timescale 1ns / 1ps
`include "ISA.v"
`include "Debug.v"

module MemControl_tb;

/*iverilog */
initial begin
    $dumpfile("wave.vcd");
    $dumpvars;
end
/*iverilog */

reg [`WORD] instruction;
wire memRead, memWrite;
wire [1:0] mode;

MemControl u_MemControl(
	.instruction (instruction ),
    .memRead     (memRead     ),
    .memWrite    (memWrite    ),
    .mode        (mode        )
);



initial begin
    #100 instruction = `EXAMPLE_LW;
    #100;
    `assert(memRead, 1);
    `assert(memWrite, 0);
    `assert(mode, `MEM_WORD);

    #100 instruction = `EXAMPLE_SH;
    #100;
    `assert(memRead, 0);
    `assert(memWrite, 1);
    `assert(mode, `MEM_HALF);

    #100 instruction = `EXAMPLE_SB;
    #100;
    `assert(memRead, 0);
    `assert(memWrite, 1);
    `assert(mode, `MEM_BYTE);
    
    $finish;
end


endmodule
