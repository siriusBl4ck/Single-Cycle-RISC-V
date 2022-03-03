module alu(
    input [31:0] rs1,
    input [31:0] rs2,
    input [4:0] alu_opcode, // {opcode[5], funct7[5], funct3[2:0]}
    output reg [31:0] res,
    output eqFlag
);
    always @(rs1, rs2, alu_opcode) begin
        casex(alu_opcode)
            5'b0x000: res = rs1 + rs2; //ADDI
            5'b10000: res = rs1 + rs2; //ADD
            5'b11000: res = rs1 - rs2; //SUB
            5'bxx111: res = rs1 & rs2; //AND / ANDI
            5'bxx110: res = rs1 | rs2; //OR / ORI
            5'bxx100: res = rs1 ^ rs2; //XOR / XORI
            5'bx0101: res = rs1 >> rs2[4:0]; //SRL / SRLI
            5'bx0001: res = rs1 << rs2[4:0]; //SLL / SLLI
            5'bx1101: res = rs1 >>> rs2[4:0]; //SRA / SRAI
            5'bxx010: if ($signed(rs1) < $signed(rs2)) res = 1; else res = 0; //SLT / SLTI
            5'bxx011: if (rs1 < rs2) res = 1; else res = 0; //SLTU / SLTIU
            default: res = 0;
        endcase
        $display("ALU_inputs %d, %d, %d, %d", $signed(rs1), $signed(rs2), alu_opcode, $signed(res));
    end

    assign eqFlag = (rs1 == rs2)? 1 : 0;
endmodule