// -------------------------------------------------------
// -- WriteReg_tb.v 
// -------------------------------------------------------
// Bugen Zhao 2020
// -------------------------------------------------------

`timescale 1ns / 1ps
`include "ISA.v"
`include "Debug.v"

module WriteReg_tb;

/*iverilog */
initial begin
    $dumpfile("wave.vcd");
    $dumpvars;
end
/*iverilog */

reg [`WORD] instruction;
wire [`REG] writeReg;

WriteReg u_WriteReg(
	.instruction (instruction ),
    .writeReg    (writeReg    )
);


initial begin
    #100 instruction = `EXAMPLE_ADDI;
    #100 `assert(writeReg, `T0);

    #100 instruction = `EXAMPLE_LB;
    #100 `assert(writeReg, `T1);

    #100 instruction = `EXAMPLE_JAL;
    #100 `assert(writeReg, `RA);

    #100 instruction = `EXAMPLE_SB;
    #100 `assert(writeReg, `ZERO);
    
    $finish;
end


endmodule
