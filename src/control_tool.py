import argparse
import serial
import tinyrv
from time import sleep

BAUD_RATE = 9600
NUM_OF_REGS = 32
NUM_OF_BYTES = 128  # There are 32 registers, each of size 4 bytes (1 byte = 8 bits)
WORD_LENGTH = 32
STACK_POINTER_INIT = 0x200


def _parse_args():
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
    args = parser.parse_args()

    return args


def _load_prog(args):
    with open(args.binary, "rb") as f:
        data = f.read()

    ser = serial.Serial(args.serial_port, BAUD_RATE)
    ser.reset_output_buffer()
    ser.write(bytes([0]) + data)
    ser.flush()
    ser.close()


def _read_regs(args, print_result=True):
    ser = serial.Serial(args.serial_port, BAUD_RATE, timeout=5)
    ser.write(bytes([1]))
    regs = ser.read(NUM_OF_BYTES)
    regs = [i for i in regs]
    reg_values = {}
    temp = 0
    idx = 0
    while idx < NUM_OF_REGS:
        reg_values[f"x{idx}"] = (
            (regs[temp + 3] << 24) | (regs[temp + 2] << 16) | (regs[temp + 1] << 8) | regs[temp]
        )
        temp = temp + 4
        idx = idx + 1
    if print_result:
        for key, value in reg_values.items():
            print(f"{key} : {value}")

    return reg_values


def _simulate(args, print_result=True):
    with open(args.binary, "rb") as f:
        data = f.read()

    start_flag = False
    rv = tinyrv.sim(xlen=WORD_LENGTH)
    rv.x[2] = STACK_POINTER_INIT
    rv.pc = 0x0
    rv.copy_in(rv.pc, data)

    while True:
        if rv.pc == 0x0 and start_flag:
            break
        rv.step()
        start_flag = True

    regs = {}
    idx = 0
    while idx < NUM_OF_REGS:
        regs[f"x{idx}"] = rv.x[idx]
        idx = idx + 1
    if print_result:
        for key, value in regs.items():
            print(f"{key} : {value}")

    return regs


def _test_hw(args):
    print("Loading binary to the board...")
    _load_prog(args)
    sleep(2)
    print("Dumping register file contents from the board...")
    hw_result = _read_regs(args, False)
    sleep(1)
    print("Running simulation...")
    simulation_result = _simulate(args, False)

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
        _read_regs(args)
    elif args.command == "simulate":
        _simulate(args)
    elif args.command == "test_hw":
        _test_hw(args)


if __name__ == "__main__":
    main()
