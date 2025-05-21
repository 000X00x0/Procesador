module monociclo(
    input clk,
    input reset,
    output [31:0] pc,
    output [31:0] instruction,
    output [4:0] read_reg1,
    output [4:0] read_reg2,
    output [4:0] write_reg,
    output reg_write,
    output [31:0] read_data1,
    output [31:0] read_data2,
    output [6:0] opCode,
    output [2:0] fun3,
    output [6:0] fun7
);
    wire [31:0] next_pc;
    wire [31:0] pc_plus_4 = pc + 4;

    assign opCode = instruction[6:0];
    assign fun3 = instruction[14:12];
    assign fun7 = instruction[31:25];
    assign read_reg1 = instruction[19:15];
    assign read_reg2 = instruction[24:20];
    assign write_reg = instruction[11:7];

    program_counter pc_reg (
        .clk(clk),
        .reset(reset),
        .next_pc(next_pc),
        .pc(pc)
    );

    instruction_memory imem (
        .address(pc),
        .instruction(instruction)
    );

    control_unit control (
        .opCode(opCode),
        .fun3(fun3),
        .fun7(fun7),
        .RUWr(reg_write)
    );

    register_unit reg_file (
        .clk(clk),
        .read_reg1(read_reg1),
        .read_reg2(read_reg2),
        .write_reg(write_reg),
        .write_data(pc_plus_4),
        .reg_write(reg_write),
        .read_data1(read_data1),
        .read_data2(read_data2)
    );

    assign next_pc = pc_plus_4;
endmodule