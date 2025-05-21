module instruction_memory(
    input [31:0] address,
    output [31:0] instruction
);
    reg [7:0] memory [0:1023]; // 1KB de memoria

    assign instruction = {memory[address+3], memory[address+2], 
                         memory[address+1], memory[address]};

initial begin
    for (int i = 0; i < 1024; i += 4) begin
        {memory[i+3], memory[i+2], memory[i+1], memory[i]} = 32'h00000013;
    end

    {memory[3], memory[2], memory[1], memory[0]} = 32'h00100093; // addi x1, x0, 1
    {memory[7], memory[6], memory[5], memory[4]} = 32'h00200113; // addi x2, x0, 2
    {memory[11], memory[10], memory[9], memory[8]} = 32'h002081b3; // add x3, x1, x2
    {memory[15], memory[14], memory[13], memory[12]} = 32'h00000063; // beq x0, x0, 0 (bucle infinito)
end
endmodule