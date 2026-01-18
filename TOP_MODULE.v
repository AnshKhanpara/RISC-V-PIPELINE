module TOP_MODULE(
    input clk,
    input reset
//    output reg dbg

    );
    
wire [31:0] Instr;
wire [31:0] PCF;
wire  MemWriteM;
wire [31:0] ReadData;
wire [31:0] ALUResultM;
wire [31:0] WriteDataM;

wire [2:0] MemSizeM;
/*---------------- RISC CORE ---------------*/
(* dont_touch = "true" *)
RISC_CORE CORE(
    .clk(clk),
    .reset(reset),
    
    .Instr(Instr),
    .PCF(PCF),
    .ReadData(ReadData),
    .ALUResultM(ALUResultM),
    .WriteDataM(WriteDataM),
    .MemWriteM(MemWriteM),
    .MemSizeM(MemSizeM)
);

/*---------------- INSTRUCTION MEMORY ---------------*/
(* dont_touch = "true" *)
INST_MEM INSTR_MEM(
    .addr(PCF),
    .instr(Instr)
);


/*---------------- DATA MEMORY ---------------*/
(* dont_touch = "true" *)
DATA_MEM DATA_MEMORY(
    .clk(clk),
    .MemWrite(MemWriteM),
    .MemSizeM(MemSizeM),
    .addr(ALUResultM),
    .write_data(WriteDataM),
    .read_data(ReadData)
);

//always @(posedge clk) begin
//  if (reset)
//    dbg <= 1'b0;
//  else
//    dbg <= PCF[0] ^ Instr[0] ^ ALUResultM[0] ^ WriteDataM[0];
//end

endmodule
