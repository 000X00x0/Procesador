module immediate_generator (
    input logic [24:0] instruction,
    input logic [2:0] instr_type,
    output logic [31:0] immediate
);
    always_comb begin
        case (instr_type)
            3'b000: // Tipo I
              immediate = {{19{instruction[24]}}, instruction[24:13]};
            3'b001: // Tipo S
              immediate = {{20{instruction[24]}}, instruction[24:18], instruction[4:0]};
            3'b101: // Tipo B
                immediate = {{20{instruction[24]}} ,instruction[24], instruction[0], instruction[23:18], instruction[4:1], 1'b0};
            3'b110: // Tipo j
                immediate = {{12{instruction[24]}}, instruction[24],instruction[12:5], instruction[13], instruction[23:14], 1'b0};
            default:
                immediate = 32'b0;
        endcase
    end
endmodule