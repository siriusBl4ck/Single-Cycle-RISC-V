#this file parses the ISA in RISCV_ISA.txt and extracts the relevant instructions which match a set of conditions
#used to test which is the minimum number of bits required to uniquely indentify the correct instructions

# a file named "geek", will be opened with the reading mode.
file = open('RISCV_ISA', 'r')
# This will print every line one by one in the file
for each in file:
    s = each.split()
    if s[-2][0] + s[-2][2:] == "010011":
        if (s[-2][1] == '0' and s[-1] != "SLLI" and s[-1] != "SRLI" and s[-1] != "SRAI"):
            print(s[-1], s[-2][1] + 'x' + s[2])
        else:
            print(s[-1], s[-2][1] + s[0][1] + s[3])
file.close()