/*
	Name: Hazard Unit
	Description: Handles both Data Hazards and Control Hazards	
*/


module hazardunit(input wire [4:0] Rs1D, Rs2D, Rs1E, Rs2E,
                input wire [4:0] RdE, RdM, RdW,
                input wire RegWriteM, RegWriteW,
				    input wire ResultSrcE0, PCSrcE,
                output reg [1:0] ForwardAE, ForwardBE,
                output reg StallD, StallF, FlushD, FlushE);
					 
// RAW					 
// Whenever source register (Rs1E, Rs2E) in execution stage matchces with the destination register (RdM, RdW)
// of a previous instruction's Memory or WriteBack stage forward the ALUResultM or ResultW
// And also only when RegWrite is asserted

    always @(*) begin
	    ForwardAE = 2'b00;
		 ForwardBE = 2'b00;
        if ((Rs1E == RdM) && (RegWriteM) && (Rs1E != 0)) // higher priority - most recent
            ForwardAE = 2'b10; // for forwarding ALU Result in Memory Stage
        else if ((Rs1E == RdW) & (RegWriteW) & (Rs1E != 0))
            ForwardAE = 2'b01; // for forwarding WriteBack Stage Result
                    


        if ((Rs2E == RdM) && (RegWriteM) && (Rs2E != 0))
            ForwardBE = 2'b10; // for forwarding ALU Result in Memory Stage

        else if ((Rs2E == RdW) && (RegWriteW) && (Rs2E != 0))
            ForwardBE = 2'b01; // for forwarding WriteBack Stage Result
	  
	  end
	  
// For Load Word Dependency result does not appear until end of Data Memory Access Stage
// if Destination register in EXE stage is equal to souce register in decode stage
// stall previous instructions until the the load word is avialbe at the writeback stage
// Introduce One cycle latency for subsequent instructions after load word 
// There is two cycle difference between Memory Access and the immediate next instruction

// Load Word Stall (assigned combinationally)
wire lwStall;
assign lwStall = ResultSrcE0 && ((RdE == Rs1D) || (RdE == Rs2D));

// Hazard control logic
always @(*) begin
    // Default stall and flush signals
    StallF = lwStall;
    StallD = lwStall;
    FlushE = lwStall || PCSrcE;
    FlushD = PCSrcE;
end

endmodule



    
