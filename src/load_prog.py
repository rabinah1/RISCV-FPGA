import argparse
import serial

BAUD_RATE = 9600


def _parse_args():
    descr = """
This script is used to load the SW binary to the program memory.
"""
    parser = argparse.ArgumentParser(
        description=descr, formatter_class=argparse.RawDescriptionHelpFormatter
    )
    parser.add_argument("binary", type=str, help="Path to the binary file.")
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
    with open(args.binary, "rb") as f:
        data = f.read()

    ser = serial.Serial(args.serial_port, BAUD_RATE)
    ser.reset_output_buffer()
    ser.write(bytes([0]) + data)
    ser.flush()
    ser.close()


if __name__ == "__main__":
    main()
