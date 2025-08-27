/*
	Name: Controller or Control Unit
	Description: 5 stage pipelined Control Unit
*/




module controller(input wire clk, reset,
						input wire [6:0] op,
						input wire [2:0] funct3,
						input wire funct7b5,
						input wire ZeroE, ZeroW,
						input wire SignE,
						input wire FlushE,
						input wire ALUResultW,
						input wire [31:0] PCW,
						output     ResultSrcE0,
						output [1:0] ResultSrcW,
						output MemWriteM,
						output PCJalSrcW, PCSrcE, ALUSrcAE, 
						output [1:0] ALUSrcBE,
						output RegWriteM, RegWriteW,
						output [1:0] ImmSrcD,
						output [3:0] ALUControlW, ALUControlE);

wire [1:0] ALUOpD;
wire [1:0] ResultSrcD, ResultSrcE, ResultSrcM;
wire [3:0] ALUControlD, ALUControlM;
wire BranchD, BranchE, BranchM, BranchW, MemWriteD, MemWriteE, JumpD, JumpE,JumpM,JumpW;
wire ZeroOp, ALUSrcAD, RegWriteD, RegWriteE;
wire [1:0] ALUSrcBD;
wire SignOp, PCJalSrcD, PCJalSrcE, PCJalSrcM;
wire BranchOp, Branch, Jalflag;
wire [2:0] funct3e, funct3m, funct3w;

// main decoder
maindec md(op, ResultSrcD, MemWriteD, BranchD, ALUSrcAD, ALUSrcBD, RegWriteD, JumpD, ImmSrcD, ALUOpD);

// alu decoder
aludec ad(op[5], funct3, funct7b5, ALUOpD, ALUControlD);


c_ID_IEx c_pipreg0(clk, reset, FlushE, RegWriteD, MemWriteD, JumpD, BranchD, ALUSrcAD,PCJalSrcD, ALUSrcBD, ResultSrcD, ALUControlD, 
										RegWriteE, MemWriteE, JumpE, BranchE, ALUSrcAE,PCJalSrcE, ALUSrcBE, ResultSrcE, ALUControlE, funct3, funct3e);
assign ResultSrcE0 = ResultSrcE[0];

c_IEx_IM c_pipreg1(clk, reset, RegWriteE, MemWriteE, BranchE, JumpE,PCJalSrcE, BranchM, ResultSrcE, RegWriteM, MemWriteM, JumpM,PCJalSrcM, ResultSrcM, funct3e, funct3m, ALUControlE, ALUControlM);

c_IM_IW c_pipreg2 (clk, reset, RegWriteM,BranchM,JumpM,PCJalSrcM, BranchW,JumpW,PCJalSrcW, ResultSrcM, RegWriteW, ResultSrcW, funct3m, funct3w, ALUControlM, ALUControlW);

branching_unit bu(funct3w, ZeroW, ALUResultW, Branch);

assign ZeroOp = ZeroE ^ funct3[0]; // Complements Zero flag for BNE Instruction
assign SignOp = (SignE ^ funct3[0]) ; //Complements Sign for BGE

//mux2 BranchSrc (ZeroOp, SignOp, funct3[2], BranchOp); // fix this later
//assign BranchOp = funct3w[2] ? (ZeroOp) : (SignOp); 

assign PCSrcE = (BranchW & Branch) | Jalflag | JumpW;
assign Jalflag = (PCJalSrcW == 1 && (PCW == 32'b00000000000000000000000100101100 | PCW == 32'b00000000000000000000000100110100)) ? 1 : 0;

assign PCJalSrcD = (op == 7'b1100111) ? 1 : 0; // jalr


endmodule