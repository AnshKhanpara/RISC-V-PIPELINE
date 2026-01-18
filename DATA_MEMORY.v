`timescale 1ns / 1ps
(* dont_touch = "true" *)
module DATA_MEM (
    input clk,
    input MemWrite,          // write enable (sw)
    input [2:0] MemSizeM,    // write size for different sizes
    
    input [31:0] addr,        // address from ALU
    input [31:0] write_data,  // data to store (rs2)
    output [31:0] read_data   // data to load (lw)
);

    reg [31:0] mem [0:255];   // 256 words = 1 KB
    

    integer i;
    initial begin
        for (i = 0; i < 256; i = i + 1)
            mem[i] = 32'b0;
    end
    
    // Read (combinational)
    assign read_data = mem[addr[31:2]];  // word aligned

    // Write (sequential)
    always @(posedge clk) begin
        if (MemWrite) begin
            case(MemSizeM)
                3'b000: mem[addr[31:2]][7:0] <= write_data[7:0];  // store byte
                3'b001: mem[addr[31:2]][15:0] <= write_data[15:0]; // store half word
                3'b010: mem[addr[31:2]] <= write_data; // store word
            endcase
        end
    end

endmodule
