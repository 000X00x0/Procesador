module register_unit (
    input logic clk,
    input logic [4:0] read_reg1,
    input logic [4:0] read_reg2,
    input logic [4:0] write_reg,
    input logic [31:0] write_data,
    input logic reg_write,
    output logic [31:0] read_data1,
    output logic [31:0] read_data2
);
    logic [31:0] registers [0:31];

    assign read_data1 = registers[read_reg1];
    assign read_data2 = registers[read_reg2];
    
    always_ff @(posedge clk) begin
        registers[0] <= 32'b0;
        if (reg_write)
            registers[write_reg] <= write_data;
    end
endmodule