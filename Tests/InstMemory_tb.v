// -------------------------------------------------------
// -- InstMemory_tb.v
// -------------------------------------------------------
// Bugen Zhao 2020
// -------------------------------------------------------

`timescale 1ns / 1ps
`include "ISA.v"
`include "Debug.v"

module InstMemory_tb;

/*iverilog */
initial begin
    $dumpfile("wave.vcd");
    $dumpvars;
end
/*iverilog */

reg  [`WORD] pc;
wire [`WORD] instruction;


InstMemory #(.textDump ("/Users/bugenzhao/Developer/Codes/Verilog/MIPS/Resources/Products/Example.mem"))
u_InstMemory(
	.pc          (pc          ),
    .instruction (instruction )
);



initial begin
    #10 pc = 32'h0;
    #10 `assert(instruction, `EXAMPLE_ADD);
    #10 pc = pc + 4;
    #10 `assert(instruction, `EXAMPLE_ADDI);
    #10;
    $finish;
end


endmodule
