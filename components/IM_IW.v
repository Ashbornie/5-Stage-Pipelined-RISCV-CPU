/*
	Name: Pipeline register between Memory Access and WriteBack Stage
*/




module IMem_IW (input wire clk, reset, clear, ZeroM,
					 output reg ZeroW,
                input wire [31:0] ALUResultM, ReadDataM, WriteDataM, ImmExtM, InstrM,
                input wire [4:0] RdM, 
                input wire [31:0] PCPlus4M, PCM,
                output reg [31:0] ALUResultW, ReadDataW, WriteDataW, ImmExtW,InstrW,
                output reg [4:0] RdW, 
                output reg [31:0] PCPlus4W, PCW);

always @( posedge clk, posedge reset ) begin 
    if (reset) begin
        ALUResultW <= 0;
        ReadDataW <= 0;
        PCW <= 0;
        RdW <= 0; 
        PCPlus4W <= 0;
		  WriteDataW <= 0;
		  ImmExtW <= 0;
    end
	 
	 else if (clear) begin
        ALUResultW <= 0;
        ReadDataW <= 0;
        PCW <= 0;
        RdW <= 0; 
        PCPlus4W <= 0;
		  WriteDataW <= 0;
		  ImmExtW <=0;
	 end
	 
    else begin
        ALUResultW <= ALUResultM;
        ReadDataW <= ReadDataM;
        PCW <= PCM;
        RdW <= RdM; 
        PCPlus4W <= PCPlus4M;
		  WriteDataW <= WriteDataM ;
		  ImmExtW <= ImmExtM;
		  ZeroW <= ZeroM;
		  InstrW <= InstrM;
    end
    
end

endmodule