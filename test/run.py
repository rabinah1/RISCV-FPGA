# pylint: disable=missing-docstring
import os
import sys
from vunit import VUnit

tb_name = None
for arg in sys.argv:
    if arg.startswith("tb_lib"):
        tb_name = arg
        break

test_dir = os.path.dirname(__file__)
src_dir = f"{test_dir}/../src"

VU = VUnit.from_argv()
VU.add_vhdl_builtins()
VU.enable_location_preprocessing()

design_lib = VU.add_library("design_lib")
design_lib.add_source_files([os.path.join(src_dir, "*.vhd")])

tb_lib = VU.add_library("tb_lib")
tb_lib.add_source_files([os.path.join(test_dir, "*.vhd")])

if tb_name:
    if "tb_program_counter" in tb_name:
        VU.set_sim_option("modelsim.vsim_flags.gui", ["-lib design_lib", f"-do {test_dir}/tb_program_counter_vsim.txt"])
    elif "tb_program_memory" in tb_name:
        VU.set_sim_option("modelsim.vsim_flags.gui", ["-lib design_lib", f"-do {test_dir}/tb_program_memory_vsim.txt"])
    elif "tb_instruction_decoder" in tb_name:
        VU.set_sim_option("modelsim.vsim_flags.gui", ["-lib design_lib", f"-do {test_dir}/tb_instruction_decoder_vsim.txt"])
    elif "tb_alu_src" in tb_name:
        VU.set_sim_option("modelsim.vsim_flags.gui", ["-lib design_lib", f"-do {test_dir}/tb_alu_src_vsim.txt"])
    elif "tb_writeback_mux" in tb_name:
        VU.set_sim_option("modelsim.vsim_flags.gui", ["-lib design_lib", f"-do {test_dir}/tb_writeback_mux_vsim.txt"])

VU.main()
