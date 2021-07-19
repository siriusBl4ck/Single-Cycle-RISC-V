module alu(
    input [7:0] a,
    input [7:0] b,
    input [2:0] fnSelect,
    output [7:0] res,
    output cout,
    output flag_eq,
    output flag_overflow,
    output r
);
    wire [7:0] AddSubRes;
    wire [7:0] BitwiseAndRes;
    wire [7:0]BitwiseOrRes;
    wire [7:0] BitwiseNotRes;
    wire [7:0] BitwiseXorRes;
    wire [7:0] EqRes;

    addsubRipple AdderSubtractor(a, b, fnSelect[0], AddSubRes, cout, flag_overflow); //000 add, 001 sub
    assign BitwiseAndRes = a & b; //010 bitwise AND
    assign BitwiseNotRes = ~a; //011 bitwise NOT for "a"
    assign BitwiseOrRes = a | b; //100 bitwise OR
    assign BitwiseXorRes = a ^ b; //101 bitwise XOR
    // TODO: 110 = multiply, 111 divide 
    assign flag_eq = ~BitwiseXorRes[0] & ~BitwiseXorRes[1] & ~BitwiseXorRes[2] & ~BitwiseXorRes[3] & ~BitwiseXorRes[4] & ~BitwiseXorRes[5] & ~BitwiseXorRes[6] & ~BitwiseXorRes[7];

    mux_8To1 outputSelector(fnSelect, AddSubRes, AddSubRes, BitwiseAndRes, BitwiseOrRes, BitwiseNotRes, BitwiseXorRes, 8'b0, 8'b0, res);
endmodule

module mux_8To1(
    input [2:0] addr,
    input [7:0] inp0,
    input [7:0] inp1,
    input [7:0] inp2,
    input [7:0] inp3,
    input [7:0] inp4,
    input [7:0] inp5,
    input [7:0] inp6,
    input [7:0] inp7,
    output [7:0] out
);
    assign out = ((~addr[2] & ~addr[1] & ~addr[0]) && inp0) & ((~addr[2] & ~addr[1] & ~addr[0]) && inp1) & ((~addr[2] & ~addr[1] & addr[0]) && inp2) & ((~addr[2] & ~addr[1] & addr[0]) && inp3) & ((~addr[2] & addr[1] & ~addr[0]) && inp4) & ((~addr[2] & addr[1] & ~addr[0]) && inp5) & ((~addr[2] & addr[1] & addr[0]) && inp6) & ((~addr[2] & addr[1] & addr[0]) && inp7);
endmodule

module addsubRipple(
    input [7:0] a,
    input [7:0] b,
    input add_sub,
    output [7:0] res,
    output c_b,
    output flag_overflow
);
    wire [6:0] intermediate_cout;
    fa f0(a[0], b[0] ^ add_sub, add_sub, res[0], intermediate_cout[0]);
    fa f1(a[1], b[1] ^ add_sub, intermediate_cout[0], res[1], intermediate_cout[1]);
    fa f2(a[2], b[2] ^ add_sub, intermediate_cout[1], res[2], intermediate_cout[2]);
    fa f3(a[3], b[3] ^ add_sub, intermediate_cout[2], res[3], intermediate_cout[3]);
    fa f4(a[4], b[4] ^ add_sub, intermediate_cout[3], res[4], intermediate_cout[4]);
    fa f5(a[5], b[5] ^ add_sub, intermediate_cout[4], res[5], intermediate_cout[5]);
    fa f6(a[6], b[6] ^ add_sub, intermediate_cout[5], res[6], intermediate_cout[6]);
    fa f7(a[7], b[7] ^ add_sub, intermediate_cout[6], res[7], c_b);

    assign flag_overflow = c_b ^ intermediate_cout[6];
endmodule

module fa(
    input a,
    input b,
    input cin,
    output s,
    output cout
);
    assign s = a ^ b ^ c;
    assign cout = (a & b) | (b & c) | (c & a);
endmodule