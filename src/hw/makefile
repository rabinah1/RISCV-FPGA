SHELL = /bin/bash
BITFILE = ./output_files/riscv.sof

.DELETE_ON_ERROR:
.PHONY: bitstream synthesis fitting timing_analysis netlist sta load clean

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
	riscv_assignment_defaults.qdf

bitstream: timing_analysis
	@quartus_asm --write_settings_files=off ./riscv -c riscv

synthesis:
	@quartus_map --write_settings_files=off ./riscv -c riscv

fitting: synthesis
	@quartus_fit --write_settings_files=off ./riscv -c riscv

timing_analysis: fitting
	@quartus_sta ./riscv -c riscv

netlist: synthesis
	@quartus_npp ./riscv -c riscv --netlist_type=sgate
	@qnui ./riscv

sta:
	@for file in $(STYLE_CHECK_FILES); do \
		vsg -f $${file} -c ../../vsg_config.json; \
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
