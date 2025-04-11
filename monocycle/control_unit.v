module control_unit (
    input [6:0] opCode,
    input [2:0] fun3,
    input [6:0] fun7,
    output reg DMWr,
    output reg [2:0] ImmSrc,
    output reg ALUBSrc,
    output reg [4:0] BrOp,
    output reg [1:0] RUDataWrSrc,
    output reg ALUASrc,
    output reg [3:0] ALUOpcode,
    output reg [2:0] DMCtrl,
    output reg RUWr
);

always @(*) begin
    // Valores por defecto
    DMWr = 0;
    ImmSrc = 3'b000;
    ALUBSrc = 0;
    BrOp = 5'b00000;
    RUDataWrSrc = 2'b00;
    ALUASrc = 0;
    ALUOpcode = 4'b0000;
    DMCtrl = 3'b000;
    RUWr = 0;

    case (opCode)
        7'b0110011: begin // R-type
            ALUOpcode = {fun7[5], fun3};
            RUWr = 1;
        end
        7'b0010011: begin // I-type
            ALUBSrc = 1;
            if(fun3 == 3'b101) 
                ALUOpcode = {fun7[5], fun3};
            else 
                ALUOpcode = {1'b0, fun3};
            RUWr = 1;
        end
        7'b0000011: begin // Load
            ALUBSrc = 1;
            RUDataWrSrc = 2'b01;
            DMCtrl = fun3;
            RUWr = 1;
        end
        7'b0100011: begin // Store
            DMWr = 1;
            ALUBSrc = 1;
            ImmSrc = 3'b001;
            DMCtrl = fun3;
        end
        7'b1100011: begin // Branch
            ALUBSrc = 1;
            ALUASrc = 1;
            ImmSrc = 3'b101;
            BrOp = {1'b0, fun3};
        end
        7'b1101111: begin // Jal
            ALUBSrc = 1;
            ALUASrc = 1;
            ImmSrc = 3'b110;
            BrOp = 5'b11111;
            RUDataWrSrc = 2'b10;
            RUWr = 1;
        end
        7'b1100111: begin // Jalr
            ALUBSrc = 1;
            BrOp = 5'b11111;
            RUDataWrSrc = 2'b10;
            RUWr = 1;
        end
    endcase
end
endmodule