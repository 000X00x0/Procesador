module monociclo (
    input  wire        clk,
    input  wire        reset,
    output wire [31:0] pc,
    output wire [31:0] instruction,
    output wire [31:0] result,
    output wire [31:0] rs1_data,
    output wire [31:0] rs2_data,
    output wire [31:0] datos_alRegistro,

    // salidas de depuración para testbench
    output wire [1:0]  alu_src_sel,
    output wire [3:0]  alu_control,
    output wire        reg_write,
    output wire [1:0]  reg_src,
    output wire [31:0] alu_op1,
    output wire [31:0] operand2,
    output wire        zero,         // ahora conectado directamente
    output wire        mem_write,    // ahora conectado directamente
    output wire [2:0]  mem_ctrl,     // ahora conectado directamente
    output wire        branch_ctrl,  // ahora conectado directamente
    output wire [4:0]  br_op         // ahora conectado directamente
);

    // Señales internas mínimas
    wire [31:0] next_pc;
    wire [2:0]  imm_src;
    wire [31:0] imm;
    wire        branch_taken;
    wire [31:0] mem_out;

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

    // Unidad de control (control_unit)
    control_unit ctrl (
        .opcode    (instruction[6:0]),
        .funct3    (instruction[14:12]),
        .funct7    (instruction[31:25]),
        .reg_write (reg_write),
        .alu_src   (alu_src_sel),
        .alu_op    (alu_control),
        .mem_write (mem_write),     // conexión directa
        .mem_ctrl  (mem_ctrl),      // conexión directa
        .imm_src   (imm_src),
        .reg_src   (reg_src),
        .branch    (branch_ctrl),   // conexión directa
        .br_op     (br_op)          // conexión directa
    );

    // Generador de inmediato
    immediate_generator imm_gen (
        .instruction(instruction),
        .instr_type(imm_src),
        .immediate(imm)
    );

    // Banco de registros
    register_unit reg_file (
        .clk        (clk),
		  .reset     (reset),
        .reg_write  (reg_write),
        .rs1        (instruction[19:15]),
        .rs2        (instruction[24:20]),
        .rd         (instruction[11:7]),
        .write_data (datos_alRegistro),
        .rs1_data   (rs1_data),
        .rs2_data   (rs2_data)
    );

    // Preparación de operandos para la ALU
    assign operand2 = (alu_src_sel == 2'b00) ? rs2_data : imm;
    assign alu_op1  = rs1_data;

    // ALU
    alu alu_core (
        .operand1   (alu_op1),
        .operand2   (operand2),
        .alu_control(alu_control),
        .result     (result),
        .zero       (zero)          // conexión directa
    );

    // Unidad de salto condicional
    branch_unit br_unit (
        .rs1_data(rs1_data),
        .rs2_data(rs2_data),
        .br_op    (br_op),
        .branch   (branch_taken)
    );

    // Memoria de datos
    data_memory dmem (
        .clk        (clk),
        .mem_write  (mem_write),
        .mem_ctrl   (mem_ctrl),
        .address    (result),
        .write_data (rs2_data),
        .read_data  (mem_out)
    );

    // MUX: qué escribir en el registro destino
    assign datos_alRegistro = (reg_src == 2'b00) ? result     :
                              (reg_src == 2'b01) ? mem_out    :
                              (reg_src == 2'b10) ? (pc + 4)   :
                                                   32'b0     ;

    // Cálculo de próximo PC (secuencia o branch)
    assign next_pc = (branch_ctrl && branch_taken) ? result : (pc + 4);

endmodule
