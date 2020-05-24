// -------------------------------------------------------
// -- WriteReg.v - Decide which register to write
// -------------------------------------------------------
// Bugen Zhao 2020
// -------------------------------------------------------

`timescale 1ns / 1ps
`include "ISA.v"

module WriteReg(
           input wire [31:0] instruction,
           output reg [ 4:0] writeReg
       );

wire [5:0] opcode = `GET_OPC(instruction);
wire [5:0] funct  = `GET_FUN(instruction);
wire [4:0] rt     = `GET_RT(instruction);
wire [4:0] rd     = `GET_RD(instruction);

always @(*) begin
    case (opcode)
        `OPC_SPECIAL: begin
            case (funct)
                `FUN_JR: writeReg = 0;
                default: writeReg = rd;
            endcase
        end
        `OPC_ADDI, `OPC_ADDIU, `OPC_ANDI, `OPC_ORI, `OPC_XORI, `OPC_LUI, `OPC_SLTI, `OPC_SLTIU:
            writeReg = rt;
        `OPC_REGIMM: begin
            case (rt)
                `RT_BGEZAL, `RT_BLTZAL: writeReg = 31;
                default: writeReg = 0;
            endcase
        end
        `OPC_BGTZ, `OPC_BLEZ, `OPC_BEQ, `OPC_BNE:
            writeReg = 0;
        `OPC_LB, `OPC_LBU, `OPC_LW:
            writeReg = rt;
        `OPC_SB, `OPC_SW:
            writeReg = 0;
        `OPC_J:
            writeReg = 0;
        `OPC_JAL:
            writeReg = 31;

        default: begin
            $warning("%m: opcode not recognized: %06b", opcode);
            writeReg = 5'bxxxxx;
        end
    endcase
end

endmodule // WriteReg
