module cpu (
    input clk, 
    input reset,
    output [31:0] iaddr,
    input [31:0] idata,
    output [31:0] daddr,
    input [31:0] drdata,
    output [31:0] dwdata,
    output [3:0] dwe
);
    reg [31:0] iaddr;
    wire [31:0] daddr;
    wire [31:0] dwdata;
    wire [3:0]  dwe;

    reg [4:0] regAddr1;
    reg [4:0] regAddr2;
    reg [4:0] regAddr3;
    wire [31:0] regVal1;
    wire [31:0] regVal2;
    wire [31:0] dataIn;
    reg wr;

    wire [4:0] w_regAddr1;
    wire [4:0] w_regAddr2;
    wire [4:0] w_regAddr3;
    wire w_wr;

    assign w_regAddr1 = regAddr1;
    assign w_regAddr2 = regAddr2;
    assign w_regAddr3 = regAddr3;
    assign w_wr = wr;

    regFile rf(clk, reset, w_regAddr1, w_regAddr2, w_regAddr3, dataIn, w_wr, regVal1, regVal2);

    reg [31:0] r1;
    reg [31:0] r2;
    reg [4:0] forcedAluOpcode;
    wire [31:0] res;

    wire [31:0] w_r1;
    wire [31:0] w_r2;
    wire [4:0] alu_opcode;
    wire eqFlag;

    assign w_r1 = regVal1;
    assign w_r2 = (idata[6:0] == 7'b0010011)? r2: regVal2;
    assign alu_opcode = (idata[6:0] == 7'b1100011 || idata[6:0] == 7'b0110111)? forcedAluOpcode : {idata[5], idata[30], idata[14:12]};

    alu myALU(w_r1, w_r2, alu_opcode, res, eqFlag);

    wire [31:0] mem_offset;
    assign mem_offset = (idata[6:0] == 7'b0000011)? {{20{idata[31]}}, idata[31:20]} : {{20{idata[31]}}, idata[31:25], idata[11:7]};
    assign daddr = regVal1 + mem_offset;

    masker muxForRegfileDataIn(idata[6:0], drdata, res, iaddr, idata[14:12], daddr[1:0], dataIn);
    storeAddrMasker muxForDataInDMEM(reset, idata[6:0], daddr, regVal2, idata[14:12], dwe, dwdata);

    reg shouldIBranch = 1'b0;
    reg [31:0] pc_branch;
    wire [31:0] pc_next;
    assign pc_next = (shouldIBranch == 1'b1)? pc_branch : (iaddr + 4);

    //changing pc
    always @(*) begin
        if (idata[6:0] == 7'b1100011) begin //Branch instructions control logic
            pc_branch = iaddr + {{20{idata[31]}}, idata[31], idata[7], idata[30:25], idata[11:8], 1'b0};
            case ({idata[14], idata[12]})
                3'b00: if (eqFlag == 1'b1) shouldIBranch = 1'b1; else shouldIBranch = 1'b0;  //BEQ
                3'b01: if (eqFlag != 1'b1) shouldIBranch = 1'b1; else shouldIBranch = 1'b0; //BNE
                3'b10: if (eqFlag != 1'b1 && res == 1) shouldIBranch = 1'b1; else shouldIBranch = 1'b0; //BLT / BLTU
                3'b11: if (eqFlag == 1'b1 && res != 1) shouldIBranch = 1'b1; else shouldIBranch = 1'b0; //BGE / BGEU
                default: shouldIBranch = 1'b0;
            endcase
            $display("Conditional Branch %d, %d, %d", eqFlag, res, shouldIBranch);
        end
        else if (idata[6:0] == 7'b1101111) begin //JAL
            $display("JAL");
            shouldIBranch = 1'b1;
            pc_branch = iaddr + {{11{idata[31]}}, idata[31], idata[19:12], idata[20], idata[30:21], 1'b0};
        end
        else if (idata[6:0] == 7'b1100111) begin //JALR
            $display("JALR");
            shouldIBranch = 1'b1;
            pc_branch = regVal1 + {{20{idata[31]}}, idata[31:21], 1'b0};
        end
        else shouldIBranch = 1'b0;
    end
    
    //regfile control signals
    always @(*) begin
        if (idata[6:0] == 7'b0010011) begin //Immediate mode ALU instructions ALU inputs and regfile control
            $display("Immediate mode ALU instruction", {idata[30], idata[14:12]});
            regAddr3 = idata[11:7];
            regAddr1 = idata[19:15];
            wr = 1'b1;
            r2 = {{20{idata[31]}}, idata[31:20]};
        end
        else if (idata[6:0] == 7'b0110011) begin //Non immediate mode ALU instructions ALU inputs and regfile control
            $display("Non immediate mode ALU instruction", {idata[30], idata[14:12]});
            regAddr3 = idata[11:7];
            regAddr1 = idata[19:15];
            regAddr2 = idata[24:20];
            wr = 1'b1;
            r2 = regVal2;
        end
        else if (idata[6:0] == 7'b0000011) begin //Load instructions regfile control
            $display("Load instruction");
            regAddr3 = idata[11:7];
            regAddr1 = idata[19:15];
            wr = 1'b1;
        end
        else if (idata[6:0] == 7'b0100011) begin //Store instructions regfile control
            //$display("Offset %d", $signed({{20{idata[31]}}, idata[31:25], idata[11:7]}));
            $display("Store Instruction");
            //$display("dwe %d, dwdata %d, daddr %d", dwe, dwdata, daddr);
            wr = 1'b0;
            regAddr1 = idata[19:15];
            regAddr2 = idata[24:20];
        end
        else if (idata[6:0] == 7'b1100011) begin //branch instructions ALU inputs
            $display("Branch instruction");
            wr = 1'b0;
            regAddr1 = idata[19:15];
            regAddr2 = idata[24:20];
            if (idata[13] == 1'b1) forcedAluOpcode = 5'b10011;
            else forcedAluOpcode = 5'b10010;
        end
        else if (idata[6:0] == 7'b1100111) begin //JALR regfile control
            $display("JALR");
            regAddr3 = idata[11:7];
            regAddr1 = idata[19:15];
            wr = 1'b1;
        end
        else if (idata[6:0] == 7'b0110111) begin //LUI
            $display("LUI");
            regAddr3 = idata[11:7];
            regAddr1 = 0;  //x0 = 0
            r2 = {idata[31:12], 12'b0};  //immideate mode value as specified in ISA
            wr = 1'b1;
            forcedAluOpcode = 5'b00000; //ADDI this so we take advantage of our prebuilt routing via alu to update the reg
        end
        else if (idata[6:0] == 7'b0010111) begin //AUIPC
            $display("AUIPC");
            regAddr3 = idata[11:7];
            regAddr1 = 0;  //x0 = 0
            r2 = iaddr + {idata[31:12], 12'b0};  //immideate mode value as specified in ISA
            wr = 1'b1;
            forcedAluOpcode = 5'b00000; //ADDI this so we take advantage of our prebuilt routing via alu to update the reg
        end
        else begin
            wr = 1'b0;
        end
    end

    always @(posedge clk) begin
        if (reset) begin
            iaddr <= 0;
            $display("reset state");
        end else begin
            $display("INSTRUCTION : %h", idata);
            
            //$display("Branch? ", shouldIBranch);
            //$display("next pc ", pc_next, iaddr + 4, pc_branch);
            //PC handling
            iaddr <= pc_next;
        end
    end

endmodule