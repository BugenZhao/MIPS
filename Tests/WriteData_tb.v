// -------------------------------------------------------
// -- WriteData_tb.v 
// -------------------------------------------------------
// Bugen Zhao 2020
// -------------------------------------------------------

`timescale 1ns / 1ps
`include "ISA.v"
`include "Debug.v"

module WriteData_tb;

/*iverilog */
initial begin
    $dumpfile("wave.vcd");
    $dumpvars;
end
/*iverilog */

reg [`WORD] instruction, aluOut, memoryOut, pc;
wire [`WORD] writeData;

WriteData u_WriteData(
	.pc          (pc          ),
    .instruction (instruction ),
    .aluOut      (aluOut      ),
    .memoryOut   (memoryOut   ),
    .writeData   (writeData   )
);




initial begin
    #100;
    pc = 0;
    instruction = `EXAMPLE_ADDI;
    aluOut = 88;
    memoryOut = 99;
    #100;
    `assert(writeData, 88);
    
    #100;
    pc = 4;
    instruction = `EXAMPLE_LW;
    aluOut = 88;
    memoryOut = 99;
    #100;
    `assert(writeData, 99);
    
    #100;
    pc = 12;
    instruction = `EXAMPLE_JAL;
    aluOut = 88;
    memoryOut = 99;
    #100;
    `assert(writeData, 12+4);
    
    $finish;
end


endmodule
