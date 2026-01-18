module REG_DATA_MEMORY(
    input      clk,
    
    // reg write signal that will be used in the to write the reg again for storing data
    input      RegWriteM,
    output reg RegWriteW,
    
    // imm 
    
     input [31:0] ImmExtM,
     output reg [31:0] ImmExtW,
    // Result mux control signal
    input      [1:0] ResultSrcM, 
    output reg [1:0] ResultSrcW,
    
    // destination of the reg file to store the ans or data
    input      [4:0] RdM,
    output reg [4:0] RdW,
    
    // data from the DATA MEMORY
    input      [31:0] ReadData,
    output reg [31:0] ReadDataW,
    
    // Pc + 4
    input      [31:0] PCPlus4M,
    output reg [31:0] PCPlus4W,
    
    input [31:0] ALUResultM,
    output reg [31:0] ALUResultW
    
  
);

always @(posedge clk)
begin 
    RegWriteW <= RegWriteM;
    
    ResultSrcW <= ResultSrcM;
    
    RdW <= RdM;
    
    ReadDataW <= ReadData;
    
    PCPlus4W <= PCPlus4M;
    
    ALUResultW <= ALUResultM;
    
    ImmExtW <= ImmExtM;
end
endmodule