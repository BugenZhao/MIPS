// -------------------------------------------------------
// -- SignExtend_tb.v 
// -------------------------------------------------------
// Bugen Zhao 2020
// -------------------------------------------------------

`timescale 1ns / 1ps

module SignExtend_tb;

/*iverilog */
initial begin
    $dumpfile("wave.vcd");
    $dumpvars;
end
/*iverilog */

reg  signed [15:0] origin;
wire signed [31:0] extended;

SignExtend u_SignExtend(
	.origin   (origin   ),
    .extended (extended )
);


initial begin
    #100 origin = 'h6666;
    #100 origin = 'h7fff;
    #100 origin = 'h0000;
    #100 origin = 'haaaa;
    #100 origin = 'h8000;
    #100
    $finish;
end


endmodule
