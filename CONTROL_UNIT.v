`timescale 1ns / 1ps
(* dont_touch = "true" *)
module CONTROL_UNIT(

input [6:0] opcode,
input [2:0] funct3,
input  funct7_5,
//input Zero,
//input Less,
//input Less_unsigned,

output RegWriteD,
output [2:0] ImmSrcD,
output ALUSrcAD,
output ALUSrcBD,
output [3:0] ALUControlD,
output MemWriteD,
output [1:0] ResultSrcD,
output BranchD,
output JumpD,
//output [1:0] PCSrcD,
output Isjalr,
output reg [2:0] MemSizeD // msb for sign and last 2 bits for the size of the data
     );


wire [1:0] alu_op;

always @(*)
begin 
    MemSizeD = 3'b000;
    
    case(opcode)
        7'b0000011: // LOAD
        begin 
            MemSizeD[2:0] = funct3[2:0];
        end
        
        7'b0100011:
        begin 
            MemSizeD[2] = 1'b0; // always Zero or dontcare
            MemSizeD[1:0] = funct3[1:0];
        end
        default MemSizeD = 3'b000;
    endcase
end

MAIN_DECODER m1(
.opcode(opcode),
.RegWrite(RegWriteD),
.ImmSrc(ImmSrcD),
.alu_srcA(ALUSrcAD),
.alu_srcB(ALUSrcBD),
.alu_op(alu_op),
.MemWrite(MemWriteD),
.ResultSrc(ResultSrcD),
.Branch(BranchD),
.Jump(JumpD),
.Isjalr(Isjalr)
);

ALU_DECODER a1(
.alu_op(alu_op),
.funct3(funct3),
.ALU_CONTROL(ALUControlD),
.funct7_5(funct7_5)
);   

endmodule




