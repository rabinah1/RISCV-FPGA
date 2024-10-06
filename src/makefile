SHELL = /bin/bash

.DELETE_ON_ERROR:
.PHONY: bitstream synthesis fitting timing_analysis netlist clean check

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

clean:
	@for file in $(FILES_TO_REMOVE); do \
		rm -rf $${file}; \
	done
