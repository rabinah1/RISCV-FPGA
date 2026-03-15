SHELL = /bin/bash
CC = /opt/riscv32-gnu-toolchain-elf-bin/bin/riscv32-unknown-elf-gcc
LD = /opt/riscv32-gnu-toolchain-elf-bin/bin/riscv32-unknown-elf-ld
OC = /opt/riscv32-gnu-toolchain-elf-bin/bin/riscv32-unknown-elf-objcopy
BITFILE = ./output_files/riscv.sof

.DELETE_ON_ERROR:
.PHONY: bitstream synthesis fitting timing_analysis netlist clean check sta full_clean sw load

STYLE_CHECK_FILES = \
	mux_2_inputs.vhd \
	writeback_mux.vhd \
	alu.vhd \
	data_memory.vhd \
	instruction_decoder.vhd \
	program_counter.vhd \
	program_memory.vhd \
	register_file.vhd \
	riscv.vhd \
	opcode_pkg.vhd \
	pc_adder.vhd \
	state_machine.vhd \
	states_package.vhd \
	uart.vhd \
	instruction_types_package.vhd \
	arithmetic_pkg.vhd \
	mux_2_inputs_latch.vhd \
	uart_package.vhd \
	clk_div.vhd

FILES_TO_REMOVE = \
	db \
	incremental_db \
	output_files \
	c5_pin_model_dump.txt \
	test \
	test.s \
	test.o \
	startup \
	startup.o \
	game_of_life \
	game_of_life.s \
	game_of_life.o \
	test_1_arithmetic_extended.o \
	test_1_arithmetic_extended.s \
	test_1_arithmetic_extended \
	test_2_branches_extended.o \
	test_2_branches_extended.s \
	test_2_branches_extended \
	test_3_memory_jumps.o \
	test_3_memory_jumps.s \
	test_3_memory_jumps \
	test_4_structs.o \
	test_4_structs.s \
	test_4_structs \
	test_5_arrays_2d.o \
	test_5_arrays_2d.s \
	test_5_arrays_2d \
	test_6_linked_lists.o \
	test_6_linked_lists.s \
	test_6_linked_lists \
	test_7_pointers_advanced.o \
	test_7_pointers_advanced.s \
	test_7_pointers_advanced \
	test_8_recursion.o \
	test_8_recursion.s \
	test_8_recursion \
	test_9_mixed.o \
	test_9_mixed.s \
	test_9_mixed \
	test_10_edge_cases.o \
	test_10_edge_cases.s \
	test_10_edge_cases \
	riscv_assignment_defaults.qdf

sw:
	@$(CC) -march=rv32i -mabi=ilp32 -ffreestanding -nostdlib -ffunction-sections -S test.c
	@$(CC) -march=rv32i -mabi=ilp32 -ffreestanding -nostdlib -ffunction-sections -S game_of_life.c
	@$(CC) -march=rv32i -mabi=ilp32 -ffreestanding -nostdlib -ffunction-sections -S test_1_arithmetic_extended.c
	@$(CC) -march=rv32i -mabi=ilp32 -ffreestanding -nostdlib -ffunction-sections -S test_2_branches_extended.c
	@$(CC) -march=rv32i -mabi=ilp32 -ffreestanding -nostdlib -ffunction-sections -S test_3_memory_jumps.c
	@$(CC) -march=rv32i -mabi=ilp32 -ffreestanding -nostdlib -ffunction-sections -S test_4_structs.c
	@$(CC) -march=rv32i -mabi=ilp32 -ffreestanding -nostdlib -ffunction-sections -S test_5_arrays_2d.c
	@$(CC) -march=rv32i -mabi=ilp32 -ffreestanding -nostdlib -ffunction-sections -S test_6_linked_lists.c	
	@$(CC) -march=rv32i -mabi=ilp32 -ffreestanding -nostdlib -ffunction-sections -S test_7_pointers_advanced.c
	@$(CC) -march=rv32i -mabi=ilp32 -ffreestanding -nostdlib -ffunction-sections -S test_8_recursion.c
	@$(CC) -march=rv32i -mabi=ilp32 -ffreestanding -nostdlib -ffunction-sections -S test_9_mixed.c
	@$(CC) -march=rv32i -mabi=ilp32 -ffreestanding -nostdlib -ffunction-sections -S test_10_edge_cases.c
	@$(CC) -march=rv32i -mabi=ilp32 -ffreestanding -nostdlib -ffunction-sections -c startup.S -o startup.o
	@$(CC) -march=rv32i -mabi=ilp32 -ffreestanding -nostdlib -ffunction-sections -c test.c -o test.o
	@$(CC) -march=rv32i -mabi=ilp32 -ffreestanding -nostdlib -ffunction-sections -c game_of_life.c -o game_of_life.o
	@$(CC) -march=rv32i -mabi=ilp32 -ffreestanding -nostdlib -ffunction-sections -c test_1_arithmetic_extended.c -o test_1_arithmetic_extended.o
	@$(CC) -march=rv32i -mabi=ilp32 -ffreestanding -nostdlib -ffunction-sections -c test_2_branches_extended.c -o test_2_branches_extended.o
	@$(CC) -march=rv32i -mabi=ilp32 -ffreestanding -nostdlib -ffunction-sections -c test_3_memory_jumps.c -o test_3_memory_jumps.o
	@$(CC) -march=rv32i -mabi=ilp32 -ffreestanding -nostdlib -ffunction-sections -c test_4_structs.c -o test_4_structs.o
	@$(CC) -march=rv32i -mabi=ilp32 -ffreestanding -nostdlib -ffunction-sections -c test_5_arrays_2d.c -o test_5_arrays_2d.o
	@$(CC) -march=rv32i -mabi=ilp32 -ffreestanding -nostdlib -ffunction-sections -c test_6_linked_lists.c -o test_6_linked_lists.o
	@$(CC) -march=rv32i -mabi=ilp32 -ffreestanding -nostdlib -ffunction-sections -c test_7_pointers_advanced.c -o test_7_pointers_advanced.o
	@$(CC) -march=rv32i -mabi=ilp32 -ffreestanding -nostdlib -ffunction-sections -c test_8_recursion.c -o test_8_recursion.o
	@$(CC) -march=rv32i -mabi=ilp32 -ffreestanding -nostdlib -ffunction-sections -c test_9_mixed.c -o test_9_mixed.o
	@$(CC) -march=rv32i -mabi=ilp32 -ffreestanding -nostdlib -ffunction-sections -c test_10_edge_cases.c -o test_10_edge_cases.o
	@$(LD) -T ./custom.ld -o test startup.o test.o
	@$(LD) -T ./custom.ld -o game_of_life startup.o game_of_life.o
	@$(LD) -T ./custom.ld -o test_1_arithmetic_extended startup.o test_1_arithmetic_extended.o
	@$(LD) -T ./custom.ld -o test_2_branches_extended startup.o test_2_branches_extended.o
	@$(LD) -T ./custom.ld -o test_3_memory_jumps startup.o test_3_memory_jumps.o
	@$(LD) -T ./custom.ld -o test_4_structs startup.o test_4_structs.o
	@$(LD) -T ./custom.ld -o test_5_arrays_2d startup.o test_5_arrays_2d.o
	@$(LD) -T ./custom.ld -o test_6_linked_lists startup.o test_6_linked_lists.o
	@$(LD) -T ./custom.ld -o test_7_pointers_advanced startup.o test_7_pointers_advanced.o
	@$(LD) -T ./custom.ld -o test_8_recursion startup.o test_8_recursion.o
	@$(LD) -T ./custom.ld -o test_9_mixed startup.o test_9_mixed.o
	@$(LD) -T ./custom.ld -o test_10_edge_cases startup.o test_10_edge_cases.o
	@$(OC) -O binary startup.o startup
	@$(OC) -O binary test test
	@$(OC) -O binary game_of_life game_of_life
	@$(OC) -O binary test_1_arithmetic_extended test_1_arithmetic_extended
	@$(OC) -O binary test_2_branches_extended test_2_branches_extended
	@$(OC) -O binary test_3_memory_jumps test_3_memory_jumps
	@$(OC) -O binary test_4_structs test_4_structs
	@$(OC) -O binary test_5_arrays_2d test_5_arrays_2d
	@$(OC) -O binary test_6_linked_lists test_6_linked_lists
	@$(OC) -O binary test_7_pointers_advanced test_7_pointers_advanced
	@$(OC) -O binary test_8_recursion test_8_recursion
	@$(OC) -O binary test_9_mixed test_9_mixed
	@$(OC) -O binary test_10_edge_cases test_10_edge_cases

bitstream: synthesis fitting timing_analysis
	@quartus_asm --write_settings_files=off ./riscv -c riscv

synthesis:
	@quartus_map --write_settings_files=off ./riscv -c riscv

fitting: synthesis
	@quartus_fit --write_settings_files=off ./riscv -c riscv

timing_analysis: synthesis fitting
	@quartus_sta ./riscv -c riscv

netlist: synthesis
	@quartus_npp ./riscv -c riscv --netlist_type=sgate
	@qnui ./riscv

sta:
	@echo "Running astyle..."
	@astyle --style=linux --max-code-length=100 --recursive --align-pointer=name --break-blocks \
	--pad-oper --pad-header --delete-empty-lines --indent-col1-comments --squeeze-lines=1 \
	-i "./\*.c"
	@echo "Done"
	@echo "Running ruff check..."
	@ruff check
	@echo "Done"
	@echo "Running ruff format..."
	@ruff format --diff
	@echo "Done"
	@for file in $(STYLE_CHECK_FILES); do \
		vsg -f $${file} -c ../vsg_config.json; \
	done

load:
	@if [[ ! -f $(BITFILE) ]]; then \
		echo "Error: the bitfile $(BITFILE) was not found."; \
	else \
		quartus_pgm -m jtag -o "p;$(BITFILE)@2"; \
	fi

clean:
	@for file in $(FILES_TO_REMOVE); do \
		rm -rf $${file}; \
	done
