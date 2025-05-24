module control_unit (
    input [6:0] opcode,
    input [2:0] funct3,
    input [6:0] funct7,
    output reg reg_write,
    output reg [1:0] alu_src,
    output reg [3:0] alu_op,
    output reg mem_write,
    output reg [2:0] mem_ctrl,
    output reg [2:0] imm_src,
    output reg [1:0] reg_src,
    output reg branch,
    output reg [4:0] br_op
);

    always @(*) begin
        reg_write = 0;
        alu_src = 2'b00;
        alu_op = 4'b0000;
        mem_write = 0;
        mem_ctrl = 3'b000;
        imm_src = 3'b000;
        reg_src = 2'b00;
        branch = 0;
        br_op = 5'b00000;

        case (opcode)
            7'b0110011: begin // R-type
                reg_write = 1;
                alu_src = 2'b00;
                alu_op = {funct7[5], funct3};
            end

            7'b0010011: begin // I-type (ADDI, etc.)
                reg_write = 1;
                alu_src = 2'b01;
                alu_op = {1'b0, funct3};
                imm_src = 3'b000;
            end

            7'b0000011: begin // Loads
                reg_write = 1;
                alu_src = 2'b01;
                alu_op = 4'b0000;
                imm_src = 3'b000;
                reg_src = 2'b01;
                mem_ctrl = {1'b0, funct3[1:0]};
            end

            7'b0100011: begin // Stores
                alu_src = 2'b01;
                alu_op = 4'b0000;
                mem_write = 1;
                imm_src = 3'b001;
                mem_ctrl = funct3;
            end

            7'b1100011: begin // Branches
                alu_op = 4'b1000;
                branch = 1;
                imm_src = 3'b101;
                br_op = {2'b01, funct3};
            end

            7'b1101111: begin // JAL
                reg_write = 1;
                reg_src = 2'b10;
                imm_src = 3'b110;
                alu_op = 4'b0000;
                branch = 1;
                br_op = 5'b11111;
            end
        endcase
    end
endmodule
