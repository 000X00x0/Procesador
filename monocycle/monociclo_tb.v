`timescale 1ns/1ps
module monociclo_tb;

    reg clk;
    reg reset;
    wire [31:0] pc;
    wire [31:0] instruction;
    wire [31:0] result;
    wire [31:0] rs1_data;
    wire [31:0] rs2_data;
    wire [31:0] datos_alRegistro;

    // Instancia del DUT
    monociclo uut (
        .clk(clk),
        .reset(reset),
        .pc(pc),
        .instruction(instruction),
        .result(result),
        .rs1_data(rs1_data),
        .rs2_data(rs2_data),
        .datos_alRegistro(datos_alRegistro)
    );

    // Generador de reloj
    always #10 clk = ~clk;

    initial begin
        $display("Time | PC        | Instr     | rs1_data  | rs2_data  | Result    | WB");
        $monitor("%4dns | %h | %h | %h | %h | %h | %h",
                 $time, pc, instruction, rs1_data, rs2_data, result, datos_alRegistro);

        // Inicialización
        clk = 0;
        reset = 1;
        #25;
        reset = 0;

        // Simular durante 20 ciclos de reloj
        repeat (20) @(posedge clk);

        $finish;
    end

endmodule
