module databus(
    input clk,
    input [3:0] addr,
    input rd_wr,
    input [7:0] datain,
    output reg [7:0] dataout
);
    reg [7:0] R0; //ALU inp A
    reg [7:0] R1; //ALU inp B
    reg [7:0] R2; //ALU out Res
    reg [7:0] R3;
    reg [7:0] R4;
    reg [7:0] R5;
    reg [7:0] R6;
    reg [7:0] R7;
    reg [7:0] R8;
    reg [7:0] R9;
    reg [7:0] R10;
    reg [7:0] R11;
    reg [7:0] R12;
    reg [7:0] R13; //ALU Flag Overflow
    reg [7:0] R14; //ALU Flag Eq
    reg [7:0] R15; //ALU Flag Cout

    always @(posedge clk) begin
        if (rd_wr == 1'b1) begin
            case (addr)
                4'b0000: R0 <= datain;
                4'b0001: R1 <= datain;
                4'b0010: R2 <= datain;
                4'b0011: R3 <= datain;
                4'b0100: R4 <= datain;
                4'b0101: R5 <= datain;
                4'b0110: R6 <= datain;
                4'b0111: R7 <= datain;
                4'b1000: R8 <= datain;
                4'b1001: R9 <= datain;
                4'b1010: R10 <= datain;
                4'b1011: R11 <= datain;
                4'b1100: R12 <= datain;
                4'b1101: R13 <= datain;
                4'b1110: R14 <= datain;
                4'b1111: R15 <= datain;
            endcase
        end
    end

    mux_16To1 dataOut(addr, R0, R1, R2, R3, R4, R5, R6, R7, R8, R9, R10, R11, R12, R13, R14, R15, dataout);
endmodule

module mux_16To1(
    input en,
   input [3:0] addr,
   input [7:0] inp0,
   input [7:0] inp1,
   input [7:0] inp2,
   input [7:0] inp3,
   input [7:0] inp4,
   input [7:0] inp5,
   input [7:0] inp6,
   input [7:0] inp7,
   input [7:0] inp8,
   input [7:0] inp9,
   input [7:0] inp10,
   input [7:0] inp11,
   input [7:0] inp12,
   input [7:0] inp13,
   input [7:0] inp14,
   input [7:0] inp15,
   output [7:0] out
);
   assign out = en && ((~addr[3] & ~addr[2] & ~addr[1] & ~addr[0]) && inp0) & ((~addr[3] & ~addr[2] & ~addr[1] & addr[0]) && inp1) & ((~addr[3] & ~addr[2] & addr[1] & ~addr[0]) && inp2) & ((~addr[3] & ~addr[2] & addr[1] & addr[0]) && inp3) & ((~addr[3] & addr[2] & ~addr[1] & ~addr[0]) && inp4) & ((~addr[3] & addr[2] & ~addr[1] & addr[0]) && inp5) & ((~addr[3] & addr[2] & addr[1] & ~addr[0]) && inp6) & ((~addr[3] & addr[2] & addr[1] & addr[0]) && inp7) & ((addr[3] & ~addr[2] & ~addr[1] & ~addr[0]) && inp8) & ((addr[3] & ~addr[2] & ~addr[1] & addr[0]) && inp9) & ((addr[3] & ~addr[2] & addr[1] & ~addr[0]) && inp10) & ((addr[3] & ~addr[2] & addr[1] & addr[0]) && inp11) & ((addr[3] & addr[2] & ~addr[1] & ~addr[0]) && inp12) & ((addr[3] & addr[2] & ~addr[1] & addr[0]) && inp13) & ((addr[3] & addr[2] & addr[1] & ~addr[0]) && inp14) & ((addr[3] & addr[2] & addr[1] & addr[0]) && inp15);
endmodule
