/*
	Name: ALU Decoder
	Description: Receives control signal from the Main Decoder Unit and 
	determines the type of operation that has to be performed by the ALU

*/



module aludec(input wire opb5,
	input wire [2:0] funct3,
	input wire funct7b5,
	input wire [1:0] ALUOp,
	output reg [3:0] ALUControl);
	
wire RtypeSub;
assign RtypeSub = funct7b5 & opb5; // TRUE for R-type subtract

//always @(*)
//	case(ALUOp)
//		2'b00: ALUControl = 4'b0000; // addition
//		2'b01: ALUControl = 4'b0001; // subtraction
//		default: case(funct3) // R–type or I–type ALU
//			3'b000: if (RtypeSub)
//				ALUControl = 4'b0001; // sub
//			else
//				ALUControl = 4'b0000; // add, addi
//			3'b001: ALUControl = 4'b0100; // sll, slli
//			3'b010: ALUControl = 4'b0101; // slt, slti
//			3'b011: ALUControl = 4'b1000; // sltu, sltiu
//			3'b100: ALUControl = 4'b0110; // xor, xori
//			3'b101: if (~funct7b5)
//				ALUControl = 4'b0111;	// srl
//			else
//				ALUControl = 4'b1111;  // sra
//			3'b110: ALUControl = 4'b0011; // or, ori
//			3'b111: ALUControl = 4'b0010; // and, andi
//			default: ALUControl = 4'bxxxx; // ???
//			endcase
//	endcase
	
always @(*) begin
    case (ALUOp)
        2'b00: ALUControl = 4'b0000;             // addition
        2'b01: ALUControl = 4'b0001;             // subtraction
        default:
            case (funct3) // R-type or I-type ALU
                3'b000: begin
                    // True for R-type subtract
                    if   (RtypeSub) ALUControl = 4'b0001; //sub
                    else ALUControl = 4'b0000; // add, addi
                end
                3'b001:  ALUControl = 4'b1000; // SLL, SLLI (Shift Left Logical)
                3'b010:  ALUControl = 4'b0101; // slt, slti
                3'b011:  ALUControl = 4'b1001; // SLTU, SLTIU (Set Less Than Unsigned)
                3'b100:  ALUControl = 4'b0100; // XOR
                3'b101: begin
                    if (funct7b5) ALUControl = 4'b0111;  // SRA,SRAI
                    else ALUControl = 4'b0110;           // SRL,SRLI
                end
                3'b110:  ALUControl = 4'b0011; // or, ori
                3'b111:  ALUControl = 4'b0010; // and, andi
                default: ALUControl = 4'bxxxx; // ???
            endcase
    endcase
end

endmodule