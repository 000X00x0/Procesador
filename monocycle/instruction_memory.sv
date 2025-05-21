module instruction_memory (
    input logic [31:0] address,
    output logic [31:0] instruction
);
    logic [7:0] memory [0:1023];

    assign instruction = {memory[address], memory[address+1], memory[address+2], memory[address+3]};

    initial begin
        memory[0] = 8'h13; // NOP (addi x0, x0, 0)
        memory[1] = 8'h00;
        memory[2] = 8'h00;
        memory[3] = 8'h00;
        
        memory[4] = 8'h00; // addi x1, x0, 1
        memory[5] = 8'h10;
        memory[6] = 8'h00;
        memory[7] = 8'h93;
        
        memory[8] = 8'h00; // addi x2, x0, 2
        memory[9] = 8'h20;
        memory[10] = 8'h01;
        memory[11] = 8'h13;

        memory[12] = 8'h00; // add x3, x2, x1
        memory[13] = 8'h20;
        memory[14] = 8'h81;
        memory[15] = 8'hb3;

        memory[16] = 8'h00; // sh x3, 0(x0)
        memory[17] = 8'h30;
        memory[18] = 8'h10;
        memory[19] = 8'h23;

        memory[20] = 8'h00; // lh x4, 0(x0)
        memory[21] = 8'h00;
        memory[22] = 8'h12;
        memory[23] = 8'h03;

        memory[24] = 8'h00; // blt x3, x2, 8
        memory[25] = 8'h31;
        memory[26] = 8'h44;
        memory[27] = 8'h63;

        memory[28] = 8'h01; // jalr x6, 16(x0)
        memory[29] = 8'h00;
        memory[30] = 8'h03;
        memory[31] = 8'h67;

        memory[32] = 8'hff; // jal x5, -4
        memory[33] = 8'hdf;
        memory[34] = 8'hf2;
        memory[35] = 8'hef;
    end
endmodule