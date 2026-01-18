`timescale 1ns / 1ps

module REG_FILE(

input clk,
input we3, // write enable
input [4:0] ra1, // addr of 1st reg rs1
input [4:0] ra2, // addr of 2nd reg rs2
input [4:0] ra3,  // addr of destination reg rd

input [31:0] wd3, // write data
output [31:0] rd1, // read data 1
output [31:0] rd2 // read data 2
    );
    
reg [31:0] regs [31:0];  ///32 registers of each 32 bits


//special x0 is values as 0 , so we read it then output is 0 and if we write it , its content doesnt change
assign rd1 = (ra1 == 0) ? 0 : regs[ra1]; 
assign rd2 = (ra2 == 0) ? 0 : regs[ra2];

integer i;

initial 
begin 
// initially all reg have defualt value as 0 
    for(i=0;i<32;i = i + 1)
    begin 
        regs[i] = 0;
    end
end

always @(negedge clk)
begin 
    if(we3 && (ra3 != 0))  // if write enable and write address is not x0
    begin 
       regs[ra3] <= wd3;
    end
end
endmodule
