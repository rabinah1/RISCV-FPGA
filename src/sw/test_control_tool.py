#!/usr/bin/env python3

import os
import pytest
from control_tool import _twos_complement, _read_file_and_check_errors, _bytes_to_register

SCRIPT_PATH = os.path.dirname(os.path.realpath(__file__))


def test_twos_complement_positive_number():
    temp = _twos_complement(10)
    assert temp == 10


def test_twos_complement_negative_number():
    temp = _twos_complement(4294967295)
    assert temp == -1

def test_read_file_and_check_errors_success():
    test_string = b"1010"
    with open(f"{SCRIPT_PATH}/test.bin", "wb") as f:
        f.write(test_string)

    data = _read_file_and_check_errors(f"{SCRIPT_PATH}/test.bin")
    os.remove(f"{SCRIPT_PATH}/test.bin")
    assert data == b"1010"

def test_read_file_and_check_errors_file_not_found():
    test_string = b"1010"
    with open(f"{SCRIPT_PATH}/test.bin", "wb") as f:
        f.write(test_string)

    data = _read_file_and_check_errors(f"{SCRIPT_PATH}/invalid.bin")
    os.remove(f"{SCRIPT_PATH}/test.bin")
    assert data == ""

def test_bytes_to_register():
    bytes_data = [1, 2, 3, 4]
    reg_index = 0
    data = _bytes_to_register(bytes_data, reg_index)
    assert data == 67305985
