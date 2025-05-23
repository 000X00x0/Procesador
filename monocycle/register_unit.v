module register_unit (
    input clk,
    input reg_write,
    input [4:0] rs1,
    input [4:0] rs2,
    input [4:0] rd,
    input [31:0] write_data,
    output [31:0] rs1_data,
    output [31:0] rs2_data
);
    reg [31:0] registers[0:31];

    always @(posedge clk) begin
        if (reg_write && rd != 0)
            registers[rd] <= write_data;
    end

    assign rs1_data = (rs1 == 0) ? 32'b0 : registers[rs1];
    assign rs2_data = (rs2 == 0) ? 32'b0 : registers[rs2];
endmodule
