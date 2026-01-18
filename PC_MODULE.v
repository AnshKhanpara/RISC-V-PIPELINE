`timescale 1ns / 1ps


module PC_MODULE(
input [31:0] pc_next,
input clk,
input reset, // active high reset
input StallF, // stall signal from the hazard unit
output reg [31:0] pc
    );
   
always @(posedge clk)
begin 
    if(reset)
    begin 
        pc <= 32'b0;
    end
    
    else 
    begin 
        if(!StallF)
           pc <= pc_next;
        else
           pc <= pc;
    end
end
endmodule
