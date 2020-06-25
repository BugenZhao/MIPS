// -------------------------------------------------------
// -- CPU.v - MIPS CPU
// -------------------------------------------------------
// Bugen Zhao 2020
// -------------------------------------------------------

`timescale 1ns / 1ps

module CPU(
           input clk,
           output wire [31:0] pc,
           input  wire [31:0] inst,
           output wire [31:0] dataAddress, writeMemData,
           output wire        memRead, memWrite,
           output wire [ 1:0] memMode,
           input  wire [31:0] readMemData 
       );


// --- IF ---
wire [31:0] newPC;
PC u_PC(
	.clk   (clk   ),
    .newPC (newPC ),
    .pc    (pc    )
);


// --- ID & WB ---
wire [ 4:0] writeReg;
wire [31:0] writeData;
wire [31:0] readData1, readData2;
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

wire [31:0] extendedImm;
SignExtend u_SignExtend(
	.origin   (inst[15:0]  ),
    .extended (extendedImm )
);


// --- EX ---
wire [31:0] opA, opB;
Operator u_Operator(
	.instruction (inst        ),
    .rsData      (readData1   ),
    .rtData      (readData2   ),
    .extendedImm (extendedImm ),
    .opA         (opA         ),
    .opB         (opB         )
);

wire [5:0] aluFunct;
ALUFunct u_ALUFunct(
	.opcode   (inst[31:26] ),
    .funct    (inst[5:0]   ),
    .aluFunct (aluFunct    )
);

wire [31:0] aluOut;
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
