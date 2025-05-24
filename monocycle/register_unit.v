module register_unit (
    input  wire        clk,
    input  wire        reset,       // NUEVO
    input  wire        reg_write,
    input  wire [4:0]  rs1,
    input  wire [4:0]  rs2,
    input  wire [4:0]  rd,
    input  wire [31:0] write_data,
    output wire [31:0] rs1_data,
    output wire [31:0] rs2_data
);
    reg [31:0] regs [31:0];
    integer i;

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            // Inicializa todos los registros a 0 en reset
            for (i = 0; i < 32; i = i + 1)
                regs[i] <= 32'b0;
        end else if (reg_write && rd != 0) begin
            regs[rd] <= write_data;
        end
    end

    assign rs1_data = regs[rs1];
    assign rs2_data = regs[rs2];
endmodule
