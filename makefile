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

check:
	@$(MAKE) -C $(TEST_DIR) check

clean:
	@$(MAKE) -C $(SRC_DIR) clean
	@$(MAKE) -C $(TEST_DIR) clean

full_clean: clean
	rm -rf venv
