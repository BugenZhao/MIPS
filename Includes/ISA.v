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
`define OPC_LW       6'b100011
`define OPC_SB       6'b101000
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
// `define FUN_MULT      6'b011000
// `define FUN_MULTU     6'b011001
// `define FUN_DIV       6'b011010
// `define FUN_DIVU      6'b011011
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
// `define FUN_MFHI      6'b010000
// `define FUN_MFLO      6'b010010

// Jump (alu: opA + 0)
`define FUN_JR        6'b001000

// For alu:
`define FUN_LUI       6'b111110
`define FUN_NO        6'b111111


// RT ----------------------------------------------------

`define RT_BLTZ         5'b00000
`define RT_BLTZAL       5'b10000
`define RT_BGEZ         5'b00001
`define RT_BGEZAL       5'b10001

