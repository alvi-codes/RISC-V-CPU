// include all created components
`include "control_unit/instr_mem/instr_mem.sv"
`include "control_unit/control_unit/control_unit.sv"
`include "control_unit/sign_extend/sign_extend.sv"
`include "pc/pc_mux.sv"
`include "pc/pcReg.sv"
`include "alu/alusrc.sv"
`include "alu/alu.sv"
`include "alu/reg_file.sv"
`include "alu/data_mem.sv"


// create top level module
module risc_v #(
    parameter ADDRESS_WIDTH = 32,
    parameter DATA_WIDTH = 32
)(
    input logic clk,
    input logic rst,
    output logic [DATA_WIDTH-1:0] a0,
    output logic [DATA_WIDTH-1:0] a1,
    output logic [DATA_WIDTH-1:0] a2,
    output logic [DATA_WIDTH-1:0] a3,
    output logic [DATA_WIDTH-1:0] a4,
    output logic [DATA_WIDTH-1:0] a5,
    output logic [DATA_WIDTH-1:0] a6,
    output logic [DATA_WIDTH-1:0] t0,
    output logic [DATA_WIDTH-1:0] t1,
    output logic [DATA_WIDTH-1:0] instruction,
    output logic [7:0] pc_addr
);



logic                     PCsrc, EQ, RegWrite, ALUsrc, MEMsrc;
logic [ADDRESS_WIDTH-1:0] ImmOp, pc;
logic [4:0]               rs1, rs2, rd;
logic [2:0]               ALUctrl;
logic                     JALsrc, JALRsrc;
logic [2:0]               MEMRead;
logic [3:0]               MEMWrite;
logic                     LUISig;
logic [ADDRESS_WIDTH-1:0] lui_rd;

//Top_CU
logic   [DATA_WIDTH-1:0]    instr;
logic   [1:0]              ImmSrc;

assign rs1  = instr[19:15];
assign rs2  = instr[24:20];
assign rd   = instr[11:7];

// LUI
assign lui_rd = {instr[31:12], 12'b0};

instr_mem #(ADDRESS_WIDTH, DATA_WIDTH) my_instr_mem( //Changing 8 to 32 generates a memory error: 
                                            // %Error: test_instructions.mem:0: $readmem file address beyond bounds of array
                                            // Aborting...
                                            // Aborted (core dumped)
    .pc (pc),      
    .instr (instr)  
);
control_unit #(DATA_WIDTH) my_control_unit(
    .instr (instr),
    .EQ (EQ),
    .RegWrite (RegWrite),
    .ALUctrl (ALUctrl),
    .ALUsrc (ALUsrc),
    .ImmSrc (ImmSrc),
    .PCsrc (PCsrc),
    .JALsrc (JALsrc),
    .JALRsrc (JALRsrc),
    .MEMWrite (MEMWrite),
    .MEMsrc (MEMsrc),
    .MEMRead (MEMRead),
    .LUISig (LUISig)
);
sign_extend #(DATA_WIDTH) my_sign_extend(
    .instr (instr),
    .ImmSrc (ImmSrc),    
    .ImmOp (ImmOp)
);



//Top_PC
logic [ADDRESS_WIDTH-1:0] next_PC;

pc_mux #(ADDRESS_WIDTH) pc_mux(
    .PCsrc (PCsrc),
    .ImmOp (ImmOp),
    .next_PC (next_PC),
    .pc (JALRsrc ? (ALUop1+ImmOp) : pc)
);
pcReg #(ADDRESS_WIDTH) pcReg(
    .clk (clk),
    .rst (rst),
    .next_PC (next_PC),
    .pc (pc)
);



//Top_ALU
logic [ADDRESS_WIDTH-1:0] ALUop1, ALUop2, regOp2, ALUout, MEMdata, RegData;

alusrc #(ADDRESS_WIDTH) alusrc (
    .regOp2 (regOp2),
    .ImmOp (ImmOp),
    .ALUsrc (ALUsrc),
    .ALUop2 (ALUop2)
);
alu #(3, ADDRESS_WIDTH) alu (
    .ALUop1 (ALUop1),
    .ALUop2 (ALUop2),
    .ALUctrl (ALUctrl),
    .ALUout (ALUout),
    .EQ (EQ)
);
reg_file #(5, DATA_WIDTH)reg_file (
    .clk (clk),
    .AD1 (rs1),
    .AD2 (rs2),
    .AD3 (rd),
    .WE3 (RegWrite),
    .WD3 (LUISig ? (lui_rd) : (JALsrc ? (pc) : (MEMsrc ? MEMdata : ALUout))),
    .RD1 (ALUop1),
    .RD2 (regOp2),
    .a0 (a0),
    .a1 (a1),
    .a2 (a2),
    .a3 (a3),
    .a4 (a4),
    .a5 (a5),
    .a6 (a6),
    .t0 (t0),
    .t1 (t1)
);
data_mem #(32, 32) data_mem (
    .clk (clk),
    .RE (MEMRead),
    .WE (MEMWrite),
    .A (ALUout),
    .WD1 (regOp2[7:0]),
    .WD2 (regOp2[15:8]),
    .WD3 (regOp2[23:16]),
    .WD4 (regOp2[31:24]),
    .RD (MEMdata)
);

assign pc_addr = pc[7:0];
assign instruction = instr;

endmodule
