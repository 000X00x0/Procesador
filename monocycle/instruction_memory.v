module instruction_memory (
    input [31:0] address,
    output [31:0] instruction
);

    reg [7:0] mem[0:1023];
    wire [31:0] instr_temp;

    integer i;
    initial begin
        $readmemh("programa.hex", mem);
        for (i = 0; i < 24; i = i + 1) begin
            $display("mem[%0d] = %h", i, mem[i]);
        end
    end

    // Protección contra acceso fuera de rango
    wire [31:0] safe_addr = (address + 3 < 1024) ? address : 0;

    assign instr_temp = {mem[safe_addr + 3], mem[safe_addr + 2], mem[safe_addr + 1], mem[safe_addr]};
    assign instruction = instr_temp;

endmodule
