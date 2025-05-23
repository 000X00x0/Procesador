module instruction_memory (
    input [31:0] address,
    output [31:0] instruction
);

    reg [7:0] mem[0:1023];
    wire [31:0] instr_temp;

    initial begin
        $readmemh("programa.hex", mem); // Carga instrucciones desde archivo externo
    end

    assign instr_temp = {mem[address + 3], mem[address + 2], mem[address + 1], mem[address]};
    assign instruction = instr_temp;

endmodule
