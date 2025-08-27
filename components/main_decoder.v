/***
	Name: Main Decoder
	Description: This unit generates the control signals from the 7 bit opcode.
	Determines the type of instruction


***/

module maindec(
	input wire [6:0] op,
	output  [1:0] ResultSrc,
	output MemWrite,
	output Branch, ALUSrcA, 
	output [1:0] ALUSrcB,
	output RegWrite, Jump,
	output [1:0] ImmSrc,
	output [1:0] ALUOp
	);
	
reg [12:0] controls;
assign {RegWrite, ImmSrc, ALUSrcA, ALUSrcB, MemWrite, ResultSrc, Branch, ALUOp, Jump} = controls;

always @(*) begin 
	case(op)
	// RegWrite_ImmSrc_ALUSrcA_ALUSrcB_MemWrite_ResultSrc_Branch_ALUOp_Jump
		7'b0000011: controls = 13'b1_00_0_01_0_01_0_00_0; // lw
		7'b0100011: controls = 13'b0_01_0_01_1_00_0_00_0; // sw
		7'b0110011: controls = 13'b1_10_0_00_0_00_0_10_0; // R–type
		7'b1100011: controls = 13'b0_10_0_00_0_00_1_01_0; // B-type
		7'b0010011: controls = 13'b1_00_0_01_0_00_0_10_0; // I–type ALU
		7'b1101111: controls = 13'b1_11_0_00_0_10_0_00_1; // jal
		7'b0010111: controls = 13'b1_00_1_10_0_11_0_00_0; // auipc // PC Target for SrcB
		7'b0110111: controls = 13'b1_00_1_01_0_11_0_00_0; // lui	
		7'b1100111: controls = 13'b1_00_0_01_0_10_0_00_0; // jalr
		7'b0000000: controls = 13'b0_00_0_00_0_00_0_00_0; // for default values on reset
		
//		default: 	controls = 14'bx_xxx_x_xx_x_xx_x_xx_x; // instruction not implemented
	endcase
end
endmodule