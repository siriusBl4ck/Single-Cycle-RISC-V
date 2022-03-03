module regFile(
    input clk,
    input rst,
    input [4:0] regAddr1, //read Addr line 1
    input [4:0] regAddr2, //read Addr line 2
    input [4:0] regAddr3, //write Addr line
    input [31:0] dataIn,
    input wr,
    output reg [31:0] dataOut1,
    output reg [31:0] dataOut2
);
    reg [31:0] r [31:0];

    always @(*) begin
        dataOut1 = r[regAddr1];
        dataOut2 = r[regAddr2];
    end

    always @(posedge clk) begin
        if (rst == 1'b1) begin
            r[0] <= 32'b0;
            r[1] <= 32'b0;
            r[2] <= 32'b0;
            r[3] <= 32'b0;
            r[4] <= 32'b0;
            r[5] <= 32'b0;
            r[6] <= 32'b0;
            r[7] <= 32'b0;
            r[8] <= 32'b0;
            r[9] <= 32'b0;
            r[10] <= 32'b0;
            r[11] <= 32'b0;
            r[12] <= 32'b0;
            r[13] <= 32'b0;
            r[14] <= 32'b0;
            r[15] <= 32'b0;
            r[16] <= 32'b0;
            r[17] <= 32'b0;
            r[18] <= 32'b0;
            r[19] <= 32'b0;
            r[20] <= 32'b0;
            r[21] <= 32'b0;
            r[22] <= 32'b0;
            r[23] <= 32'b0;
            r[24] <= 32'b0;
            r[25] <= 32'b0;
            r[26] <= 32'b0;
            r[27] <= 32'b0;
            r[28] <= 32'b0;
            r[29] <= 32'b0;
            r[30] <= 32'b0;
            r[31] <= 32'b0;
        end
        else if (wr == 1'b1 && regAddr3 != 0) begin
            $display($time, "Datawrite %d in reg %d", $signed(dataIn), regAddr3);
            r[regAddr3] <= dataIn;
        end
    end
endmodule