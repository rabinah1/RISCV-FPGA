SHELL = /bin/bash
CC = /opt/riscv32-gnu-toolchain-elf-bin/bin/riscv32-unknown-elf-gcc
LD = /opt/riscv32-gnu-toolchain-elf-bin/bin/riscv32-unknown-elf-ld
OC = /opt/riscv32-gnu-toolchain-elf-bin/bin/riscv32-unknown-elf-objcopy
BITFILE = ./output_files/riscv.sof

.DELETE_ON_ERROR:
.PHONY: bitstream synthesis fitting timing_analysis netlist clean check sta full_clean sw load

STYLE_CHECK_FILES = \
	mux_3_inputs.vhd \
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
	instruction_types_package.vhd

FILES_TO_REMOVE = \
	db \
	incremental_db \
	output_files \
	c5_pin_model_dump.txt \
	test \
	test.s \
	test.o \
	game_of_life \
	game_of_life.s \
	game_of_life.o \
	riscv_assignment_defaults.qdf

sw:
	@$(CC) -march=rv32i -mabi=ilp32 -ffreestanding -nostdlib -ffunction-sections -S test.c
	@$(CC) -march=rv32i -mabi=ilp32 -ffreestanding -nostdlib -ffunction-sections -c test.c -o test.o
	@$(LD) -T ./custom.ld -o test test.o
	@$(OC) -O binary test test
	@$(CC) -march=rv32i -mabi=ilp32 -ffreestanding -nostdlib -ffunction-sections -S game_of_life.c
	@$(CC) -march=rv32i -mabi=ilp32 -ffreestanding -nostdlib -ffunction-sections -c game_of_life.c -o game_of_life.o
	@$(LD) -T ./custom.ld -o game_of_life game_of_life.o
	@$(OC) -O binary game_of_life game_of_life

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
