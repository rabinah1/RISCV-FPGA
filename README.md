# RISCV-FPGA

## Overview

This is a hobby project for learning RISC-V architecture and CPU implementation on VHDL. In more detail, this project consists of a simple implementation of the RV32I ISA on the Terasic DE10-nano development board. This project also uses Python's tinyRV module as a RISC-V reference model for verifying the implementation of the processor.

## Repository structure

Below is a short description of the repository structure.

- src/
    - Source code.
- test/
    - Unit tests.
- makefile: Top-level makefile.
- requirements.txt: Python modules to be installed on the virtual environment.
- ruff.toml: Configurations for Ruff style check.
- setup_env.sh: Script for activating Python virtual environment and installing needed dependencies.
- vsg_config.json: Configurations for VHDL style check.

## Hardware setup

To be able to interact with the implemented processor, you need a USB to serial adapter cable. The USB adapter connects to your host PC. The TX-connector of the serial end connects to pin 1 of the DE10-nano, and the RX-connector connects to pin 2 of the DE10-nano.

## Usage

To compile the HW design or the test SW, you can use the top-level makefile. To interact with the processor (e.g. load SW binary to the program memory, or dump register file contents), you can use the script src/control_tool.py.
