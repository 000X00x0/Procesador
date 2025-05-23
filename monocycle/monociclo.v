module monociclo (
    input clk,
    input reset,
    output [31:0] pc,
    output [31:0] instruction,
    output [31:0] result,
    output [31:0] rs1_data,
    output [31:0] rs2_data,
    output [31:0] datos_alRegistro
);

    // Señales internas
    wire [31:0] next_pc;
    wire [2:0] imm_src;
    wire [31:0] imm;
    wire [1:0] alu_src_sel;
    wire [3:0] alu_control;
    wire [31:0] operand2;
    wire zero;
    wire [4:0] br_op;
    wire branch_ctrl;
    wire branch_taken;
    wire [1:0] reg_src;
    wire reg_write;
    wire mem_write;
    wire [2:0] mem_ctrl;
    wire [31:0] mem_out;
    wire [31:0] alu_op1;

    // PC
    program_counter pc_reg (
        .clk(clk),
        .reset(reset),
        .next_pc(next_pc),
        .pc(pc)
    );

    // Memoria de instrucciones
    instruction_memory instr_mem (
        .address(pc),
        .instruction(instruction)
    );

    // Unidad de control
    control_unit ctrl (
        .opcode(instruction[6:0]),
        .funct3(instruction[14:12]),
        .funct7(instruction[31:25]),
        .reg_write(reg_write),
        .alu_src(alu_src_sel),
        .alu_op(alu_control),
        .mem_write(mem_write),
        .mem_ctrl(mem_ctrl),
        .imm_src(imm_src),
        .reg_src(reg_src),
        .branch(branch_ctrl),         // ← Renombrada
        .br_op(br_op)
    );

    // Generador de inmediato
    immediate_generator imm_gen (
        .instruction(instruction),
        .instr_type(imm_src),
        .immediate(imm)
    );

    // Registros
    register_unit reg_file (
        .clk(clk),
        .reg_write(reg_write),
        .rs1(instruction[19:15]),
        .rs2(instruction[24:20]),
        .rd(instruction[11:7]),
        .write_data(datos_alRegistro),
        .rs1_data(rs1_data),
        .rs2_data(rs2_data)
    );

    assign operand2 = (alu_src_sel == 2'b00) ? rs2_data : imm;
    assign alu_op1 = rs1_data;

    // ALU
    alu alu_core (
        .operand1(alu_op1),
        .operand2(operand2),
        .alu_control(alu_control),
        .result(result),
        .zero(zero)
    );

    // Unidad de salto condicional
    branch_unit br_unit (
        .rs1_data(rs1_data),
        .rs2_data(rs2_data),
        .br_op(br_op),
        .branch(branch_taken)
    );

    // Memoria de datos
    data_memory dmem (
        .clk(clk),
        .mem_write(mem_write),
        .mem_ctrl(mem_ctrl),
        .address(result),
        .write_data(rs2_data),
        .read_data(mem_out)
    );

    // MUX resultado al registro
    assign datos_alRegistro = (reg_src == 2'b00) ? result :
                              (reg_src == 2'b01) ? mem_out :
                              (reg_src == 2'b10) ? (pc + 4) :
                              32'b0;

    // Cálculo de próximo PC con combinación de branch
    assign next_pc = (branch_ctrl | branch_taken) ? result : (pc + 4);

endmodule
