module REG_EXECUTE(
    input             clk,      // clk
    // ALU reult 
    input      [31:0] ALUResult,
    output reg [31:0] ALUResultM,
    
    // IMM 
    input [31:0] ImmExtE,
    output reg [31:0] ImmExtM,
    
    //Write data to data memory
    input      [31:0] WriteDataE,
    output reg [31:0] WriteDataM,
    
    // destination of the reg file to store the ans or data
    input      [4:0] RdE,
    output reg [4:0] RdM,
    
    // pc+4
    input      [31:0] PCPlus4E,   
    output reg [31:0] PCPlus4M,  
    
    // Reg write signal
    input      RegWriteE, 
    output reg RegWriteM,  
    
    // Mem write signal unsed in Memory Stage
    input      MemWriteE, 
    output reg MemWriteM,  
    
    // Result mux control signal
    input      [1:0] ResultSrcE, 
    output reg [1:0] ResultSrcM,
    
    // Used for the lw size 
    input      [2:0] MemSizeE, 
    output reg [2:0] MemSizeM 
    );
    
always @(posedge clk) // JUST NORMAL BUFFER OR REG WITHOUT CLK 
begin 
    ALUResultM <= ALUResult;
    
    WriteDataM <= WriteDataE;
    
    RdM <= RdE;
    
    PCPlus4M <= PCPlus4E;
    
    RegWriteM <= RegWriteE ;
    
    MemWriteM <= MemWriteE ;
   
    ResultSrcM <= ResultSrcE;
    
    MemSizeM <= MemSizeE;
    
    ImmExtM <= ImmExtE;
end
endmodule