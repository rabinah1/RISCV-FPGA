import argparse
import serial


def _parse_args():
    descr = """
This script is used to load the SW binary to the program memory.
"""
    parser = argparse.ArgumentParser(description=descr,
                                     formatter_class=argparse.RawDescriptionHelpFormatter)
    parser.add_argument("binary", type=str,
                        help="Path to the binary file.")
    parser.add_argument("--serial_port", type=str, default="/dev/ttyUSB0",
                        help="Serial port. Default is /dev/ttyUSB0.")
    parser.add_argument("--baud_rate", type=int, default=9600,
                        help="Baud rate. Default is 9600.")
    args = parser.parse_args()

    return args


def main():
    args = _parse_args()
    with open(args.binary, "rb") as f:
        data = f.read()

    ser = serial.Serial(args.serial_port, args.baud_rate)
    ser.write(data)
    ser.close()


if __name__ == "__main__":
    main()
