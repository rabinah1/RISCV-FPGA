SHELL = /bin/bash

.DELETE_ON_ERROR:
.PHONY: check sta

STYLE_CHECK_FILES = \
	tb_program_counter.vhd \
	tb_program_memory.vhd \
	tb_instruction_decoder.vhd \
	tb_mux_3_inputs.vhd \
	tb_mux_2_inputs.vhd \
	tb_register_file.vhd \
	tb_data_memory.vhd \
	tb_alu.vhd \
	tb_pc_adder.vhd \
	tb_state_machine.vhd \
	tb_riscv.vhd \
	tb_clk_div.vhd

sta:
	@for file in $(STYLE_CHECK_FILES); do \
		vsg -f $${file} -c ../vsg_config.json; \
	done

check:
	python3 run.py

clean:
	@rm -rf vunit_out
