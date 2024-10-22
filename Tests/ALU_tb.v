// -------------------------------------------------------
// -- ALU_tb.v
// -------------------------------------------------------
// Bugen Zhao 2020
// -------------------------------------------------------

`timescale 1ns / 1ps
`include "ISA.v"
`include "Debug.v"

module ALU_tb;
initial begin
    $dumpfile("wave.vcd");
    $dumpvars;
end


reg [`WORD] inst;
wire [`FUN] aluFunct;

ALUFunct u_ALUFunct(
             .opcode   (inst[31:26]),
             .funct    (inst[`FUN]),
             .aluFunct (aluFunct )
         );

reg [`WORD] opA, opB;
wire [`WORD] out;
wire zero;

ALU u_ALU(
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
    inst = `EXAMPLE_SLL;
    opA = inst[10:6]; // shamt: 0x4
    opB = 'h01234567;
    #10 `assert(out, 'h12345670);

    #10;
    inst = `EXAMPLE_SRAV;
    opA = 4;
    opB = -32;
    #10 `assert(out, -2);

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
    #10 `assert(out, 32'hxxxxxxxx);

    #10;
    inst = `EXAMPLE_LUI;
    opB = inst[15:0]; // 0x1234
    #10 `assert(out, 32'h12340000);

    #10 $finish;
end

endmodule
