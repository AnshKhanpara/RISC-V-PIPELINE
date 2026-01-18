module Hazard_Unit(
    // controling the RAW hazard using the forwarding 
    input [4:0] Rs1E,
    input [4:0] Rs2E,
    input [4:0] Rs1D,
    input [4:0] Rs2D,
    input RegWriteM,
    input RegWriteW,
    input [4:0] RdE,
    input [4:0] RdM,
    input [4:0] RdW,
    input  ResultSrcE0,
    input [1:0] PCSrcE,
    input ALUSrcBE,
    
    output reg [1:0] ForwardAE, // we will have the mux for ip of the alu's mux for forwading
    output reg [1:0] ForwardBE,
    
    output reg StallF,
    output reg StallD,
    output reg FlushE,
    output reg FlushD,
    output reg lwStall // we can use this as a flag to see if there is a stall or not 
    );
    
always @(*) begin
        ForwardAE = 2'b00;
        ForwardBE = 2'b00;
    
        // Rs1E
        if (RegWriteM && (RdM != 0) && (RdM == Rs1E))
            ForwardAE = 2'b10;
        else if (RegWriteW && (RdW != 0) && (RdW == Rs1E))
            ForwardAE = 2'b01;
    
        // Rs2E
        if (RegWriteM && (RdM != 0) && (RdM == Rs2E))
            ForwardBE = 2'b10;
        else if (RegWriteW && (RdW != 0) && (RdW == Rs2E))
            ForwardBE = 2'b01;
    end


always @(*) // stall 
begin
    StallF = 0;
    StallD = 0;
    lwStall = 0; 
    if(((Rs1D == RdE) || (Rs2D == RdE)) && (RdE != 5'd0) && (ResultSrcE0)) 
    begin 
        StallF = 1;
        StallD = 1;
        lwStall = 1;
    end
end

always @(*)
begin 
    FlushE = 0;
    FlushD = 0;
    
    if(PCSrcE != 2'b00)
    begin 
        FlushE = 1;
        FlushD = 1;
    end
    
    else 
    begin 
        if(lwStall)
            FlushE = 1;
    end
    
end
endmodule
