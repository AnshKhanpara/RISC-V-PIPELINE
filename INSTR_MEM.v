(* dont_touch = "true" *)
module INST_MEM
#(
    parameter ADDR_WIDTH = 32,
    parameter DATA_WIDTH = 32,
    parameter MemSize   = 512
)
(
    input   [ADDR_WIDTH - 1:0] addr,
    output  [DATA_WIDTH - 1:0] instr
);

    reg [DATA_WIDTH - 1:0] mem [0:MemSize - 1];

//initial
//begin
//    //$readmemh("instruction.hex", mem);
    
//end


initial begin
// --- PART 1: Data Hazards & Forwarding ---
mem[0]  = 32'h00A00093; // li x1, 10
mem[1]  = 32'h00A00113; // li x2, 20
mem[2]  = 32'h002081B3; // add x3, x1, x2   <- Test Forwarding (x1, x2)
mem[3]  = 32'h00310233; // add x4, x2, x3   <- Test Forwarding (x3 from EX/MEM)
mem[4]  = 32'h404182B3; // sub x5, x3, x4   <- Test Forwarding (x4 from EX/MEM)

// --- PART 2: Load-Use Stalls ---
mem[5]  = 32'h00000317; // auipc x6, 0      <- Base for memory test
mem[6]  = 32'h00032383; // lw x7, 0(x6)     <- Load from mem[0]
mem[7]  = 32'h00730433; // add x8, x6, x7   <- STALL REQUIRED (x7 not ready)

// --- PART 3: Control Hazards (Jumps & Branches) ---
mem[8]  = 32'h00800493; // li x9, 8
mem[9]  = 32'h00948863; // beq x9, x9, 16   <- Branch Taken (Skip 2 instructions)
mem[10] = 32'h00100493; // TRAP: Should be flushed
mem[11] = 32'h00200493; // TRAP: Should be flushed
mem[12] = 32'h00A00513; // li x10, 10       <- Target of Branch
//mem[13] = 32'h0080006F; // jal x0, 8        <- Unconditional Jump to mem[15]
//mem[14] = 32'hDEADBEEF; // TRAP: Should be flushed
mem[13] = 32'h0080016F;
mem[14] = 32'h00000013;
mem[15] = 32'h00100593; // li x11, 1        <- End of test sequence

// --- PART 4: U-Type Instructions (Large Constants) ---
mem[16] = 32'h12345637; // lui x12, 0x12345   <- Loads 0x12345000 into x12
mem[17] = 32'h00001697; // auipc x13, 0x00001 <- x13 = PC + 0x1000

// --- PART 5: JALR & Indirect Jumps ---
mem[18] = 32'h04C00713; // li x14, 76          <- Load address of mem[19] (19*4=76)
mem[19] = 32'h000700E7; // jalr x1, 0(x14)    <- Jump to address in x14 (mem[19])
mem[20] = 32'hDEADBEEF; // TRAP: Should be flushed
mem[21] = 32'h00100793; // li x15, 1          <- Target of JALR: Success!

//mem[0] = 32'h00A00093; // addi x1, x0, 10
//mem[1] = 32'h00102023; // sw   x1, 0(x0)
//mem[2] = 32'h00002103; // lw   x2, 0(x0)
//mem[3] = 32'h00110193; // addi x3, x2, 1
//mem[4] = 32'h00000013; // nop
//mem[5] = 32'h00000013; // nop

//mem[0] = 32'h00900093; // addi x1, x0, 9   (odd)
//mem[1] = 32'h00008067; // jalr x0, x1, 0
//mem[2] = 32'h00100113; // flushed
//mem[3] = 32'h00200193; // flushed
//mem[4] = 32'h00300213; // executes



//    // ---------------- RESET STATE ----------------
//    // x0 = 0 (hardwired)

//    // ---------------- I-TYPE ---------------------
//    mem[0]  = 32'h00500093; // addi x1,  x0, 5
//    mem[1]  = 32'h00a00113; // addi x2,  x0, 10

//    // ---------------- R-TYPE (forwarding) --------
//    mem[2]  = 32'h002081b3; // add  x3,  x1, x2   = 15
//    mem[3]  = 32'h40110233; // sub  x4,  x2, x1   = 5

//    mem[4]  = 32'h0020f2b3; // and  x5,  x1, x2   = 0
//    mem[5]  = 32'h0020e333; // or   x6,  x1, x2   = 15
//    mem[6]  = 32'h0020c3b3; // xor  x7,  x1, x2   = 15
//    mem[7]  = 32'h00209433; // sll  x8,  x1, x2   = 5 << 10 = 0x00001400
//    mem[8]  = 32'h0020a4b3; // slt  x9,  x1, x2   = 1

//    // ---------------- ADDI CHAIN (WB→EX) ---------
//    mem[9]  = 32'h00148513; // addi x10, x9, 1    = 2

//    // ---------------- LOAD / STORE + STALL -------
//    mem[10] = 32'h00a02023; // sw x10, 0(x0)
//    mem[11] = 32'h00002103; // lw x2, 0(x0)       (load-use hazard)

//    // ---------------- BRANCH ---------------------
//    mem[12] = 32'h00210463; // beq x2, x2, +8     (TAKEN)
//    mem[13] = 32'h00100313; // addi x6, x0, 1     (FLUSHED)

//    // ---------------- JAL ------------------------
//    mem[14] = 32'h008000ef; // jal x1, +8         (x1 = PC+4)
//    mem[15] = 32'h00100413; // addi x8, x0, 1     (FLUSHED)

//    // ---------------- JALR -----------------------
//    //mem[16] = 32'h000080e7; // jalr x0, x1, 0     (return)

//    // ---------------- U-TYPE ---------------------
//    mem[16] = 32'h000012b7; // lui   x5, 0x1      = 0x00001000
//    mem[17] = 32'h00001597; // auipc x11, 0x1     = PC + 0x1000

//    // ---------------- NOPs -----------------------
//    mem[19] = 32'h00000013; // nop
//    mem[20] = 32'h00000013; // nop

//// ---------------- SETUP ----------------
//mem[0]  = 32'h00500093; // addi x1, x0, 5        ; x1 = 5
//mem[1]  = 32'h00800113; // addi x2, x0, 8        ; x2 = 8 (branch target offset base)

//// ---------------- BRANCH TEST (NOT TAKEN) ----------------
//mem[2]  = 32'h00208663; // beq  x1, x2, +12      ; NOT taken (5 != 8)
//mem[3]  = 32'h00100193; // addi x3, x0, 1        ; must execute

//// ---------------- BRANCH TEST (TAKEN) ----------------
//mem[4]  = 32'h00500113; // addi x2, x0, 5        ; x2 = 5
//mem[5]  = 32'h00208463; // beq  x1, x2, +8       ; TAKEN
//mem[6]  = 32'h00200213; // addi x4, x0, 2        ; FLUSHED
//mem[7]  = 32'h00300293; // addi x5, x0, 3        ; executes

//// ---------------- JAL TEST ----------------
//mem[8]  = 32'h028003EF; // jal  x7, +8           ; x7 = PC+4
//mem[9]  = 32'h00400313; // addi x6, x0, 4        ; FLUSHED
//mem[10] = 32'h00500393; // addi x7, x0, 5        ; executes

//// ---------------- JALR TEST ----------------
//mem[11] = 32'h03400413; // addi x8, x0, 12       ; jump target (even addr)
//mem[12] = 32'h00040467; // jalr x9, x8, 0        ; x9 = PC+4, PC = x8 & ~1
//mem[13] = 32'h00600493; // addi x9, x0, 6        ; FLUSHED
//mem[14] = 32'h00700513; // addi x10, x0, 7       ; executes
    
    

//mem[0] = 32'h00000517; // auipc x10, 0x0   -> x10 = PC (should be 0x00000000)
//mem[1] = 32'h00400597; // auipc x11, 0x4   -> x11 = PC + 0x4000
//mem[2] = 32'h00450613; // addi  x12, x10, 4  -> x12 = PC+4 (checks forwarding)
//mem[3] = 32'h00b606b3; // add   x13, x12, x11 (pipeline use of AUIPC   

//// -------------------- INIT --------------------
//mem[0]  = 32'h00500093; // addi x1, x0, 5
//mem[1]  = 32'h00a00113; // addi x2, x0, 10

//// -------------------- ARITHMETIC --------------------
//mem[2]  = 32'h002081b3; // add  x3,  x1, x2   = 15
//mem[3]  = 32'h40110233; // sub  x4,  x2, x1   = 5

//// -------------------- LOGIC --------------------
//mem[4]  = 32'h0020f2b3; // and  x5,  x1, x2   = 0
//mem[5]  = 32'h0020e333; // or   x6,  x1, x2   = 15
//mem[6]  = 32'h0020c3b3; // xor  x7,  x1, x2   = 15

//// -------------------- SHIFTS --------------------
//mem[7]  = 32'h00209433; // sll  x8,  x1, x2   = 5 << 10 = 0x1400
//mem[8]  = 32'h0020d4b3; // srl  x9,  x1, x2   = 0
//mem[9]  = 32'h4020d533; // sra  x10, x1, x2   = 0

//// -------------------- COMPARE --------------------
//mem[10] = 32'h0020a5b3; // slt  x11, x1, x2   = 1
//mem[11] = 32'h0020b633; // sltu x12, x1, x2   = 1

//// -------------------- NOPs (pipeline drain) ----
//mem[12] = 32'h00000013; // nop
//mem[13] = 32'h00000013; // nop
//mem[14] = 32'h00000013; // nop
 
end



  
    assign instr = mem[addr[31:2]];  // index pc >> 2 
    // 31:2 because last 2 bits will always be Zero
endmodule
