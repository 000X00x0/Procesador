module register_unit (
    input clk,
    input [4:0] read_reg1,
    input [4:0] read_reg2,
    input [4:0] write_reg,
    input [31:0] write_data,
    input reg_write,
    output [31:0] read_data1,
    output [31:0] read_data2
);
    reg [31:0] registers [0:31];
    integer i;

    // Inicialización (solo para simulación)
    initial begin
        for (i = 0; i < 32; i = i + 1)
            registers[i] = 32'b0;
    end

    // Lectura asíncrona
    assign read_data1 = (read_reg1 != 0) ? registers[read_reg1] : 32'b0;
    assign read_data2 = (read_reg2 != 0) ? registers[read_reg2] : 32'b0;

    // Escritura síncrona
    always @(posedge clk) begin
        if (reg_write && write_reg != 0)
            registers[write_reg] <= write_data;
    end
endmodule