/*
	Name: Pipeline register between Datapath Execution and Memory Access Stage
*/



module IEx_IMem(input wire clk, reset, clear, ZeroE,
					 output reg ZeroM,
                input wire [31:0] ALUResultE, WriteDataE, PCE, ImmExtE, InstrE,
                input wire [4:0] RdE, 
                input wire [31:0] PCPlus4E, 
                output reg [31:0] ALUResultM, WriteDataM, InstrM,
                output reg [4:0] RdM, 
                output reg [31:0] PCPlus4M, PCM, ImmExtM);

always @( posedge clk, posedge reset ) begin 
    if (reset) begin
        ALUResultM <= 0;
        WriteDataM <= 0;
        RdM <= 0; 
        PCPlus4M <= 0;
		  PCM <= 0;
		  ImmExtM <=0;
//		  ZeroM <=0;
    end
	 
	 else if (clear) begin
		  ALUResultM <= 0;
        WriteDataM <= 0;
        RdM <= 0; 
        PCPlus4M <= 0;
		  PCM <= 0;
		  ImmExtM <=0;
//		  ZeroM <=0;
	 end

    else begin
        ALUResultM <= ALUResultE;
        WriteDataM <= WriteDataE;
        RdM <= RdE; 
        PCPlus4M <= PCPlus4E;
		  PCM <= PCE;
		  ImmExtM <= ImmExtE;
		  ZeroM <= ZeroE;
		  InstrM <= InstrE;
    end
    
end

endmodule
