import serial
with open("test", "rb") as f:
    data = f.read()

ser = serial.Serial("/dev/ttyUSB0", 9600)
ser.write(data)
ser.close()
