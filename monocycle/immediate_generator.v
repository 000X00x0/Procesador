module immediate_generator (
    input [31:0] instruction,
    input [2:0] instr_type,
    output reg [31:0] immediate
);
    always @(*) begin
        case (instr_type)
            3'b000: immediate = {{20{instruction[31]}}, instruction[31:20]}; // I-type
            3'b001: immediate = {{20{instruction[31]}}, instruction[31:25], instruction[11:7]}; // S-type
            3'b101: immediate = {{19{instruction[31]}}, instruction[31], instruction[7], instruction[30:25], instruction[11:8], 1'b0}; // B-type
            3'b110: immediate = {{11{instruction[31]}}, instruction[31], instruction[19:12], instruction[20], instruction[30:21], 1'b0}; // J-type
            default: immediate = 32'b0;
        endcase
    end
endmodule
