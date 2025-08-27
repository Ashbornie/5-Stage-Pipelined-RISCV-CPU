

/*
	Name: ALU Unit
	Description: Receives control signals from the ALU Decoder and performs the operations
*/


module alu(input wire [31:0] a, 
			input wire [31:0] b, 
			input wire [3:0] ALUControl , 
			output reg  [31:0] ALUResult, 
			output  Zero, Sign);

wire [31:0] Sum;
wire Overflow;

//assign Sum = SrcA + (ALUControl[0] ? ~SrcB : SrcB) + ALUControl[0];  // sub using 1's complement
//assign Overflow = ~(ALUControl[0] ^ SrcB[31] ^ SrcA[31]) & (SrcA[31] ^ Sum[31]) & (~ALUControl[1]);

assign Zero = (ALUResult == 0) ? 1'b1 : 1'b0;
assign Sign = ALUResult[31];

//
//always @(*)
//		casex (ALUControl)
//				4'b000x: ALUResult = Sum;				// sum or diff
//				4'b0010: ALUResult = SrcA & SrcB;	// and
//				4'b0011: ALUResult = SrcA | SrcB;	// or
//				4'b0100: ALUResult = SrcA << SrcB;	// sll, slli
//				4'b0101: ALUResult = {{30{1'b0}}, Overflow ^ Sum[31]}; //slt, slti
//				4'b0110: ALUResult = SrcA ^ SrcB;   // Xor
//				4'b0111: ALUResult = SrcA >> SrcB;  // shift wire
//				4'b1000: ALUResult = ($unsigned(SrcA) < $unsigned(SrcB)); //sltu, stlui
//				4'b1111: ALUResult = SrcA >>> SrcB; //shift arithmetic
//				default: ALUResult = 32'bx;
//		endcase

always @(*) begin
    casex (ALUControl)
        4'b0000:  ALUResult <= a + b;       // ADD
        4'b0001:  ALUResult <= a + ~b + 1;  // SUB 
        4'b0010:  ALUResult <= a & b;       // AND
        4'b0011:  ALUResult <= a | b;       // OR
        4'b0100:  ALUResult <= a ^ b;       // XOR
        4'b0101:  begin                   // SLT
                    ALUResult <= ($signed(a) < $signed(b)) ? 1 : 0;  // SLT, SLTI
                 end
        4'b0110:  ALUResult <= a >> b[4:0];            // SRL,SRLI
        4'b0111:  ALUResult <= $signed(a) >>> b[4:0];  // SRA,SRAI
        4'b1000:  ALUResult <= a << b[4:0];            // SLL, SLLI (Shift Left Logical)
        4'b1001:  ALUResult <= (a < b) ? 1 : 0;        // SLTU, SLTIU (Set Less Than Unsigned)
        default:  ALUResult <= 0;
    endcase
end
endmodule
		
	
