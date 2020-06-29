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

reg clk;
reg [`WORD] addr;
wire [`QWORD] qdata;
wire ready;

parameter PERIOD = 100;
always #(PERIOD) clk = !clk;

InstMemory #("/Users/bugenzhao/Developer/Codes/Verilog/MIPS/Resources/Products/Example.mem")
u_InstMemory(
	.clk   (clk   ), // update on posedge
    .addr  (addr  ),
    .qdata (qdata ),
    .ready (ready )
);

initial begin
    clk = 0;
    #20;  // 20
    addr = 'h14;
    #100; // 120 => posedge, reading
    `assert(ready, 0);
    #100; // 220
    `assert(ready, 0);
    #100; // 320 => posedge, done
    `assert(ready, 1);
    `assert(qdata, 128'h012a4024_31280008_012a4022_00094100);
    #200;
    $finish;
end


endmodule
