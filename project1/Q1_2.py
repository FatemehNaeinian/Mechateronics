import time
import serial
import numpy as np
from vpython import *
import re

arduinoData = serial.Serial('com7', 115200)
time.sleep(100)

toRad = np.pi/180.0
toDeg = 1/toRad

while True:
    while arduinoData.inWaiting() == 0:
        pass
    dataPacket = arduinoData.readline()
    try:
        dataPacket = str(dataPacket, 'utf-8')
        splitPacket = dataPacket.split(",")

        q0 = float(splitPacket[0])
        q1 = float(splitPacket[1])
        q2 = float(splitPacket[2])
        q3 = float(splitPacket[3])

        print('Quaternions')
        print(q0,q1,q2,q3) 
        
        rm11 = 2 * (q0 * q0 + q1 * q1) - 1
        rm12 = 2 * (q1 * q2 - q0 * q3)
        rm13 = 2 * (q1 * q3 + q0 * q2)
        rm21 = 2 * (q1 * q2 + q0 * q3)
        rm22 = 2 * (q0 * q0 + q2 * q2) - 1
        rm23 = 2 * (q2 * q3 - q0 * q1)
        rm31 = 2 * (q1 * q3 - q0 * q2)
        rm32 = 2 * (q2 * q3 + q0 * q1)
        rm33 = 2 * (q0 * q0 + q3 * q3) - 1

        rotation_matrix = np.array([[rm11, rm12, rm13],[rm21, rm22, rm23],[rm31, rm32, rm33]])
        print('rotation matrix')
        print(rotation_matrix)
    except:
        pass