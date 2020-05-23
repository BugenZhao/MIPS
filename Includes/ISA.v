// -------------------------------------------------------
// -- ISA.v - MIPS ISA constants
// -------------------------------------------------------
// Bugen Zhao
// -------------------------------------------------------

// OPCODE ------------------------------------------------

// R-type
`define OPCODE_SPECIAL  6'b000000 // ALU, SLT, JR, MFHI, MFLO, NOP, SYSCALL


// I-type
`define OPCODE_ADDI     6'b001000
`define OPCODE_ADDIU    6'b001001
`define OPCODE_ANDI     6'b001100
`define OPCODE_ORI      6'b001101
`define OPCODE_XORI     6'b001110

`define OPCODE_LUI      6'b001111

`define OPCODE_SLTI     6'b001010
`define OPCODE_SLTIU    6'b001011

`define OPCODE_REGIMM   6'b000001 // BGEZ, BGEZAL, BLTZ, BLTZAL, (BAL)
`define OPCODE_BEQ      6'b000100 // (B)
`define OPCODE_BNE      6'b000101
`define OPCODE_BGTZ     6'b000111
`define OPCODE_BLEZ     6'b000110

`define OPCODE_LB       6'b100000
`define OPCODE_LW       6'b100011
`define OPCODE_SB       6'b101000
`define OPCODE_SW       6'b101011


// J-type
`define OPCODE_J        6'b000010
`define OPCODE_JAL      6'b000011


// FUNCT -------------------------------------------------

// Arithmetic
`define FUNCT_ADD       6'b100000
`define FUNCT_ADDU      6'b100001
`define FUNCT_SUB       6'b100010
`define FUNCT_SUBU      6'b100011
`define FUNCT_MULT      6'b011000
`define FUNCT_MULTU     6'b011001
`define FUNCT_DIV       6'b011010
`define FUNCT_DIVU      6'b011011

// Logical
`define FUNCT_AND       6'b100100
`define FUNCT_OR        6'b100101
`define FUNCT_XOR       6'b100110
`define FUNCT_NOR       6'b100111

// Shift
`define FUNCT_SLL       6'b000000 // NOP
`define FUNCT_SRL       6'b000010
`define FUNCT_SRA       6'b000011
`define FUNCT_SLLV      6'b000100
`define FUNCT_SRLV      6'b000110
`define FUNCT_SRAV      6'b000111

// Move
`define FUNCT_MFHI      6'b010000
`define FUNCT_MFLO      6'b010010

// Jump
`define FUNCT_JR        6'b001000
`define FUNCT_JALR      6'b001001


// RT ----------------------------------------------------

`define RT_BLTZ         5'b00000
`define RT_BLTZAL       5'b10000
`define RT_BGEZ         5'b00001
`define RT_BGEZAL       5'b10001

