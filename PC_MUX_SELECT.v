(* dont_touch = "true" *)
module PC_MUX_SELECT(
    input JumpE,
    input BranchE,
    input ZeroE,
    input LessE,
    input Less_unsignedE,
    input IsjalrE,
    input [2:0] funct3,
    input [6:0] opcode,
    output  [1:0] PCSrcE
    );
wire BranchE_select;
    
assign BranchE_select =
    (funct3 == 3'b000 && ZeroE)    || // BEQ
    (funct3 == 3'b001 && !ZeroE)   || // BNE
    (funct3 == 3'b100 && LessE)    || // BLT Signed
    (funct3 == 3'b101 &&  !LessE)  || // BGE Signed
    (funct3 == 3'b110 &&  Less_unsignedE) || // BLTU
    (funct3 == 3'b111 && !Less_unsignedE);   // BGEU   

assign PCSrcE = (IsjalrE && JumpE) ? 2'b10 : (JumpE ? 2'b01 : (BranchE && BranchE_select ? 2'b01 : 2'b00));

endmodule     

   
