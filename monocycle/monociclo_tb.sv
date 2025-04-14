`timescale 1ns/1ps

module monociclo_tb;
    reg clk;
    reg reset;
    wire [31:0] pc;
    wire [31:0] instruction;

monociclo uut (
    .clk(clk),
    .reset(reset),
    .pc(pc),
    .instruction(instruction),
    .read_reg1(),   
    .read_reg2(), 
    .write_reg(),
    .reg_write(),
    .read_data1(),
    .read_data2(),
    .opCode(),
    .fun3(),
    .fun7()
);

     // --- Generación de reloj ---
    initial begin
        clk = 0;
        forever #5 clk = ~clk; // Periodo de 10 ns (50 MHz)
    end

    // --- Secuencia de reset ---
    initial begin
        reset = 1;
        #10; 
        reset = 0;
    end

    // --- Monitorización ---
    initial begin
        $monitor("Time = %t ns | PC = %h | Instruction = %h", 
                 $time, pc, instruction);
    end

    initial begin
        #300; // Límite en ns
        $display("\n[WATCHDOG] Tiempo de simulación excedido");
        $finish;
    end
endmodule