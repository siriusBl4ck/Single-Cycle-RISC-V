x = int(input("Enter the addr size:"))
y = int(input("enter the size of each input in bits:"))

code = "module mux_" + str(pow(2, x)) + "To1(\n"

code += "   input [" + str(x - 1) + ":0] addr,\n"

for i in range(pow(2, x)):
    if (y != 1):
        code += "   input [" + str(y - 1) + ":0] inp" + str(i) + ",\n"
    else:
        code += "   input inp" + str(i) + ",\n"

if (y != 1):
    code += "   output [" + str(y - 1) + ":0] out\n);\n"
else:
    code += "   output out\n);\n"

code += "   assign out = "

for count in range(pow(2, x)):
    b = bin(count)[2:]
    while (len(b) < 4):
        b = '0' + b
    code += "(("
    for j in range(x):
        if (b[j] == '1'):
            code += "addr[" + str(x - j - 1) + "]"
        else:
            code += "~addr[" + str(x - j - 1) + "]"
        if (j < x - 1):
            code += " & "
    code += ") && inp" + str(count) + ")"
    if (count < pow(2, x) - 1):
        code += " & "

code += ";\n"
code += "endmodule\n"

print(code)