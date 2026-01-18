module REG_FETCH(
    input             clk,      // clk
    input             StallID,  // Stall signal from the Hazard Unit
    input             FlushID,  // Flush signal from the Hazard Unit
    input      [31:0] PCPlus4F, // PC + 4 for pc module 
    input      [31:0] PCF,      // PC from the FETCH
    input      [31:0] Instr,    // Instr from the Instruction Memory
    output reg [31:0] InstrD,   // Instruction from the Decode Register
    output reg [31:0] PCPlus4D, // PC + 4 for Decode section   
    output reg [31:0] PCD       // PC to DEDCODE 
    
   
    
    );
always @(posedge clk) begin
        if (FlushID) begin
            InstrD   <= 32'b0;
            PCPlus4D <= 32'b0;
            PCD      <= 32'b0;
        end
        else if (StallID) begin
            InstrD   <= InstrD;
            PCPlus4D <= PCPlus4D;
            PCD      <= PCD;
        end
        else begin
            InstrD   <= Instr;
            PCPlus4D <= PCPlus4F;
            PCD      <= PCF;
        end
    end
endmodule
