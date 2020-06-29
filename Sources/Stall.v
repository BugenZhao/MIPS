// -------------------------------------------------------
// -- Stall.v - Decide load & use hazard
// -------------------------------------------------------
// Bugen Zhao 2020
// -------------------------------------------------------

`timescale 1ns / 1ps
`include "ISA.v"

module Stall(
           input wire         exMemRead,
           input wire [ `REG] exWriteReg,
           input wire [`WORD] idInstruction,

           output wire        stall
       );

wire [`REG] idRs = `GET_RS(idInstruction);
wire [`REG] idRt = `GET_RT(idInstruction);

wire useRs, useRt;
RegUse u_RegUse(
           .instruction (idInstruction),
           .useRs       (useRs),
           .useRt       (useRt)
       );

assign stall = exMemRead && ((useRs && exWriteReg == idRs) || (useRt && exWriteReg == idRt));

endmodule // Stall
