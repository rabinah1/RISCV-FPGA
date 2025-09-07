import argparse
import serial

BAUD_RATE = 9600
NUM_OF_BYTES = 128  # There are 32 registers, each of size 4 bytes (1 byte = 8 bits).


def _parse_args():
    descr = """
This script is used to dump the register file contents.
"""
    parser = argparse.ArgumentParser(
        description=descr, formatter_class=argparse.RawDescriptionHelpFormatter
    )
    parser.add_argument(
        "--serial_port",
        type=str,
        default="/dev/ttyUSB0",
        help="Serial port. Default is /dev/ttyUSB0.",
    )
    args = parser.parse_args()

    return args


def main():
    args = _parse_args()
    ser = serial.Serial(args.serial_port, BAUD_RATE, timeout=10)
    ser.write(bytes([1]))
    regs = ser.read(NUM_OF_BYTES)
    regs = [i for i in regs]
    reg_values = {}
    temp = 0
    idx = 0
    while idx < 32:
        reg_values[f"x{idx}"] = (
            (regs[temp + 3] << 24) | (regs[temp + 2] << 16) | (regs[temp + 1] << 8) | regs[temp]
        )
        temp = temp + 4
        idx = idx + 1
    for key, value in reg_values.items():
        print(f"{key} : {value}")


if __name__ == "__main__":
    main()
