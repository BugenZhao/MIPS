// vim: set filetype=verilog:

// -------------------------------------------------------
// -- ISA.v - MIPS ISA constants
// -------------------------------------------------------
// Bugen Zhao 2020
// -------------------------------------------------------

// OPCODE ------------------------------------------------

// R-type
`define OPC_SPECIAL  6'b000000 // ALU, JR, NOP(SLL)


// I-type
`define OPC_ADDI     6'b001000
`define OPC_ADDIU    6'b001001
`define OPC_ANDI     6'b001100
`define OPC_ORI      6'b001101
`define OPC_XORI     6'b001110

`define OPC_LUI      6'b001111

`define OPC_SLTI     6'b001010
`define OPC_SLTIU    6'b001011

`define OPC_REGIMM   6'b000001 // BGEZ, BGEZAL, BLTZ, BLTZAL, (BAL)
`define OPC_BGTZ     6'b000111
`define OPC_BLEZ     6'b000110
`define OPC_BEQ      6'b000100 // (B)
`define OPC_BNE      6'b000101

`define OPC_LB       6'b100000
`define OPC_LBU      6'b100100
`define OPC_LH       6'b100001
`define OPC_LHU      6'b100101
`define OPC_LW       6'b100011
`define OPC_SB       6'b101000
`define OPC_SH       6'b101001
`define OPC_SW       6'b101011


// J-type
`define OPC_J        6'b000010
`define OPC_JAL      6'b000011
// JR: SPECIAL


// FUNCT -------------------------------------------------

// Arithmetic
`define FUN_ADD       6'b100000
`define FUN_ADDU      6'b100001
`define FUN_SUB       6'b100010
`define FUN_SUBU      6'b100011
`define FUN_MULT      6'b011000
`define FUN_MULTU     6'b011001
`define FUN_SLT       6'b101010
`define FUN_SLTU      6'b101011

// Logical
`define FUN_AND       6'b100100
`define FUN_OR        6'b100101
`define FUN_XOR       6'b100110
`define FUN_NOR       6'b100111

// Shift
`define FUN_SLL       6'b000000 // NOP
`define FUN_SRL       6'b000010
`define FUN_SRA       6'b000011
`define FUN_SLLV      6'b000100
`define FUN_SRLV      6'b000110
`define FUN_SRAV      6'b000111

// Move
`define FUN_MFHI      6'b010000
`define FUN_MFLO      6'b010010

// Jump (alu: opA + 0)
`define FUN_JR        6'b001000
`define FUN_JALR      6'b001001

// For alu:
`define FUN_SLE       6'b111101
`define FUN_LUI       6'b111110
`define FUN_NO        6'b111111


// RT ----------------------------------------------------

`define RT_BLTZ         5'b00000
`define RT_BLTZAL       5'b10000
`define RT_BGEZ         5'b00001
`define RT_BGEZAL       5'b10001


// Length ------------------------------------------------

`define OPC      5:0
`define REG      4:0
`define SHA      4:0
`define FUN      5:0
`define WORD    31:0
`define DWORD   63:0
`define QWORD  127:0
`define MMD      1:0


// Instruction -------------------------------------------

`define GET_OPC(instruction)    instruction[31:26]
`define GET_RS(instruction)     instruction[25:21]
`define GET_RT(instruction)     instruction[20:16]
`define GET_RD(instruction)     instruction[15:11]
`define GET_SHAMT(instruction)  instruction[10: 6]
`define GET_FUN(instruction)    instruction[ 5: 0]


// Memory mode -------------------------------------------

`define MEM_BYTE        2'b00
`define MEM_HALF        2'b01
`define MEM_WORD        2'b11


// Register ----------------------------------------------

`define ZERO    5'd00
`define AT      5'd01
`define V0      5'd02
`define V1      5'd03
`define T0      5'd08
`define T1      5'd09
`define T2      5'd10
`define T3      5'd11
`define T4      5'd12
`define T5      5'd13
`define T6      5'd14
`define T7      5'd15
`define GP      5'd28
`define SP      5'd29
`define FP      5'd30
`define RA      5'd31

