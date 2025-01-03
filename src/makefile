SHELL = /bin/bash

.DELETE_ON_ERROR:
.PHONY: bitstream synthesis fitting timing_analysis netlist clean check sta

STYLE_CHECK_FILES = \
	mux_3_inputs.vhd \
	mux_2_inputs.vhd \
	alu.vhd \
	data_memory.vhd \
	instruction_decoder.vhd \
	program_counter.vhd \
	program_memory.vhd \
	register_file.vhd \
	riscv.vhd \
	opcode_pkg.vhd \
	pc_adder.vhd \
	../test/tb_program_counter.vhd \
	../test/tb_program_memory.vhd \
	../test/tb_instruction_decoder.vhd \
	../test/tb_mux_3_inputs.vhd \
	../test/tb_mux_2_inputs.vhd \
	../test/tb_register_file.vhd \
	../test/tb_data_memory.vhd \
	../test/tb_alu.vhd \
	../test/tb_pc_adder.vhd

FILES_TO_REMOVE = \
	db \
	incremental_db \
	output_files \
	c5_pin_model_dump.txt

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

check:
	python3 ../test/run.py

sta:
	@for file in $(STYLE_CHECK_FILES); do \
		vsg -f $${file} -c vsg_config.json; \
	done

clean:
	@for file in $(FILES_TO_REMOVE); do \
		rm -rf $${file}; \
	done
