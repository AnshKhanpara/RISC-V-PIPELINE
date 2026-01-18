module ALU 
#(
    parameter data_width = 32
)
(
    input  wire [data_width-1:0] a,
    input  wire [data_width-1:0] b,
    input  wire [3:0]  ALUControl,
    output reg  [data_width-1:0] result,
    output wire        Zero,
    output wire        Less,
    output wire        Less_unsigned
);

always @(*) begin
    case (ALUControl)
        4'b0000: result = a + b;                          // ADD
        4'b0001: result = a - b;                          // SUB
        4'b0010: result = a << b[4:0];                    // SLL
        4'b0011: result = ($signed(a) < $signed(b));      // SLT
        4'b0100: result = (a < b);                         // SLTU
        4'b0101: result = a ^ b;                          // XOR
        4'b0110: result = a >> b[4:0];                    // SRL
        4'b0111: result = $signed(a) >>> b[4:0];          // SRA
        4'b1000: result = a | b;                          // OR
        4'b1001: result = a & b;                          // AND
        default: result = {data_width{1'b0}};
    endcase
end

// THIS ARE THE FLAGS USED BY THE CONTROL UNIT SPECIFICALLY FOR THE Branch INSTRS

assign Zero = (result == 0);
assign Less = $signed(a) < $signed(b);
assign Less_unsigned = ((a < b));

endmodule
