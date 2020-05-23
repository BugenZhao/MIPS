// -------------------------------------------------------
// -- Alu_tb.v
// -------------------------------------------------------
// Bugen Zhao 2020
// -------------------------------------------------------

`timescale 1ns / 1ps
`include "ISA.v"
`include "Debug.v"

module Alu_tb;
initial begin
    $dumpfile("wave.vcd");
    $dumpvars;
end


reg [31:0] inst;
wire [5:0] aluFunct;

AluFunct u_AluFunct(
             .opcode   (inst[31:26]),
             .funct    (inst[5:0]),
             .aluFunct (aluFunct )
         );

reg [31:0] opA, opB;
wire [31:0] out;
wire zero;

Alu u_Alu(
        .opA      (opA      ),
        .opB      (opB      ),
        .aluFunct (aluFunct ),
        .out      (out      ),
        .zero     (zero     )
    );


initial begin
    #10;
    inst = `EXAMPLE_ADD;
    opA = 'hdead0000;
    opB = 'h0000beef;
    #10 `assert(out, 'hdeadbeef);

    #10;
    inst = `EXAMPLE_SUB;
    opA = 'hdeadbeef;
    opB = 'h0000beef;
    #10 `assert(out, 'hdead0000);

    #10;
    inst = `EXAMPLE_AND;
    opA = 'hdeadbeef;
    opB = 'hf0f0f0f0;
    #10 `assert(out, 'hd0a0b0e0);

    #10;
    inst = `EXAMPLE_SLT;
    opA = 1;
    opB = 2;
    #10 `assert(out, 1);

    #10;
    inst = `EXAMPLE_SLT;
    opA = 1;
    opB = 2;
    #10 `assert(out, 1);

    #10;
    inst = `EXAMPLE_BGEZ;
    opA = 3;
    opB = 4;
    #10 `assert(out, 1);

    #10;
    inst = `EXAMPLE_BEQ;
    opA = 8;
    opB = 4;
    #10 `assert(out, 4);

    #10;
    inst = `EXAMPLE_J;
    opA = 888888;
    opB = 0;
    #10 `assert(out, 32'hxxxxxx);

    #10 $finish;
end

endmodule
