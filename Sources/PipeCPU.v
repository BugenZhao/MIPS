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
wire stall;
wire [`WORD] idNextPC, idInst;
StageRegID u_StageRegID(
	.clk           (clk),
    .ifNextPC       (pc + 4),
    .ifInstruction (inst),
    .flush         (idFlush),
    .stall          (stall),
    .idNextPC       (idNextPC),
    .idInstruction (idInst)
);


// --- ID ---
wire [ `REG] wbWriteReg;
wire [`WORD] wbWriteData;
wire [`WORD] wbALUOutHi;
wire         wbWriteLoHi;
wire [`WORD] idReg1, idReg2;
RegisterFile u_RegisterFile(
	.clk       (clk),
    .opcode    (`GET_OPC(idInst)),
    .funct     (`GET_FUN(idInst)),
    .readReg1  (`GET_RS(idInst)),
    .readReg2  (`GET_RT(idInst)),
    .writeReg  (wbWriteReg),
    .writeLoHi (wbWriteLoHi),
    .writeData (wbWriteData),
    .writeDataHi (wbALUOutHi),
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
wire [`WORD] exNextPC, exInst, exReg1, exReg2, exExtendedImm;
StageRegEX u_StageRegEX(
	.clk           (clk),
    .idNextPC       (idNextPC),
    .idInstruction (idInst),
    .idReg1        (idReg1),
    .idReg2        (idReg2),
    .idExtendedImm (idExtendedImm),
    .flush         (exFlush),
    .exNextPC       (exNextPC),
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

wire [`WORD] exALUOut, exALUOutHi;
wire exALUZero;
ALU u_ALU(
	.opA      (exOpA),
    .opB      (exOpB),
    .aluFunct (exALUFunct),
    .out      (exALUOut),
    .outHi    (exALUOutHi),
    .zero     (exALUZero)
);

wire [`REG] exWriteReg;
wire exWriteLoHi;
WriteReg u_WriteReg(
	.instruction (exInst),
    .writeReg    (exWriteReg),
    .writeLoHi   (exWriteLoHi)
);

wire exTaken;
wire [`WORD] exBranchAddr;
Taken u_Taken(
	.instruction (exInst),
    .nextPC       (exNextPC),
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
wire [`WORD] memNextPC, memInst, memALUOut, memALUOutHi, memWriteToMemData;
wire [`REG]  memWriteReg;
wire         memWriteLoHi;
wire         memMemRead, memMemWrite;
wire [`MMD]  memMemMode;
StageRegMEM u_StageRegMEM(
	.clk               (clk),
    .exNextPC          (exNextPC),
    .exInstruction     (exInst),
    .exALUOut          (exALUOut),
    .exALUOutHi        (exALUOutHi),
    .exWriteToMemData  (exWriteToMemData),
    .exWriteReg        (exWriteReg),
    .exWriteLoHi       (exWriteLoHi),
    .exMemRead         (exMemRead),
    .exMemWrite        (exMemWrite),
    .exMemMode         (exMemMode),
    .memNextPC         (memNextPC),
    .memInstruction    (memInst),
    .memALUOut         (memALUOut),
    .memALUOutHi       (memALUOutHi),
    .memWriteToMemData (memWriteToMemData),
    .memWriteReg       (memWriteReg),
    .memWriteLoHi      (memWriteLoHi),
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
wire [`WORD] wbNextPC, wbInst, wbALUOut, wbMemOut;
wire wbMemRead;
StageRegWB u_StageRegWB(
	.clk            (clk),
    .memNextPC      (memNextPC),
    .memInstruction (memInst),
    .memALUOut      (memALUOut),
    .memALUOutHi    (memALUOutHi),
    .memMemOut      (readMemData),
    .memWriteReg    (memWriteReg),
    .memMemRead     (memMemRead),
    .memWriteLoHi   (memWriteLoHi),
    .wbNextPC       (wbNextPC),
    .wbInstruction  (wbInst),
    .wbALUOut       (wbALUOut),
    .wbALUOutHi     (wbALUOutHi),
    .wbMemOut       (wbMemOut),
    .wbWriteReg     (wbWriteReg),
    .wbMemRead      (wbMemRead),
    .wbWriteLoHi    (wbWriteLoHi)
);


// --- WB ---
WriteData u_WriteData(
	.pc          (wbNextPC - 4), // SHOULD BE CURRENT PC
    .instruction (wbInst),
    .aluOut      (wbALUOut),
    .memoryOut   (wbMemOut),
    .writeData   (wbWriteData)
);


// --- New PC ---
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
    .memWriteLoHi   (memWriteLoHi),
    .wbWriteLoHi    (wbWriteLoHi),
    .memALUOut      (memALUOut),
    .memALUOutHi    (memALUOutHi),
    .wbALUOut       (wbALUOut),
    .wbALUOutHi     (wbALUOutHi),
    .wbMemOut       (wbMemOut),
    .memNextPC      (memNextPC),
    .wbNextPC       (wbNextPC),
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
