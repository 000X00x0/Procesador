module monociclo (
    input logic clk,
    input logic reset,
    output logic [31:0] pc,
    output logic [31:0] instruction,
    output logic [31:0] result,
    output logic rs1R,rs2R,
    output logic [31:0] rs1_data,rs2_data,
    output logic [31:0] datos_alRegistro 
);
    // Señales internas
    logic [31:0] next_pc;
    logic [31:0] pc_plus_4;
    logic [31:0] rs1;
    logic [31:0] rs2;
    logic [31:0] imm;
    logic [31:0] ALUASrc_result;
    logic [31:0] ALUBSrc_result;
    logic [6:0] opCode;
    logic DMWr;
    logic [2:0] ImmSrc;
    logic ALUBSrc;
    logic [4:0] BrOp;
    logic [1:0] RUDataWrSrc;
    logic ALUASrc;
    logic [3:0] ALUOpcode;
    logic [2:0] DMCtrl;
    logic RUWr;
    logic [31:0] dm_read_data;
    logic [31:0] ru_wr_src;
    logic [31:0] resultado_alu;
    logic [2:0] fun3;
    logic [6:0] fun7;
    logic branch;

    program_counter pc_inst (
        .clk(clk),
        .reset(reset),
        .next_pc(next_pc),
        .pc(pc)
    );

    instruction_memory im_inst (
        .address(pc),
        .instruction(instruction)
    );

    assign opCode = instruction[6:0];
    assign fun3 = instruction[14:12];
    assign fun7 = instruction[31:25];
    
    control_unit cu_inst (
        .opCode(opCode),
        .fun3(fun3),
        .fun7(fun7),
        .DMWr(DMWr),
        .ImmSrc(ImmSrc),
        .ALUBSrc(ALUBSrc),
        .BrOp(BrOp),
        .RUDataWrSrc(RUDataWrSrc),
        .ALUASrc(ALUASrc),
        .ALUOpcode(ALUOpcode),
        .DMCtrl(DMCtrl),
        .RUWr(RUWr)
    );
    
    register_unit ru_inst (
        .clk(clk),
        .read_reg1(instruction[19:15]),
        .read_reg2(instruction[24:20]),
        .write_reg(instruction[11:7]),
        .write_data(ru_wr_src),
        .reg_write(RUWr),
        .read_data1(rs1),
        .read_data2(rs2)
    );

    immediate_generator imm_gen_inst (
        .instruction(instruction[31:7]),
        .instr_type(ImmSrc),
        .immediate(imm)
    );

    branch_unit bu_inst (
        .rs1(rs1),
        .rs2(rs2),
        .br_op(BrOp),
        .branch(branch)
    );
    
    assign ALUASrc_result = (ALUASrc) ? pc : rs1;
    assign ALUBSrc_result = (ALUBSrc) ? imm : rs2;

    alu alu_inst (
        .operand1(ALUASrc_result),
        .operand2(ALUBSrc_result),
        .alu_control(ALUOpcode),
        .result(resultado_alu),
        .zero()
    );

    data_memory dm_inst (
        .clk(clk),
        .mem_write(DMWr),
        .mem_ctrl(DMCtrl),
        .address(resultado_alu),
        .write_data(rs2),
        .read_data(dm_read_data)
    );
    
    assign pc_plus_4 = pc + 32'd4;
    assign next_pc = (branch) ? resultado_alu : pc_plus_4;
    
    always_comb begin
        case (RUDataWrSrc)
            2'b00: ru_wr_src = resultado_alu;
            2'b01: ru_wr_src = dm_read_data;
            2'b10: ru_wr_src = pc_plus_4;
            default: ru_wr_src = 32'b0;
        endcase
    end
    
    assign result = resultado_alu;
    assign rs1R = ALUASrc;
    assign rs2R = ALUBSrc;
    assign rs1_data = ALUASrc_result;
    assign rs2_data = ALUBSrc_result;
    assign datos_alRegistro = ru_wr_src;
endmodule