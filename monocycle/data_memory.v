module data_memory (
    input clk,
    input mem_write,
    input [2:0] mem_ctrl,
    input [31:0] address,
    input [31:0] write_data,
    output reg [31:0] read_data
);
    reg [7:0] memory[0:1023];
	 
    integer i;
    initial begin
        for (i = 0; i < 1024; i = i + 1)
            memory[i] = 8'h00;
    end

    always @(posedge clk) begin
        if (mem_write) begin
            case (mem_ctrl)
                3'b000: memory[address] <= write_data[7:0];
                3'b001: begin
                    memory[address] <= write_data[7:0];
                    memory[address+1] <= write_data[15:8];
                end
                3'b010: begin
                    memory[address] <= write_data[7:0];
                    memory[address+1] <= write_data[15:8];
                    memory[address+2] <= write_data[23:16];
                    memory[address+3] <= write_data[31:24];
                end
            endcase
        end
    end

    always @(*) begin
        case (mem_ctrl)
            3'b000: read_data = {{24{memory[address][7]}}, memory[address]}; // LB
            3'b001: read_data = {{16{memory[address+1][7]}}, memory[address+1], memory[address]}; // LH
            3'b010: read_data = {memory[address+3], memory[address+2], memory[address+1], memory[address]}; // LW
            3'b100: read_data = {24'b0, memory[address]}; // LBU
            3'b101: read_data = {16'b0, memory[address+1], memory[address]}; // LHU
            default: read_data = 32'b0;
        endcase
    end
endmodule
