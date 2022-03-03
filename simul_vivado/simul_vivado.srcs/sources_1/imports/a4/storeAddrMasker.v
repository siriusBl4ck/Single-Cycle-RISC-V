module storeAddrMasker(
    input reset,
    input [6:0] opcode,
    input [31:0] daddr,
    input [31:0] regVal,
    input [2:0] maskMode,
    output [3:0] maskedDwe,
    output [31:0] maskedVal
);
    reg [3:0] masked;
    reg [31:0] val;
    assign maskedVal = val;
    assign maskedDwe = masked;

    always @(*) begin
        if (opcode == 7'b0100011 && reset != 1'b1) begin
            case(maskMode)
                3'b000: begin //SB
                    case(daddr[1:0])
                        2'b00: begin
                            masked = 4'b0001;
                            val = regVal;
                        end
                        2'b01: begin
                            masked = 4'b0010;
                            val = regVal << 7;
                        end
                        2'b10: begin
                            masked = 4'b0100;
                            val = regVal << 15;
                        end
                        2'b11: begin
                            masked = 4'b1000;
                            val = regVal << 23;
                        end
                    endcase
                end
                3'b001: begin //SH
                    case(daddr[1])
                        2'b00: begin
                            masked = 4'b0011;
                            val = regVal;
                        end
                        2'b01: begin
                            masked = 4'b1100;
                            val = regVal << 15;
                        end
                    endcase
                end
                default: begin //SW
                    val = regVal;
                    masked = 4'b1111;
                end
            endcase
        end
        else begin //not a store instruction
            //$display("Not a store instruction");
            masked = 4'b0000;
            val = regVal;
        end
    end
endmodule