
module MAIN_DECODER(
input [6:0]opcode,

output reg [2:0] ImmSrc, // chooseing the extender type 
output reg [1:0] alu_op, // used for the alu operation
output reg [1:0] ResultSrc, // to choose which reuslt to be used
output reg alu_srcB, // chosse the B of alu (rs2 or imm value)
output reg alu_srcA, // chosse the A of alu (rs1 or PC - for AUIPC)
output reg Branch, 
output reg Jump,
output reg Isjalr,
output reg RegWrite, // 1 if we write register
output reg MemWrite // 1 if we write in data mem
);

always @(*)
begin 
            RegWrite = 1'b0;
            MemWrite = 1'b0;
            ImmSrc = 3'b000;
            alu_srcA = 1'b1;
            alu_srcB = 1'b1;
            ResultSrc = 2'b00;
            Branch = 1'b0;
            alu_op = 2'b00;
            Jump = 1'b0;
            Isjalr = 1'b0;
    case(opcode)
         
        ///////////// Load Instruction/////////////
        7'b0000011:
        begin 
            RegWrite = 1'b1;
            MemWrite = 1'b0;
            ImmSrc = 3'b000;
            alu_srcB = 1'b1;
            alu_srcA = 1'b1;
            ResultSrc = 2'b01;
            Branch = 1'b0;
            alu_op = 2'b00;
            Jump = 1'b0;
            Isjalr = 1'b0;
        end
        
        ///////////// Store Instruction/////////////
        7'b0100011:
        begin 
            RegWrite = 1'b0;
            MemWrite = 1'b1;
            ImmSrc = 3'b001;
            alu_srcB = 1'b1;
            alu_srcA = 1'b1;
            Branch = 1'b0;
            alu_op = 2'b00;
            Jump = 1'b0;
        end
        
        ///////////// R-TYPE Instruction/////////////
        7'b0110011:
        begin 
            RegWrite = 1'b1;
            MemWrite = 1'b0;
            alu_srcB = 1'b0;
            alu_srcA = 1'b1;
            ResultSrc = 2'b00;
            Branch = 1'b0;
            alu_op = 2'b10;
            Jump = 1'b0;
        end
        
        ///////////// B-TYPE instruction/////////////
        7'b1100011:
        begin 
            RegWrite = 1'b0;
            MemWrite = 1'b0;
            ImmSrc = 3'b10;
            alu_srcB = 1'b0;
            alu_srcA = 1'b1;
            Branch = 1'b1;
            alu_op = 2'b01;
            Jump = 1'b0;
        end
        
        ///////////// I-TYPE Instruction/////////////
        7'b0010011:
        begin 
            RegWrite = 1'b1;
            MemWrite = 1'b0;
            ImmSrc = 3'b000;
            alu_srcB = 1'b1;
            alu_srcA = 1'b1;
            ResultSrc = 2'b00;
            Branch = 1'b0;
            alu_op = 2'b10;
            Jump = 1'b0;
        end
        
        ///////////// JAL/////////////
        7'b1101111:
        begin 
            RegWrite = 1'b1;
            MemWrite = 1'b0;
            ImmSrc = 3'b011;
            ResultSrc = 2'b10;
            Branch = 1'b0;
            Jump = 1'b1;
//            Isjalr = 1'b1;
        end
        
        ///////////// LUI /////////////
  
        7'b0110111:
        begin 
            RegWrite = 1'b1;
            ImmSrc = 3'b100;
            ResultSrc = 2'b11;
        end
        
        ///////////// AUIPC /////////////

        7'b0010111:
        begin 
            RegWrite = 1'b1;
            ImmSrc = 3'b100;
            alu_srcB = 1'b1;
            alu_srcA = 1'b0;
            ResultSrc = 2'b00;
            alu_op = 2'b00;
        end
        
        ///////////// JALR /////////////

        7'b1100111:
        begin 
            RegWrite = 1'b1;
            ImmSrc = 3'b000;
            alu_srcB = 1'b1;
            ResultSrc = 2'b10;
            alu_op = 2'b00;
            Jump = 1'b1;
            Isjalr = 1'b1;
        end
        
        default:
        begin 
            RegWrite = 1'b0;
            MemWrite = 1'b0;
            ImmSrc = 3'b000;
            alu_srcA = 1'b1;
            alu_srcB = 1'b1;
            ResultSrc = 2'b01;
            Branch = 1'b0;
            alu_op = 2'b00;
            Jump = 1'b0;
        end
    endcase
end
endmodule