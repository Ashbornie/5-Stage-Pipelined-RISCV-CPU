
// riscv_cpu.v - Pipelined RISC-V CPU Processor

module riscv_cpu (
    input         clk, reset,
    output [31:0] PC,
    input  [31:0] Instr,
    output        MemWrite,
    output [31:0] Mem_WrAddr, Mem_WrData,
    input  [31:0] ReadData,
    output [31:0] Result,
    output [ 2:0] funct3,
    output [31:0] PCW, ALUResultW, WriteDataW
);
	
wire ALUSrcAE, RegWriteM, RegWriteW, ZeroE, ZeroW, SignE, PCJalSrcW, PCSrcE;
wire [1:0] ALUSrcBE;
wire StallD, StallF, FlushD, FlushE, ResultSrcE0;
wire [1:0] ResultSrcW; 
wire [1:0] ImmSrcD;
wire [3:0] ALUControlE, ALUControlW;
wire [31:0] PCF, InstrD, InstrW, InstrM;
wire [4:0] Rs1D, Rs2D, Rs1E, Rs2E;
wire [4:0] RdE, RdM, RdW;
wire [1:0] ForwardAE, ForwardBE;

controller c(clk, reset, InstrD[6:0], InstrD[14:12], InstrD[30], ZeroE, ZeroW, SignE, FlushE, ALUResultW[31],PCW, ResultSrcE0, ResultSrcW, MemWrite, PCJalSrcW, PCSrcE, ALUSrcAE, ALUSrcBE, RegWriteM, RegWriteW, ImmSrcD, ALUControlW, ALUControlE);

hazardunit h(Rs1D, Rs2D, Rs1E, Rs2E, RdE, RdM, RdW, RegWriteM, RegWriteW, ResultSrcE0, PCSrcE, ForwardAE, ForwardBE, StallD, StallF, FlushD, FlushE);

datapath dp(clk, reset, ResultSrcW, PCJalSrcW, PCSrcE,ALUSrcAE, ALUSrcBE, RegWriteW, ImmSrcD, ALUControlW, ALUControlE, ZeroE, ZeroW, SignE, PCF, Instr, InstrD, InstrW,InstrM, Mem_WrAddr, Mem_WrData, WriteDataW, ReadData, ForwardAE, ForwardBE, Rs1D, Rs2D, Rs1E, Rs2E, RdE, RdM, RdW, StallD, StallF, FlushD, FlushE, Result, PCW, ALUResultW );

assign funct3 = InstrM[14:12];
assign PC = PCF;
endmodule