module control_unit (
    input logic [6:0] opCode,
    input logic [2:0] fun3,
    input logic [6:0] fun7,
    output logic DMWr,
    output logic [2:0] ImmSrc,
    output logic ALUBSrc,
    output logic [4:0] BrOp,
    output logic [1:0] RUDataWrSrc,
    output logic ALUASrc,
    output logic [3:0] ALUOpcode,
    output logic [2:0] DMCtrl,
    output logic RUWr
);
    always_comb begin
        // Inicializar todas las señales de control a 0
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
                DMWr = 0;
       			ImmSrc = 3'b111;
        		ALUBSrc = 0;
        		BrOp = 5'b00000;
        		RUDataWrSrc = 2'b00;
        		ALUASrc = 0;
              	ALUOpcode = {fun7[5],fun3};
        		DMCtrl = 3'b111;
        		RUWr = 1;
            end
            7'b0010011: begin // I-type
                DMWr = 0;
       			ImmSrc = 3'b000;
        		ALUBSrc = 1;
        		BrOp = 5'b00000;
        		RUDataWrSrc = 2'b00;
        		ALUASrc = 0;
                if(fun3 == 3'b101) begin
                	ALUOpcode = {fun7[5],fun3};
                end
                else begin
                	ALUOpcode = fun3;
                end
              	ALUOpcode = fun3;
        		DMCtrl = 3'b111;
        		RUWr = 1;
            end
            7'b0000011: begin // Load
                DMWr = 0;
                ImmSrc = 3'b000;
                ALUBSrc = 1;
                BrOp = 5'b00000;
                RUDataWrSrc = 2'b01;
                ALUASrc = 0;
                ALUOpcode = 4'b0000;
                DMCtrl = fun3;
                RUWr = 1;
            end
            7'b0100011: begin // Store
                DMWr = 1;
                ImmSrc = 3'b001;
                ALUBSrc = 1;
                BrOp = 5'b00000;
                RUDataWrSrc = 2'b00;
                ALUASrc = 0;
                ALUOpcode = 4'b0000;
                DMCtrl = fun3;
                RUWr = 0;
            end
            7'b1100011: begin // Branch
                DMWr = 0;
                ImmSrc = 3'b101;
                ALUBSrc = 1;
                BrOp = {2'b01, fun3[2:0]};
                RUDataWrSrc = 2'b00;
                ALUASrc = 1;
                ALUOpcode = 4'b0000;
                DMCtrl = 3'b111;
                RUWr = 0;
            end
            7'b1101111: begin // Jal
                DMWr = 0;
                ImmSrc = 3'b110;
                ALUBSrc = 1;
                BrOp = 5'b11111;
                RUDataWrSrc = 2'b10;
                ALUASrc = 1;
                ALUOpcode = 4'b0000;
                DMCtrl = 3'b000;
                RUWr = 1;
            end
            7'b1100111: begin // Jalr
                DMWr = 0;
                ImmSrc = 3'b000;
                ALUBSrc = 1;
                BrOp = 5'b11111;
                RUDataWrSrc = 2'b10;
                ALUASrc = 0;
                ALUOpcode = 4'b0000;
                DMCtrl = 3'b000;
                RUWr = 1;
            end
            default: begin
                // Mantener todas las señales de control en 0
            end
        endcase
    end
endmodule