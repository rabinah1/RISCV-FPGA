SHELL = /bin/bash
HW_DIR = ./hw
SW_DIR = ./sw

.DELETE_ON_ERROR:
.PHONY: bitstream synthesis fitting timing_analysis netlist clean check sta full_clean sw load

sw:
	@$(MAKE) -C $(SW_DIR) sw

bitstream:
	@$(MAKE) -C $(HW_DIR) bitstream

synthesis:
	@$(MAKE) -C $(HW_DIR) synthesis

fitting:
	@$(MAKE) -C $(HW_DIR) fitting

timing_analysis:
	@$(MAKE) -C $(HW_DIR) timing_analysis

netlist:
	@$(MAKE) -C $(HW_DIR) netlist

sta:
	@$(MAKE) -C $(SW_DIR) sta
	@$(MAKE) -C $(HW_DIR) sta

load:
	@$(MAKE) -C $(HW_DIR) load

clean:
	@$(MAKE) -C $(SW_DIR) clean
	@$(MAKE) -C $(HW_DIR) clean
