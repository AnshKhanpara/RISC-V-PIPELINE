module EXTEND(
    input      [2:0]  ImmSrc, // select the TYPE OF INSTR
    input      [31:0] instr, 
    output reg [31:0] ImmExt // output 32 bit IMM
);

always @(*) begin
    case (ImmSrc)

        3'b000: // I-TYPE (addi, loads)
            begin 
                case(instr[14:12])
                    3'b101:
                    begin 
                        if(instr[6:0] == 7'b0010011) // this will not let load hadf word enter this
                        begin 
                            ImmExt = {27'b0,instr[24:20]}; // For srai and srli as they take only 5 bit imm
                        end 
                        else 
                            ImmExt = {{20{instr[31]}}, instr[31:20]};
                    end
                    default:ImmExt = {{20{instr[31]}}, instr[31:20]};
                endcase
            end
        3'b001: // S-TYPE
            ImmExt = {{20{instr[31]}}, instr[31:25], instr[11:7]};

        3'b010: // B-TYPE
            ImmExt = {{19{instr[31]}}, instr[31], instr[7],
                      instr[30:25], instr[11:8], 1'b0};

        3'b011: // J-TYPE
            ImmExt = {{11{instr[31]}}, instr[31],
                      instr[19:12], instr[20], instr[30:21], 1'b0};

        3'b100: // U-TYPE (LUI / AUIPC)
            ImmExt = instr[31:12] << 12;


        default:
            ImmExt = 32'b0;
    endcase
end

endmodule
