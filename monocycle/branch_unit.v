module branch_unit (
    input [31:0] rs1_data,
    input [31:0] rs2_data,
    input [4:0] br_op,
    output reg branch
);
    always @(*) begin
        case (br_op)
            5'b01000: branch = (rs1_data == rs2_data);
            5'b01001: branch = (rs1_data != rs2_data);
            5'b01100: branch = ($signed(rs1_data) < $signed(rs2_data));
            5'b01101: branch = ($signed(rs1_data) >= $signed(rs2_data));
            5'b01110: branch = (rs1_data < rs2_data);
            5'b01111: branch = (rs1_data >= rs2_data);
            5'b11111: branch = 1;
            default: branch = 0;
        endcase
    end
endmodule
