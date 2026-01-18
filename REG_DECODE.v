module REG_DECODE( 
    input clk,      // clk  
    input FlushE, // control signal from the hazard uunit
    
    input [31:0] PCD,   
    input [31:0] ImmExtD,  // Extended 
    input [31:0] PCPlus4D,   
    input [31:0] RD1,   // Read data from the reg file
    input [31:0] RD2,   // Read data from the reg file
    
    input [4:0] Rs1D, // source 1 addr
    input [4:0] Rs2D, // source 2 addr
    input [4:0] RdD, // destination addr
    
    // inputs from the control unit
    input RegWriteD,
    input MemWriteD,
    input JumpD,
    input BranchD,
    input ALUSrcAD,
    input ALUSrcBD,
    
    input [1:0] ResultSrcD,
    
    input [2:0] MemSizeD,
    
    input [3:0] ALUControlD,
    // output of the DECODE STAGE REGISTER
    
    // Control unit signals 
    output reg RegWriteE,
    output reg MemWriteE,
    output reg JumpE,
    output reg BranchE,
    output reg ALUSrcAE,
    output reg ALUSrcBE,
    
    output reg [1:0] ResultSrcE,
    
    output reg [2:0] MemSizeE, // this signal is used for the lw size
    
    output reg [3:0] ALUControlE,
    
    // pc , extned and old pc + 4 
    output reg [31:0] PCPlus4E,
    output reg [31:0] ImmExtE,
    output reg [31:0] PCE,
    
    // data from the regs 
    output reg [31:0] RD1E,
    output reg [31:0] RD2E,
    
    // addr of the regs as per the instr 
    output reg [4:0] Rs1E,
    output reg [4:0] Rs2E,
    output reg [4:0] RdE,
    
    input Isjalr,
    output reg IsjalrE
    );

always @(posedge clk )
begin 
 if(FlushE) // flush 
    begin 
        RegWriteE <= 1'd0;
        MemWriteE <= 1'd0;
        JumpE <= 1'd0;
        BranchE <= 1'd0;
        ALUSrcAE <= 1'd0;
        ALUSrcBE <= 1'd0;
        
        ResultSrcE <= 2'd0;
        
        MemSizeE <= 3'd0;
        
        ALUControlE <= 4'd0;
        
        Rs1E <= 5'd0;
        Rs2E <= 5'd0;
        RdE <= 5'd0;
        
        RD1E <= 32'd0;
        RD2E <= 32'd0;
        PCPlus4E <= 32'd0;
        ImmExtE <= 32'd0;
        PCE <= 32'd0;
        IsjalrE <= 1'b0;
    end 
    
    else // latch 
    begin 
        RegWriteE <= RegWriteD;
        MemWriteE <= MemWriteD;
        JumpE <= JumpD;
        BranchE <= BranchD;
        ALUSrcAE <= ALUSrcAD;
        ALUSrcBE <= ALUSrcBD;
        
        ResultSrcE <= ResultSrcD;
        
        MemSizeE <= MemSizeD;
        
        ALUControlE <= ALUControlD;
        
        Rs1E <= Rs1D;
        Rs2E <= Rs2D;
        RdE <= RdD;
        
        RD1E <= RD1;
        RD2E <= RD2;
        PCPlus4E <= PCPlus4D;
        ImmExtE <= ImmExtD;
        PCE <= PCD;
        
        IsjalrE <= Isjalr;
    end
end 


endmodule
