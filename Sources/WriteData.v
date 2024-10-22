// -------------------------------------------------------
// -- WriteData.v - Decide which data to write back
// -------------------------------------------------------
// Bugen Zhao 2020
// -------------------------------------------------------

`timescale 1ns / 1ps
`include "ISA.v"

module WriteData(
           input wire [`WORD] pc,
           input wire [`WORD] instruction,
           input wire [`WORD] aluOut, memoryOut,
           output reg [`WORD] writeData
       );

wire [`OPC] opcode = `GET_OPC(instruction);
wire [`FUN] funct  = `GET_FUN(instruction);
wire [`REG] rt     = `GET_RT(instruction);

always @(*) begin
    case (opcode)
        `OPC_LB:
            writeData = {{24{memoryOut[7]}}, memoryOut[7:0]};
        `OPC_LBU:
            writeData = {{24{1'b0}}, memoryOut[7:0]};
        `OPC_LH:
            writeData = {{16{memoryOut[15]}}, memoryOut[15:0]};
        `OPC_LHU:
            writeData = {{16{1'b0}}, memoryOut[15:0]};
        `OPC_LW:
            writeData = memoryOut;
        `OPC_REGIMM: begin
            case (rt)
                `RT_BGEZAL, `RT_BLTZAL: writeData = pc + 4; // link
                default: writeData = aluOut; // actually no data
            endcase
        end
        `OPC_JAL: // link
            writeData = pc + 4;
        `OPC_SPECIAL: begin
            case (funct)
                `FUN_JALR: writeData = pc + 4; // link
                default:   writeData = aluOut;
            endcase
        end
        default:
            writeData = aluOut;
    endcase
end

endmodule // WriteData
