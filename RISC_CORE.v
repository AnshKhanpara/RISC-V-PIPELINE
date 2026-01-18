(* dont_touch = "true" *)
module RISC_CORE(
    input clk,
    input reset,
    
    // instr memory
    input [31:0] Instr, 
    output [31:0] PCF,
    
    // data memory
    input [31:0] ReadData,
    
    output MemWriteM,
    output [2:0] MemSizeM, // to sotre the data ni data memory
    
    output [31:0] ALUResultM,
    output [31:0] WriteDataM
);

wire RegWriteD;
wire [2:0] ImmSrcD;
wire ALUSrcAD;
wire ALUSrcBD;
wire [3:0] ALUControlD;
wire MemWriteD;
wire [1:0] ResultSrcD;
wire BranchD;
wire JumpD;
wire [2:0] MemSizeD;

wire [31:0] InstrD;

wire ZeroE;
wire LessE;
wire Less_unsignedE;
wire IsjalrE;
wire Isjalr;

wire JumpE;
wire BranchE;

wire [1:0] PCSrcE;

/* ---- CONTROL UNIT ---- */
CONTROL_UNIT CONTROL_UNIT_(

    // OUTPUT OF THE CONTROL UNIT
    
    .RegWriteD(RegWriteD),
    .ImmSrcD(ImmSrcD),
    .ALUSrcAD(ALUSrcAD),
    .ALUSrcBD(ALUSrcBD),
    .ALUControlD(ALUControlD),
    .MemWriteD(MemWriteD),
    .ResultSrcD(ResultSrcD),
    .BranchD(BranchD),
    .JumpD(JumpD),
    .Isjalr(Isjalr),
    .MemSizeD(MemSizeD),
    
    // INPUT OF THE CONTROL UNIT
    .opcode(InstrD[6:0]),
    .funct3(InstrD[14:12]),
    .funct7_5(InstrD[30])    
);


/* ---- DATA PATH ---- */
DATA_PATH DATA_PATH_(
    .clk(clk),
    .reset(reset),
    
    .Instr(Instr),
    .PCF(PCF),
    
    .ReadData(ReadData),
    .ALUResultM(ALUResultM),
    .WriteDataM(WriteDataM),
    
    .InstrD(InstrD),
    .JumpE(JumpE),
    .BranchE(BranchE),
    
    .RegWriteD(RegWriteD),
    
    .MemWriteD(MemWriteD),
    .MemWriteM(MemWriteM),
    .MemSizeM(MemSizeM),
    
    .JumpD(JumpD),
    .BranchD(BranchD),
    .ALUSrcAD(ALUSrcAD),
    .ALUSrcBD(ALUSrcBD),
    .PCSrcE(PCSrcE),
    .ImmSrcD(ImmSrcD),
    .ALUControlD(ALUControlD),
    .ResultSrcD(ResultSrcD),
    .MemSizeD(MemSizeD),
    
    .ZeroE(ZeroE),
    .LessE(LessE),
    .Less_unsignedE(Less_unsignedE),
    .IsjalrE(IsjalrE),    
    .Isjalr(Isjalr)    
);

PC_MUX_SELECT PC_SRC(
    .JumpE(JumpE),
    .BranchE(BranchE),
    .ZeroE(ZeroE),
    .LessE(LessE),
    .Less_unsignedE(Less_unsignedE),
    .funct3(InstrD[14:12]),
    .opcode(InstrD[6:0]),
    .PCSrcE(PCSrcE),
    .IsjalrE(IsjalrE)
);
endmodule