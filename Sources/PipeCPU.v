// -------------------------------------------------------
// -- PipeCPU.v - Pipelined MIPS CPU
// -------------------------------------------------------
// Bugen Zhao 2020
// -------------------------------------------------------

`timescale 1ns / 1ps
`include "ISA.v"

module PipeCPU(
           input clk,

           output wire [`WORD] pc,
           input  wire [`WORD] inst,

           output wire [`WORD] dataAddress, writeMemData,
           output wire         memRead, memWrite,
           output wire [ `MMD] memMode,
           input  wire [`WORD] readMemData
       );

// --- IF ---
wire [`WORD] newPC;
PC u_PC(
	.clk   (clk),
    .newPC (newPC),
    .pc    (pc)
);


// --- IF/ID ---
wire idFlush;
wire [`WORD] idNewPC, idInst;
StageRegID u_StageRegID(
	.clk           (clk),
    .ifNewPC       (pc + 4),
    .ifInstruction (inst),
    .flush         (idFlush),
    .idNewPC       (idNewPC),
    .idInstruction (idInst)
);


// --- ID ---
wire [ `REG] wbWriteReg;
wire [`WORD] wbWriteData;
wire [`WORD] idReg1, idReg2;
RegisterFile u_RegisterFile(
	.clk       (clk),
    .readReg1  (`GET_RS(idInst)),
    .readReg2  (`GET_RT(idInst)),
    .writeReg  (wbWriteReg),
    .writeData (wbWriteData),
    .regWrite  (1'b1),
    .readData1 (idReg1),
    .readData2 (idReg2)
);

wire [`WORD] idExtendedImm;
SignExtend u_SignExtend(
	.origin   (idInst[15:0]),
    .extended (idExtendedImm)
);


// --- ID/EX ---
wire exFlush;
wire [`WORD] exNewPC, exInst, exReg1, exReg2, exExtendedImm;
StageRegEX u_StageRegEX(
	.clk           (clk),
    .idNewPC       (idNewPC),
    .idInstruction (idInst),
    .idReg1        (idReg1),
    .idReg2        (idReg2),
    .idExtendedImm (idExtendedImm),
    .flush         (exFlush),
    .exNewPC       (exNewPC),
    .exInstruction (exInst),
    .exReg1        (exReg1),
    .exReg2        (exReg2),
    .exExtendedImm (exExtendedImm)
);


// --- EX ---
wire [`WORD] exOpA, exOpB;
wire         rsFwd, rtFwd;
wire [`WORD] rsFwdData, rtFwdData;
wire [`WORD] exWriteToMemData;
Operand u_Operand(
	.instruction  (exInst),
    .rsData       (exReg1),
    .rtData       (exReg2),
    .extendedImm  (exExtendedImm),
    .rsFwd        (rsFwd),
    .rtFwd        (rtFwd),
    .rsFwdData    (rsFwdData),
    .rtFwdData    (rtFwdData),
    .opA          (exOpA),
    .opB          (exOpB),
    .writeToMemData (exWriteToMemData)
);

wire [`FUN] exALUFunct;
ALUFunct u_ALUFunct(
	.opcode   (`GET_OPC(exInst)),
    .funct    (`GET_FUN(exInst)),
    .aluFunct (exALUFunct)
);

wire [`WORD] exALUOut;
wire exALUZero;
ALU u_ALU(
	.opA      (exOpA),
    .opB      (exOpB),
    .aluFunct (exALUFunct),
    .out      (exALUOut),
    .zero     (exALUZero)
);

wire [`REG] exWriteReg;
WriteReg u_WriteReg(
	.instruction (exInst),
    .writeReg    (exWriteReg)
);

wire exTaken;
wire [`WORD] exBranchAddr;
Taken u_Taken(
	.instruction (exInst),
    .newPC       (exNewPC),
    .extendedImm (exExtendedImm),
    .aluZero     (exALUZero),
    .taken       (exTaken),
    .branchAddr  (exBranchAddr)
);

wire exMemRead, exMemWrite;
wire [`MMD] exMemMode;
MemControl u_MemControl(
	.instruction (exInst),
    .memRead     (exMemRead),
    .memWrite    (exMemWrite),
    .mode        (exMemMode)
);

wire exIsJumpReg;
JumpReg u_JumpReg(
	.instruction (exInst),
    .isJumpReg   (exIsJumpReg)
);



// --- EX/MEM ---
wire [`WORD] memNewPC, memInst, memALUOut, memWriteToMemData;
wire [`REG]  memWriteReg;
wire         memMemRead, memMemWrite;
wire [`MMD]  memMemMode;
StageRegMEM u_StageRegMEM(
	.clk               (clk),
    .exNewPC           (exNewPC),
    .exInstruction     (exInst),
    .exALUOut          (exALUOut),
    .exWriteToMemData  (exWriteToMemData),
    .exWriteReg        (exWriteReg),
    .exMemRead         (exMemRead),
    .exMemWrite        (exMemWrite),
    .exMemMode         (exMemMode),
    .memNewPC          (memNewPC),
    .memInstruction    (memInst),
    .memALUOut         (memALUOut),
    .memWriteToMemData (memWriteToMemData),
    .memWriteReg       (memWriteReg),
    .memMemRead        (memMemRead),
    .memMemWrite       (memMemWrite),
    .memMemMode        (memMemMode)
);


// --- MEM ---
assign dataAddress = memALUOut;
assign writeMemData = memWriteToMemData;
assign memRead = memMemRead;
assign memWrite = memMemWrite;
assign memMode = memMemMode;


// --- MEM/WB ---
wire [`WORD] wbNewPC, wbInst, wbALUOut, wbMemOut;
wire wbMemRead;
StageRegWB u_StageRegWB(
	.clk            (clk),
    .memNewPC       (memNewPC),
    .memInstruction (memInst),
    .memALUOut      (memALUOut),
    .memMemOut      (readMemData),
    .memWriteReg    (memWriteReg),
    .memMemRead     (memMemRead),
    .wbNewPC        (wbNewPC),
    .wbInstruction  (wbInst),
    .wbALUOut       (wbALUOut),
    .wbMemOut       (wbMemOut),
    .wbWriteReg     (wbWriteReg),
    .wbMemRead      (wbMemRead)
);


// --- WB ---
WriteData u_WriteData(
	.pc          (wbNewPC),
    .instruction (wbInst),
    .aluOut      (wbALUOut),
    .memoryOut   (wbMemOut),
    .writeData   (wbWriteData)
);


// --- New PC ---
wire stall;
NewPC u_NewPC(
	.pc          (pc),
    .instruction (inst),
    .jumpRegAddr (exOpA),
    .isJumpReg   (exIsJumpReg),
    .branchAddr  (exBranchAddr),
    .taken       (exTaken),
    .stall       (stall),
    .newPC       (newPC),
    .flushID     (idFlush),
    .flushEX     (exFlush)
);


// --- Pipe Control ---
Forward u_Forward(
	.memWriteReg    (memWriteReg),
    .wbWriteReg     (wbWriteReg),
    .memMemRead     (memMemRead),
    .wbMemRead      (wbMemRead),
    .memALUOut      (memALUOut),
    .wbALUOut       (wbALUOut),
    .wbMemOut       (wbMemOut),
    .memNewPC       (memNewPC),
    .wbNewPC        (wbNewPC),
    .exInstruction  (exInst),
    .memInstruction (memInst),
    .wbInstruction  (wbInst),
    .rsFwd          (rsFwd),
    .rtFwd          (rtFwd),
    .rsFwdData      (rsFwdData),
    .rtFwdData      (rtFwdData)
);

Stall u_Stall(
	.exMemRead     (exMemRead),
    .exWriteReg    (exWriteReg),
    .idInstruction (idInst),
    .stall         (stall)
);


endmodule // PipeCPU
