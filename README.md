# RISC-V Single Cycle CPU

This was one of the projects in the course EE2003, Computer Organization.

NOTE: Do not use this code as is to turn in for assignments in this course

The goal of the single cycle CPU is to implement all instructions (except `FENCE`, `ECALL` and `EBREAK`) in the RV32I instruction set.  For this, we will assume a simplified memory model, where data and instruction memory can be read in a single cycle (provide the address, and the memory responds with data in the same cycle), while allowing write at the next edge of the clock.

### Test cases

Test cases are given under the `test/` folder, with appropriate imem and dmem files.  Each imem file contains a set of instructions at the end that will dump all the register values into the first several locations in dmem.  The test bench will then read out these values from dmem and compare with expected results.

The file `dump.s` in the top folder also shows an example of assembly code that you can write to create your own test cases.  You can compile and disassemble as follows to generate the instruction codes.  Note that function calls need to be handled with care: the addresses for functions are not resolved till the Link step completes, so disassembled code will not look or work as expected.

```bash
$ riscv32-unknown-elf-gcc -c dump.s
$ riscv32-unknown-elf-objdump -d -Mnumeric,no-aliases dump.o
```

The `run.sh` script performs all the steps required to compile and test your code.  The `iverilog` compiler is used for running the verilog simulations.
