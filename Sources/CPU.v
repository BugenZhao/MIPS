// -------------------------------------------------------
// -- CPU.v - MIPS CPU
// -------------------------------------------------------
// Bugen Zhao 2020
// -------------------------------------------------------

`timescale 1ns / 1ps
`include "ISA.v"

module CPU(
           input clk,
           output wire [`WORD] pc,
           input  wire [`WORD] inst,
           output wire [`WORD] dataAddress, writeMemData,
           output wire        memRead, memWrite,
           output wire [ `MMD] memMode,
           input  wire [`WORD] readMemData 
       );


// --- IF ---
wire [`WORD] newPC;
PC u_PC(
	.clk   (clk   ),
    .newPC (newPC ),
    .pc    (pc    )
);


// --- ID & WB ---
wire [ `REG] writeReg;
wire [`WORD] writeData;
wire [`WORD] readData1, readData2;
RegisterFile u_RegisterFile(
	.clk       (clk         ),
    .readReg1  (inst[25:21] ),
    .readReg2  (inst[20:16] ),
    .writeReg  (writeReg    ),
    .writeData (writeData   ),
    .regWrite  (1'b1        ),
    .readData1 (readData1   ),
    .readData2 (readData2   )
);

WriteReg u_WriteReg(
	.instruction (inst     ),
    .writeReg    (writeReg )
);

wire [`WORD] extendedImm;
SignExtend u_SignExtend(
	.origin   (inst[15:0]  ),
    .extended (extendedImm )
);


// --- EX ---
wire [`WORD] opA, opB;
Operator u_Operator(
	.instruction (inst        ),
    .rsData      (readData1   ),
    .rtData      (readData2   ),
    .extendedImm (extendedImm ),
    .opA         (opA         ),
    .opB         (opB         )
);

wire [`FUN] aluFunct;
ALUFunct u_ALUFunct(
	.opcode   (inst[31:26] ),
    .funct    (inst[5:0]   ),
    .aluFunct (aluFunct    )
);

wire [`WORD] aluOut;
wire aluZero;
ALU u_ALU(
	.opA      (opA      ),
    .opB      (opB      ),
    .aluFunct (aluFunct ),
    .out      (aluOut   ),
    .zero     (aluZero  )
);

wire taken;
Taken u_Taken(
	.instruction (inst    ),
    .aluZero     (aluZero ),
    .taken       (taken   )
);


// --- MEM ---
assign dataAddress = aluOut;
assign writeMemData = readData2; // (Reg file's rt)
MemControl u_MemControl(
	.instruction (inst     ),
    .memRead     (memRead  ),
    .memWrite    (memWrite ),
    .mode        (memMode  )
);

WriteData u_WriteData(
	.pc          (pc          ),
    .instruction (inst        ),
    .aluOut      (aluOut      ),
    .memoryOut   (readMemData ),
    .writeData   (writeData   )
);


// --- NewPC ---
NewPC u_NewPC(
	.pc          (pc          ),
    .instruction (inst        ),
    .jumpRegAddr (readData1   ),
    .extendedImm (extendedImm ),
    .taken       (taken       ),
    .newPC       (newPC       )
);

endmodule
