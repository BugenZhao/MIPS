`include "ISA.v"
`include "Debug.v"

module test;

`iverilog_init

wire [5:0] test;
assign test = `FUNCT_ADD;

endmodule
