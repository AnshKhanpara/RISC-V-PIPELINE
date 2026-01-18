(* dont_touch = "true" *)
module DATA_PATH(
    // clk and reset
    input clk,
    input reset,
    
    // ip and op for the instr memory
    input  [31:0] Instr,
    output [31:0] PCF,
    
    // ip and op for the data memory
    input  [31:0] ReadData,
    output [31:0] ALUResultM,
    output [31:0] WriteDataM,
    
    // op for the control unit
    output [31:0] InstrD,
    output JumpE,
    output BranchE,
    
    // ip from the control signal 
    input RegWriteD,
    
    input MemWriteD,
    output MemWriteM,
    
    input JumpD,
    input BranchD,
    input ALUSrcAD,
    input ALUSrcBD,
    
    input [1:0] PCSrcE,
    
    input [2:0] ImmSrcD,
    
    input [3:0] ALUControlD,
    
    input [1:0] ResultSrcD,
    
    input [2:0] MemSizeD,
    output [2:0] MemSizeM,
    
    // alu op used in the pc_mux_select
    output ZeroE,
    output LessE,
    output Less_unsignedE,
    
    input Isjalr,
    output  IsjalrE
    );
    
/* ------  WIRES ------*/    

/* 1) PC_MUX */

// ip for the pc mux
wire [31:0] PCTargetE;
wire [31:0] PCPlus4F;

// op of pc mux
wire [31:0] PCF_NEXT;

assign PCPlus4F = PCF + 32'd4;
assign PCTargetE = PCE + ImmExtE;


/* 3) REG FETCH */
wire [31:0] PCD;
wire [31:0] PCPlus4D;


/* 4) REG FETCH */
wire [31:0] RD1;
wire [31:0] RD2;


/* 5) EXTEND */
wire [31:0] ImmExtD;


/* 6) REG DECODE */
// ip for decode reg
wire [4:0] Rs1D;
wire [4:0] Rs2D;
wire [4:0] RdD;

wire StallE;

//assign StallE = lwStall;
assign Rs1D = InstrD[19:15];
assign Rs2D = InstrD[24:20];
assign RdD = InstrD[11:7];

// op for decode reg
wire [31:0] PCPlus4E;
wire [31:0] ImmExtE;
wire [31:0] PCE;
wire [31:0] RD2E;
wire [31:0] RD1E;

wire [4:0] Rs1E;
wire [4:0] Rs2E;
wire [4:0] RdE; 

wire [3:0] ALUControlE;

wire [1:0] ResultSrcE;

wire ALUSrcAE; 
wire ALUSrcBE; 
wire MemWriteE; 
wire RegWriteE; 

wire [2:0] MemSizeE;

/* 7) FORWARING MUXs */
wire [31:0] A;
wire [31:0] B;

wire [31:0] SrcAE;
wire [31:0] SrcBE;


/* 8) ALU */
wire [31:0] ALUResult; 
wire [31:0] WriteDataE; 



assign WriteDataE = B;


/* 9) EXECUTE REGISTER */
wire RegWriteM;
wire [1:0] ResultSrcM;
wire [31:0] PCPlus4M;
//wire [2:0] MemSizeE;
wire [4:0] RdM;
wire [31:0] ImmExtM;

/* 10) DATA MEMORY REGISTER */
wire [31:0] PCPlus4W;
wire [31:0] ReadDataW;
wire [4:0] RdW;
wire [31:0] ALUResultW;
wire [1:0] ResultSrcW;
wire RegWriteW;
wire [31:0] ImmExtW;

/* 11) Result mux */
wire [31:0] ResultW;


/* 12) HAZARD UNIT */
// ip from the hazard unit 
wire StallF;
wire StallD;
wire [1:0] ForwardAE;
wire [1:0] ForwardBE;
wire FlushE;
wire FlushD;

wire lwStall;
//assign ResultSrcM = FlushE ? 2'b00 : ResultSrcE;

/* ------  MODULES ------*/    
wire [31:0] jalr_target;
assign jalr_target = ALUResult & 32'hFFFFFFFE;

/* 1) PC_MUX */
mux_4x1 PC_MUX(
    .a(PCPlus4F),
    .b(PCTargetE),
    .c(jalr_target),// for the JALR PC = (imm + rs1) & ~1 --> makes sure that last 2 bits are always zero
    .d(32'd0),
    .sel(PCSrcE),
    .y(PCF_NEXT)
);


/* 2) PC_MODULE */

PC_MODULE PC(
    .pc_next(PCF_NEXT),
    .pc(PCF),
    .clk(clk),
    .reset(reset), 
    .StallF(StallF) // stall signal from the hazaed unit
);

/* 3) REG FETCH */
REG_FETCH FETCH_REG(
    .clk(clk),
    .StallID(StallD),
    .FlushID(FlushD),
    .PCPlus4F(PCPlus4F),
    .PCF(PCF),
    .Instr(Instr),
    .InstrD(InstrD),
    .PCPlus4D(PCPlus4D),
    .PCD(PCD)
);

/* 4) REG FILE */
REG_FILE REGISTER_FILE(
    .clk(clk),
    
    .we3(RegWriteW),
    
    .ra1(InstrD[19:15]),
    .ra2(InstrD[24:20]),
    .ra3(RdW),
    
    .wd3(ResultW),
    .rd1(RD1),
    .rd2(RD2)
);


/* 5) EXTEND */
EXTEND EXTENDER(
    .ImmSrc(ImmSrcD),
    .instr(InstrD),
    .ImmExt(ImmExtD)
);


/* 6) REG DECODE */
REG_DECODE DECODE_REGISTER(
    .clk(clk),
    .FlushE(FlushE),
    .PCD(PCD),
    .ImmExtD(ImmExtD),
    .PCPlus4D(PCPlus4D),
    .RD1(RD1),
    .RD2(RD2),
    .Rs1D(Rs1D), // source 1 addr
    .Rs2D(Rs2D), // source 2 addr
    .RdD(RdD), // destination addr
    
    // control unit signals 
    .RegWriteD(RegWriteD),
    .MemWriteD(MemWriteD),
    .JumpD(JumpD),
    .BranchD(BranchD),
    .ALUSrcAD(ALUSrcAD),
    .ALUSrcBD(ALUSrcBD),
    .ResultSrcD(ResultSrcD),
    .MemSizeD(MemSizeD),
    .ALUControlD(ALUControlD),
    
    // control signals output 
    .RegWriteE(RegWriteE),
    .MemWriteE(MemWriteE),
    .JumpE(JumpE),
    .BranchE(BranchE),
    .ALUSrcAE(ALUSrcAE),
    .ALUSrcBE(ALUSrcBE),
    .ResultSrcE(ResultSrcE),
    .MemSizeE(MemSizeE),
    .ALUControlE(ALUControlE),
    
    // data from the regs 
    .RD1E(RD1E),
    .RD2E(RD2E),
    
    // addr of the regs as per the instr
    .Rs1E(Rs1E),
    .Rs2E(Rs2E),
    .RdE(RdE),
    
    // pc , extned and old pc + 4 
    .PCPlus4E(PCPlus4E),
    .ImmExtE(ImmExtE),
    .PCE(PCE),
    
    .Isjalr(Isjalr),
    .IsjalrE(IsjalrE)
    
   
);


/* 7) FORWARDING MUXs */
mux_4x1 FWD1(
    .a(RD1E),
    .b(ResultW),
    .c(ALUResultM),
    .d(32'd0),
    .sel(ForwardAE),
    .y(A)
);

mux_4x1 FWD2(
    .a(RD2E),
    .b(ResultW),
    .c(ALUResultM),
    .d(32'd0),
    .sel(ForwardBE),
    .y(B)
);


/* 7) ALU MUXs */

mux_2x1 ALU_MUXA(
    .a(PCE),
    .b(A),
    .sel(ALUSrcAE),
    .y(SrcAE)
);

mux_2x1 ALU_MUXB(
    .a(B),
    .b(ImmExtE),
    .sel(ALUSrcBE),
    .y(SrcBE)
);


/* 8) ALU */

ALU ALU_UNIT(
    .a(SrcAE),
    .b(SrcBE),
    .ALUControl(ALUControlE),
    .result(ALUResult),
    .Zero(ZeroE),
    .Less(LessE),
    .Less_unsigned(Less_unsignedE)
);

/* 9) EXECUTE REGISTER */
REG_EXECUTE EXECTURE_REG(
    .clk(clk),
   
    .ALUResult(ALUResult),
    .ALUResultM(ALUResultM),  
      
    .WriteDataE(WriteDataE),
    .WriteDataM(WriteDataM),
    
    .RdE(RdE),
    .RdM(RdM),  
      
    .PCPlus4E(PCPlus4E),
    .PCPlus4M(PCPlus4M),
       
    .RegWriteE(RegWriteE),
    .RegWriteM(RegWriteM),  
      
    .MemWriteE(MemWriteE),
    .MemWriteM(MemWriteM),
    
    .ResultSrcE(ResultSrcE),
    .ResultSrcM(ResultSrcM),  
      
    .MemSizeE(MemSizeE),
    .MemSizeM(MemSizeM),
    
    .ImmExtE(ImmExtE),
    .ImmExtM(ImmExtM)
);


/* 10) DATA MEMORY REGISTER */
REG_DATA_MEMORY DM_REG(
    .clk(clk),
    
    .RegWriteM(RegWriteM),
    .RegWriteW(RegWriteW), 
       
    .ResultSrcM(ResultSrcM),
    .ResultSrcW(ResultSrcW), 
       
    .RdM(RdM),
    .RdW(RdW), 
       
    .ReadData(load_data),
    .ReadDataW(ReadDataW),  
         
    .PCPlus4M(PCPlus4M),
    .PCPlus4W(PCPlus4W),
    
    .ALUResultM(ALUResultM),
    .ALUResultW(ALUResultW),
    
    .ImmExtW(ImmExtW),
    .ImmExtM(ImmExtM)
);

/* 11) REUSLT MUX */


reg [31:0] load_data;

always @(*)
begin 
   case (MemSizeM)
        3'b000: load_data = {{24{ReadData[7]}},  ReadData[7:0]};   // LB
        3'b100: load_data = {24'b0, ReadData[7:0]};                  // LBU

        3'b001: load_data = {{16{ReadData[15]}}, ReadData[15:0]}; // LH
        3'b101: load_data = {16'b0, ReadData[15:0]};                 // LHU

        3'b010: load_data = ReadData;                                // LW

        default: load_data = ReadData;
    endcase 
end

mux_4x1 RESULT_MUX(
    .a(ALUResultW),
    .b(load_data),
    .c(PCPlus4W),
    .d(ImmExtW),
    .sel(ResultSrcW),
    .y(ResultW)
);
/* HAZARD UNIT */
Hazard_Unit HAZARD_UNIT_(
    // op
    .ForwardAE(ForwardAE),
    .ForwardBE(ForwardBE),
    .StallF(StallF),
    .StallD(StallD),
    .FlushE(FlushE),
    .FlushD(FlushD),
    .lwStall(lwStall),
    
    // ip 
    .Rs1E(Rs1E),
    .Rs2E(Rs2E),
    .Rs1D(Rs1D),
    .Rs2D(Rs2D),
    .RegWriteM(RegWriteM),
    .RegWriteW(RegWriteW),
    .RdE(RdE),
    .RdM(RdM),
    .RdW(RdW),
    .ResultSrcE0(ResultSrcE[0]),
    .PCSrcE(PCSrcE),
    .ALUSrcBE(ALUSrcBE)
);
endmodule
