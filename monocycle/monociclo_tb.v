`timescale 1ns/1ps
module monociclo_tb;

    reg clk;
    reg reset;
    wire [31:0] pc;
    wire [31:0] instruction;
    wire [31:0] result;
    wire [31:0] rs1_data;
    wire [31:0] rs2_data;
    wire [31:0] datos_alRegistro;

    // Señales internas de depuración
    wire [1:0] alu_src_sel;
    wire [3:0] alu_control;
    wire [31:0] operand2;
    wire [31:0] alu_op1;
    wire reg_write;
    wire [1:0] reg_src;
	 wire zero;
    wire mem_write;
    wire [2:0] mem_ctrl;
    wire branch_ctrl;
    wire [4:0] br_op;

    // Instancia del DUT con acceso a señales internas
        // Instancia del DUT con acceso a señales internas
    monociclo uut (
        .clk(clk),
        .reset(reset),
        .pc(pc),
        .instruction(instruction),
        .result(result),
        .rs1_data(rs1_data),
        .rs2_data(rs2_data),
        .datos_alRegistro(datos_alRegistro),

        // señales internas exportadas
        .alu_src_sel(alu_src_sel),
        .alu_control(alu_control),
        .reg_write(reg_write),
        .reg_src(reg_src),
        .alu_op1(alu_op1),
        .operand2(operand2),
        .zero(zero),
        .mem_write(mem_write),
        .mem_ctrl(mem_ctrl),
        .branch_ctrl(branch_ctrl),
        .br_op(br_op)
    );

    // Generador de reloj
    initial clk = 0;
    always #10 clk = ~clk;

    // Inicialización
    initial begin
        reset = 1;
        #5 reset = 0;
            $display("Time | PC    | Instr   | rs1_data | rs2_data | alu_op1  | operand2  | ALU_res  | zero | RegWrite | MemWrite | mem_ctrl | alu_src | alu_op | reg_src | branch | br_op");
        $display("----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------");
    end

    // Monitoreo por ciclo
    always @(posedge clk) begin
    $display("%5t | %h | %h | %h | %h | %h | %h | %h | %b | %b         | %b        | %b        | %b      | %b     | %b      | %b     | %b", 
        $time, pc, instruction, rs1_data, rs2_data, alu_op1, operand2,
        result, zero,
        reg_write, mem_write, mem_ctrl,
        alu_src_sel, alu_control, reg_src,
        branch_ctrl, br_op);
    end

    // Fin de simulación
    initial begin
        repeat (20) @(posedge clk);
        $finish;
    end

endmodule
