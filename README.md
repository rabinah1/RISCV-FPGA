# RISCV-FPGA
This is a hobby project that implements a simple RISC-V processor on the Terasic DE10-Nano development board. The processor implements the RV32I subset of the RISC-V instruction set. The architecture of the processor is very simple, for example it doesn't have pipelining. It executes only a single instruction at a time. Software can be loaded to the program memory over UART-interface (requires a USB to TTL cable). Program execution can be verified by dumping the register register file to the host computer over UART-interface.

## Repository structure
Below is a short description of the repository structure.

- src/
    - Source code.
- scripts/
    - Scripts.
- test/
    - Unit tests.
- makefile: Top-level makefile.
- requirements.txt: Python modules to be installed to the virtual environment.
- setup_py_env.sh: Script for activating Python virtual environment and installing needed dependencies.
- vsg_config.json: Configuration file for VSG style check.
- ruff.toml: Configuration file for Ruff style check.
