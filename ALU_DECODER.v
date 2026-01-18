module ALU_DECODER(
input [1:0] alu_op,
input [2:0]funct3,
input funct7_5,

output reg[3:0] ALU_CONTROL

);

always @(*)
begin 
ALU_CONTROL = 4'b0000;
    case(alu_op)
        /////////////LOAD AND STORE INSTRUCTION//////////////
        2'b00:
        begin 
            ALU_CONTROL = 4'b0000; // a + b
        end
        
        //////////////B-TYPE BEQ /////////////////////////////
        2'b01:
        begin 
            ALU_CONTROL = 4'b0001; // a - b
        end
        
        ///////////////ALU FOR R TYPE AND I TYPE///////////////
        
        2'b10:
        begin 
            case(funct3)
                3'b000:
                begin 
                    if(funct7_5 == 1'b1)
                        ALU_CONTROL = 4'b0001;
                    else 
                        ALU_CONTROL = 4'b0000;
                end
                
                3'b001: ALU_CONTROL = 4'b0010;
                
                3'b010: ALU_CONTROL = 4'b0011;
                
                3'b011: ALU_CONTROL = 4'b0100;
                
                3'b100: ALU_CONTROL = 4'b0101;
                
                3'b101: 
                begin
                    if(funct7_5 == 1'b1)
                        ALU_CONTROL = 4'b0111;
                    else 
                        ALU_CONTROL = 4'b0110;
                end 
                
                3'b110: ALU_CONTROL = 4'b1000;
                
                3'b111: ALU_CONTROL = 4'b1001;
                
                default: ALU_CONTROL = 4'b0000;
            endcase
        end
        default: ALU_CONTROL = 4'b0000;
    endcase
end
endmodule