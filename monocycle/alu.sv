module alu (
    input logic [31:0] operand1,
    input logic [31:0] operand2,
    input logic [3:0] alu_control,
    output logic [31:0] result,
    output logic zero
);
    always_comb begin
        case (alu_control)
            4'b0000: result = operand1 + operand2; // Suma
            4'b1000: result = operand1 - operand2; // Resta
            4'b0001: result = operand1 << operand2[4:0]; // Corrimiento a la izquierda
            4'b0010: result = (operand1 < operand2) ? 32'b1 : 32'b0; // Set less than
            4'b0011: result = ($unsigned(operand1) < $unsigned(operand2)) ? 32'b1 : 32'b0; // Set less than (unsigned)
            4'b0100: result = operand1 ^ operand2; // XOR
            4'b0101: result = operand1 >> operand2[4:0]; // Corrimiento a la derecha lógico
            4'b1101: result = $signed(operand1) >>> operand2[4:0]; // Corrimiento a la derecha aritmético
            4'b0110: result = operand1 | operand2; // OR
            4'b0111: result = operand1 & operand2; // AND
            default: result = 32'b0; // Operación no definida
        endcase
        zero = (result == 32'b0);
    end
endmodule