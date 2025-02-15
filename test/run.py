# pylint: disable=missing-docstring
import os
import sys
from vunit import VUnit

SCRIPT_DIR = os.path.dirname(os.path.realpath(__file__))

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
tb_lib.add_source_files([os.path.join(src_dir, "*states_package.vhd")])

VU.set_sim_option("modelsim.vsim_flags", [f"-ginput_file={SCRIPT_DIR}/riscv_stimulus.txt"])

if tb_name:
    if "tb_program_counter" in tb_name:
        VU.set_sim_option("modelsim.vsim_flags.gui", ["-lib design_lib", f"-do {test_dir}/tb_program_counter_vsim.txt"])
    elif "tb_program_memory" in tb_name:
        VU.set_sim_option("modelsim.vsim_flags.gui", ["-lib design_lib", f"-do {test_dir}/tb_program_memory_vsim.txt"])
    elif "tb_instruction_decoder" in tb_name:
        VU.set_sim_option("modelsim.vsim_flags.gui", ["-lib design_lib", f"-do {test_dir}/tb_instruction_decoder_vsim.txt"])
    elif "tb_mux_3_inputs" in tb_name:
        VU.set_sim_option("modelsim.vsim_flags.gui", ["-lib design_lib", f"-do {test_dir}/tb_mux_3_inputs_vsim.txt"])
    elif "tb_writeback_mux" in tb_name:
        VU.set_sim_option("modelsim.vsim_flags.gui", ["-lib design_lib", f"-do {test_dir}/tb_writeback_mux_vsim.txt"])
    elif "tb_pc_offset_mux" in tb_name:
        VU.set_sim_option("modelsim.vsim_flags.gui", ["-lib design_lib", f"-do {test_dir}/tb_pc_offset_mux_vsim.txt"])
    elif "tb_register_file" in tb_name:
        VU.set_sim_option("modelsim.vsim_flags.gui", ["-lib design_lib", f"-do {test_dir}/tb_register_file_vsim.txt"])
    elif "tb_data_memory" in tb_name:
        VU.set_sim_option("modelsim.vsim_flags.gui", ["-lib design_lib", f"-do {test_dir}/tb_data_memory_vsim.txt"])
    elif "tb_alu" in tb_name:
        VU.set_sim_option("modelsim.vsim_flags.gui", ["-lib design_lib", f"-do {test_dir}/tb_alu_vsim.txt"])
    elif "tb_pc_adder" in tb_name:
        VU.set_sim_option("modelsim.vsim_flags.gui", ["-lib design_lib", f"-do {test_dir}/tb_pc_adder_vsim.txt"])
    elif "tb_state_machine" in tb_name:
        VU.set_sim_option("modelsim.vsim_flags.gui", ["-lib design_lib", f"-do {test_dir}/tb_state_machine_vsim.txt"])
    elif "tb_riscv" in tb_name:
        VU.set_sim_option("modelsim.vsim_flags.gui", ["-lib design_lib", f"-do {test_dir}/tb_riscv_vsim.txt", f"-ginput_file={SCRIPT_DIR}/riscv_stimulus.txt"])
    elif "tb_clk_div" in tb_name:
        VU.set_sim_option("modelsim.vsim_flags.gui", ["-lib design_lib", f"-do {test_dir}/tb_clk_div_vsim.txt"])

VU.main()

# Example command: python3 run.py tb_lib.tb_program_memory.test_output_instruction_is_read_correctly_with_specific_address --gui
