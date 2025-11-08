SHELL = /bin/bash
SRC_DIR = ./src
TEST_DIR = ./test

.DELETE_ON_ERROR:
.PHONY: all bitstream synthesis fitting timing_analysis netlist sta check clean full_clean sw

all: sw bitstream sta check

sw:
	@$(MAKE) -C $(SRC_DIR) sw

bitstream:
	@$(MAKE) -C $(SRC_DIR) bitstream

synthesis:
	@$(MAKE) -C $(SRC_DIR) synthesis

fitting:
	@$(MAKE) -C $(SRC_DIR) fitting

timing_analysis:
	@$(MAKE) -C $(SRC_DIR) timing_analysis

netlist:
	@$(MAKE) -C $(SRC_DIR) netlist

sta:
	@$(MAKE) -C $(SRC_DIR) sta
	@$(MAKE) -C $(TEST_DIR) sta

load:
	@$(MAKE) -C $(SRC_DIR) load

check:
	@$(MAKE) -C $(TEST_DIR) check

clean:
	@$(MAKE) -C $(SRC_DIR) clean
	@$(MAKE) -C $(TEST_DIR) clean
	rm -rf .ruff_cache

full_clean: clean
	rm -rf venv

help:
	@echo "Available targets for this makefile are:"
	@echo ""
	@echo "'all' (default): Build, run tests and run style check for HW design, and build test SW."
	@echo "'sw': Build test SW."
	@echo "'bitstream': Generate the bitstream."
	@echo "'synthesis': Run synthesis."
	@echo "'fitting': Run place-and-route."
	@echo "'timing_analysis': Run timing analysis."
	@echo "'netlist': Create and open the netlist."
	@echo "'sta': Run style check."
	@echo "'load': Load the bitfile to the FPGA."
	@echo "'check': Run unit tests."
	@echo "'clean': Remove all makefile-generated files."
	@echo "'full_clean': Same as 'clean', but also remove venv-folder."
	@echo "'help': Print this help text."
