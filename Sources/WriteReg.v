// -------------------------------------------------------
// -- WriteReg.v - Decide which register to write
// -------------------------------------------------------
// Bugen Zhao 2020
// -------------------------------------------------------

`timescale 1ns / 1ps
`include "ISA.v"

module WriteReg(
           input wire [`WORD] instruction,
           output reg [ `REG] writeReg,
           output reg         writeLoHi
       );

wire [`OPC] opcode = `GET_OPC(instruction);
wire [`FUN] funct  = `GET_FUN(instruction);
wire [`REG] rt     = `GET_RT(instruction);
wire [`REG] rd     = `GET_RD(instruction);

always @(*) begin
    case (opcode)
        `OPC_SPECIAL: begin
            case (funct)
                `FUN_JR:   writeReg = 0;
                `FUN_JALR: writeReg = rd; // link, 31 implied
                default:   writeReg = rd;
            endcase
        end
        `OPC_ADDI, `OPC_ADDIU, `OPC_ANDI, `OPC_ORI, `OPC_XORI, `OPC_LUI, `OPC_SLTI, `OPC_SLTIU:
            writeReg = rt;
        `OPC_REGIMM: begin
            case (rt)
                `RT_BGEZAL, `RT_BLTZAL: writeReg = 31; // link
                default: writeReg = 0;
            endcase
        end
        `OPC_BGTZ, `OPC_BLEZ, `OPC_BEQ, `OPC_BNE:
            writeReg = 0;
        `OPC_LB, `OPC_LBU, `OPC_LH, `OPC_LHU, `OPC_LW:
            writeReg = rt;
        `OPC_SB, `OPC_SH, `OPC_SW:
            writeReg = 0;
        `OPC_J:
            writeReg = 0;
        `OPC_JAL: // link
            writeReg = 31;

        default: begin
            $warning("%m: opcode not recognized: %06b", opcode);
            writeReg = 5'bxxxxx;
        end
    endcase

    writeLoHi = opcode == `OPC_SPECIAL && (funct == `FUN_MULT || funct == `FUN_MULTU);
end

endmodule // WriteReg
