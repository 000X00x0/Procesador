module monociclo_tb;
    // Señales de prueba
    reg clk;
    reg reset;
    wire [31:0] pc;
    wire [31:0] instruction;
    
    // Conexiones entre módulos
    wire [31:0] next_pc;
    wire pc_write;
    wire [31:0] imem_address;
    
    // Instancia del program counter
    program_counter pc_unit (
        .clk(clk),
        .reset(reset),
        .next_pc(next_pc),
        .pc_write(pc_write),
        .pc(pc)
    );
    
    // Instancia de la memoria de instrucciones
    instruction_memory imem (
        .address(imem_address),
        .instruction(instruction)
    );
    
    // Instancia de la unidad de control
    control_unit control (
        .instruction(instruction),
        .pc_write(pc_write)
        // Agregar más señales de control según sea necesario
    );
    
    // Instancia del banco de registros
    register_unit registers (
        .clk(clk),
        .reset(reset),
        .rs1(instruction[19:15]),  // Campos de la instrucción
        .rs2(instruction[24:20]),
        .rd(instruction[11:7]),
        .write_data(32'h0),        // Por simplicidad en este ejemplo
        .reg_write(1'b0),          // Por simplicidad en este ejemplo
        .rs1_data(),               // No conectado en este ejemplo
        .rs2_data()               // No conectado en este ejemplo
    );
    
    // Conexión simple entre PC y memoria de instrucciones
    assign imem_address = pc;
    assign next_pc = pc + 4;  // Secuencia simple de PC
    
    // Generar el reloj
    always #5 clk = ~clk;
    
    // Inicializar las señales de prueba
    initial begin
        // Inicializar el reloj y reset
        clk = 0;
        reset = 1;
        
        // Esperar unos ciclos de reloj
        #10;
        reset = 0;
        
        // Esperar más ciclos de reloj para observar el comportamiento
        #100;
        
        // Finalizar la simulación
        $finish;
    end
    
    // Monitor para observar las señales
    initial begin
        $monitor("Time: %0t | clk: %b | reset: %b | pc: %h | instruction: %h", 
                 $time, clk, reset, pc, instruction);
    end
endmodule