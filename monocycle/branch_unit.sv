module branch_unit(
    input logic [31:0] rs1,
    input logic [31:0] rs2,
    input logic [4:0] br_op,
    output logic branch
);
    always_comb begin
        case (br_op)
            5'b00000: branch = 0; // No branch
            5'b01000: branch = (rs1 == rs2); // BEQ
            5'b01001: branch = (rs1 != rs2); // BNE
            5'b01100: branch = (rs1 < rs2); // BLT
            5'b01101: branch = (rs1 >= rs2); // BGE
            //las siguientes son sin signo
            5'b01110: branch = ($unsigned(rs1) < $unsigned(rs2)); // BLTU
            5'b01111: branch = ($unsigned(rs1) >= $unsigned(rs2)); // BGEU
            5'b11111: branch = 1; // JAL
            default: branch = 0; // No branch
        endcase
    end
endmodule