#!/usr/bin/env python3

import argparse
import serial
import tinyrv
from time import sleep
from typing import Dict

BAUD_RATE = 9600
NUM_OF_REGS = 32
NUM_OF_BYTES = 128
WORD_LENGTH = 32
SERIAL_TIMEOUT = 5
MAX_PC_STALL_COUNT = 10
BYTES_PER_REGISTER = 4
UART_READ_TRIG = 1
UART_WRITE_TRIG = 0


def _parse_args() -> argparse.Namespace:
    descr = """
This script can be used to interact with the implemented CPU.
"""
    parser = argparse.ArgumentParser(
        description=descr, formatter_class=argparse.RawDescriptionHelpFormatter
    )
    subparsers = parser.add_subparsers(dest="command")

    load_parser = subparsers.add_parser(
        "load_prog", help="Load a program binary to the program memory."
    )
    load_parser.add_argument("binary", type=str, help="Path to the binary file.")
    load_parser.add_argument(
        "--serial_port",
        type=str,
        default="/dev/ttyUSB0",
        help="Serial port. Default is /dev/ttyUSB0.",
    )

    read_regs_parser = subparsers.add_parser(
        "read_regs", help="Dump the contents of the register file."
    )
    read_regs_parser.add_argument(
        "--serial_port",
        type=str,
        default="/dev/ttyUSB0",
        help="Serial port. Default is /dev/ttyUSB0.",
    )

    simulation_parser = subparsers.add_parser("simulate", help="Simulate a program binary.")
    simulation_parser.add_argument("binary", type=str, help="Path to the binary file.")
    simulation_parser.add_argument(
        "--trace", action="store_true", help="Print all the instructions that are executed."
    )

    hw_test_parser = subparsers.add_parser(
        "test_hw", help="Run a binary on HW and compare the results against a reference model."
    )
    hw_test_parser.add_argument("binary", type=str, help="Path to the binary file.")
    hw_test_parser.add_argument(
        "--serial_port",
        type=str,
        default="/dev/ttyUSB0",
        help="Serial port. Default is /dev/ttyUSB0.",
    )
    hw_test_parser.add_argument(
        "--print_result", action="store_true", help="Print the register values."
    )
    args = parser.parse_args()

    return args


def _load_prog(args: argparse.Namespace) -> None:
    with open(args.binary, "rb") as f:
        data = f.read()

    try:
        ser = serial.Serial(args.serial_port, BAUD_RATE, timeout=SERIAL_TIMEOUT)
    except serial.SerialException as e:
        print(f"Serial communication error when loading program: {e}")
        return
    ser.reset_output_buffer()
    ser.write(bytes([UART_WRITE_TRIG]) + data)
    ser.flush()
    ser.close()


def _print_registers(registers: Dict[str, int]) -> None:
    for reg_name, reg_value in registers.items():
        print(f"{reg_name} : {reg_value}")


def _twos_complement(reg_value: int) -> int:
    if reg_value & (1 << (WORD_LENGTH - 1)) != 0:
        reg_value = reg_value - (1 << WORD_LENGTH)
    return reg_value


def _bytes_to_register(bytes_data: list[int], reg_index: int) -> int:
    offset = reg_index * BYTES_PER_REGISTER
    reg_value = (
        (bytes_data[offset + 3] << 24)
        | (bytes_data[offset + 2] << 16)
        | (bytes_data[offset + 1] << 8)
        | (bytes_data[offset])
    )
    return _twos_complement(reg_value)


def _read_regs(serial_port: str, print_result: bool) -> Dict[str, int]:
    try:
        ser = serial.Serial(serial_port, BAUD_RATE, timeout=SERIAL_TIMEOUT)
    except serial.SerialException as e:
        print(f"Serial communication error when reading registers: {e}")
        return {}
    ser.write(bytes([UART_READ_TRIG]))
    regs = ser.read(NUM_OF_BYTES)
    regs = [i for i in regs]
    reg_values = {}
    if len(regs) != NUM_OF_BYTES:
        print(
            f"Something went wrong with fetching the registers: received {len(regs)} bytes, "
            f"expected {NUM_OF_BYTES}."
        )
        return reg_values
    reg_values = {f"x{idx}": _bytes_to_register(regs, idx) for idx in range(0, NUM_OF_REGS)}
    ser.close()
    if print_result:
        _print_registers(reg_values)

    return reg_values


def _simulate(binary: str, trace: bool, print_result: bool) -> Dict[str, int]:
    with open(binary, "rb") as f:
        data = f.read()

    rv = tinyrv.sim(xlen=WORD_LENGTH)
    rv.pc = 0x0
    rv.copy_in(rv.pc, data)

    previous_pc = rv.pc
    no_pc_change_count = 0
    while no_pc_change_count <= MAX_PC_STALL_COUNT:
        rv.step(trace)
        if rv.pc == previous_pc:
            no_pc_change_count += 1
        else:
            no_pc_change_count = 0
        previous_pc = rv.pc

    regs = {f"x{idx}": rv.x[idx] for idx in range(0, NUM_OF_REGS)}
    if print_result:
        _print_registers(regs)

    return regs


def _test_hw(args: argparse.Namespace) -> None:
    print("Loading binary to the board...")
    _load_prog(args)
    sleep(2)
    print("Dumping register file contents from the board...")
    hw_result = _read_regs(args.serial_port, args.print_result)
    sleep(1)
    print("Running simulation...")
    simulation_result = _simulate(args.binary, False, args.print_result)

    if hw_result == simulation_result:
        print("Tests passed")
    else:
        print("Tests failed")
        print("Registers dumped from HW:")
        print(hw_result)
        print("Registers based on reference model:")
        print(simulation_result)


def main():
    args = _parse_args()
    if args.command == "load_prog":
        _load_prog(args)
    elif args.command == "read_regs":
        _read_regs(args.serial_port, True)
    elif args.command == "simulate":
        _simulate(args.binary, args.trace, True)
    elif args.command == "test_hw":
        _test_hw(args)


if __name__ == "__main__":
    main()
