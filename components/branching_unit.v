
// branching_unit.v - logic for branching in execute stage

module branching_unit (
    input [2:0] funct3,
    input       Zero, ALUR31,
    output reg  BranchD
);

initial begin
    BranchD = 1'b0;
end

always @(*) begin
    case (funct3)
        3'b000: BranchD =    Zero; // beq
        3'b001: BranchD =   !Zero; // bne
        3'b100: BranchD =  ALUR31; //blt
        3'b101: BranchD = !ALUR31; //bge
        3'b110: BranchD =  ALUR31; //bltu
        3'b111: BranchD = !ALUR31; //bgeu
        default: BranchD = 1'b0;
    endcase
end

endmodule
