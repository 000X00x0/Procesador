module data_memory (
    input logic clk,
    input logic mem_write,
    input logic [2:0] mem_ctrl, // Control de memoria
    input logic [31:0] address,
    input logic [31:0] write_data,
    output logic [31:0] read_data
);
    logic [7:0] memory [0:1023]; // Tamaño de memoria de ejemplo (1024 bytes)

    always_ff @(posedge clk) begin
        if (mem_write) begin
            case (mem_ctrl)
                3'b000: memory[address] <= write_data[7:0]; // Escribir byte
                3'b001: begin // Escribir media palabra
                    memory[address] <= write_data[7:0];
                    memory[address + 1] <= write_data[15:8];
                end
                3'b010: begin // Escribir palabra
                    memory[address] <= write_data[7:0];
                    memory[address + 1] <= write_data[15:8];
                    memory[address + 2] <= write_data[23:16];
                    memory[address + 3] <= write_data[31:24];
                end
                default: ; // No hacer nada para otros valores
            endcase
        end
    end

    always_comb begin
        case (mem_ctrl)
            3'b000: read_data = {{24{memory[address][7]}}, memory[address]}; // Leer byte
            3'b001: read_data = {{16{memory[address + 1][7]}}, memory[address + 1], memory[address]}; // Leer media palabra
            3'b010: read_data = {memory[address + 3], memory[address + 2], memory[address + 1], memory[address]}; // Leer palabra
            3'b100: read_data = {24'b0, memory[address]}; // Leer byte sin signo
            3'b101: read_data = {16'b0, memory[address + 1], memory[address]}; // Leer media palabra sin signo
            default: read_data = 32'b0; // No hacer nada para otros valores
        endcase
    end
endmodule