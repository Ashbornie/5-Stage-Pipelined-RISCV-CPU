/*
	Name: 5 stage pipelined Datapath
	Description: Datapath with 5 stages
	Refer the microarchitecture in the images folder for reference
	
	
*/


module datapath(input wire clk, reset,
		input wire [1:0] ResultSrcW,
		input wire PCJalSrcW, PCSrcE, ALUSrcAE, 
		input wire [1:0] ALUSrcBE,
		input wire RegWriteW,
		input wire [1:0] ImmSrcD,
		input wire [3:0] ALUControlW, ALUControlE,
		output ZeroE, ZeroW,
		output SignE,
		output  [31:0] PCF,
		input wire [31:0] InstrF,
		output [31:0] InstrD, InstrW, InstrM,
		output [31:0] Mem_WrAddr, Mem_WrData, WriteDataW,
		input wire [31:0] ReadDataM,
		input wire [1:0] ForwardAE, ForwardBE,
		output [4:0] Rs1D, Rs2D, Rs1E, Rs2E,
      output [4:0] RdE, RdM, RdW,
		input wire StallD, StallF, FlushD, FlushE,
		output  [31:0] Result, PCW, ALUResultW);


	wire [31:0] PCD, PCE, PCM, ALUResultE,ALUResultM, ReadDataW;
	wire [31:0] PCNextF, PCPlus4F, PCPlus4D, PCPlus4E, PCPlus4M, PCPlus4W, PCTargetE, PCJalr;
	wire [31:0] WriteDataE,WriteDataM;
	wire [31:0] InstrE, AuiPC, lAuiPC;
	wire [31:0] ImmExtD, ImmExtE, ImmExtM, ImmExtW;
	wire [31:0] SrcAEfor, SrcAE, SrcBE, RD1D, RD2D, RD1E, RD2E;
	wire [31:0] ResultW;
	wire [3:0] Ctrl;
	wire [4:0] RdD; // destination register address

	
	// Fetch Stage
	
	mux2 #(32) jal_r(PCTargetE, ALUResultW, PCJalSrcW, PCJalr);
	mux2 #(32) pcmux(PCPlus4F, PCJalr, PCSrcE, PCNextF);
	
	reset_ff #(32) IF(clk, reset, ~StallF, PCNextF, PCF);
	adder pcadd4(PCF, 32'd4, PCPlus4F);
	
		
	// Instruction Fetch - Decode Pipeline Register	
	
	IF_ID pipreg0 (clk, reset, FlushD, ~StallD, InstrF, PCF, PCPlus4F, InstrD, PCD, PCPlus4D);
	assign Rs1D = InstrD[19:15];
	assign Rs2D = InstrD[24:20];		
	reg_file rf (clk, RegWriteW, Rs1D, Rs2D, RdW, ResultW, RD1D, RD2D);	
	assign RdD = InstrD[11:7];
	imm_extend ext(InstrD[31:7], ImmSrcD, ImmExtD);
	
	// Decode - Execute Pipeline Register	
	
	ID_IEx pipreg1 (clk, reset, FlushE, RD1D, RD2D, PCD,InstrD, Rs1D, Rs2D, RdD, ImmExtD, PCPlus4D, RD1E, RD2E, PCE,InstrE, Rs1E, Rs2E, RdE, ImmExtE, PCPlus4E);
	mux3 #(32) forwardMuxA (RD1E, ResultW, ALUResultM, ForwardAE, SrcAEfor);
	
	mux2 #(32) srcamux(SrcAEfor, 32'b0, ALUSrcAE, SrcAE); // for lui

	adder      auipcadder ({InstrW[31:12], 12'b0}, PCW, AuiPC);
   mux2 #(32) lauipcmux (AuiPC, {InstrW[31:12], 12'b0}, InstrW[5], lAuiPC);

	mux3 #(32) forwardMuxB (RD2E, ResultW, ALUResultM, ForwardBE, WriteDataE);
	mux3 #(32) srcbmux(WriteDataE, ImmExtE, PCTargetE, ALUSrcBE, SrcBE); 
	adder pcaddbranch(PCW, ImmExtW, PCTargetE); // Next PC for jump and branch instructions

	mux2 #(4) ctrlmux(ALUControlE, ALUControlW, PCSrcE, Ctrl);
	alu alu(SrcAE, SrcBE, Ctrl, ALUResultE, ZeroE, SignE);
	
		
	// Execute - Memory Access Pipeline Register
	IEx_IMem pipreg2 (clk, reset, FlushE, ZeroE, ZeroM, ALUResultE, WriteDataE, PCE,ImmExtE,InstrE, RdE, PCPlus4E, ALUResultM, WriteDataM,InstrM, RdM, PCPlus4M, PCM, ImmExtM);
	
		
	// Memory - Register Write Back Stage
	IMem_IW pipreg3 (clk, reset, FlushE, ZeroM, ZeroW, ALUResultM, ReadDataM, WriteDataM, ImmExtM,InstrM, RdM, PCPlus4M, PCM, ALUResultW, ReadDataW, WriteDataW,ImmExtW,InstrW, RdW, PCPlus4W, PCW);
	
	mux4 #(32) resultmux( ALUResultW, ReadDataW, PCPlus4W,lAuiPC, ResultSrcW, ResultW);
   
	assign Result = ResultW;
	assign Mem_WrAddr = ALUResultM;
   assign Mem_WrData = WriteDataM;

endmodule