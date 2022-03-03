module masker(
    input [6:0] opcode,
    input [31:0] drdata,
    input [31:0] ALU_res,
    input [31:0] current_pc,
    input [2:0] maskMode,
    input [1:0] nonAlignedOffset,
    output [31:0] maskedDataIn
);
    reg [31:0] masked;
    assign maskedDataIn = masked;
    always @(*) begin
        if (opcode == 7'b0000011) begin
            case (maskMode)
                3'b000: begin //LB
                    case(nonAlignedOffset)
                        2'b00: masked = {{24{drdata[7]}}, drdata[7:0]};
                        2'b01: masked = {{24{drdata[15]}}, drdata[15:8]};
                        2'b10: masked = {{24{drdata[23]}}, drdata[23:16]};
                        2'b11: masked = {{24{drdata[31]}}, drdata[31:24]};
                    endcase
                end
                3'b001: begin //LH
                    case(nonAlignedOffset[1])
                        1'b0: masked = {{16{drdata[15]}}, drdata[15:0]};
                        1'b1: masked = {{16{drdata[31]}}, drdata[31:16]};
                    endcase
                end
                3'b100: begin //LBU
                    case(nonAlignedOffset)
                        2'b00: masked = {24'b0, drdata[7:0]};
                        2'b01: masked = {24'b0, drdata[15:8]};
                        2'b10: masked = {24'b0, drdata[23:16]};
                        2'b11: masked = {24'b0, drdata[31:24]};
                    endcase
                end
                3'b101: begin //LHU
                    case(nonAlignedOffset[1])
                        1'b0: masked = {16'b0, drdata[15:0]};
                        1'b1: masked = {16'b0, drdata[31:16]};
                    endcase
                end
                default: masked = drdata; //LW
            endcase
        end
        else if (opcode == 7'b1100111) begin //JALR
            masked = current_pc + 4;
        end
        else masked = ALU_res;
    end
endmodule