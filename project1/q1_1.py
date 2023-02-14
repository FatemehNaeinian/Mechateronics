import time
import serial
import numpy as np
from vpython import *

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
        roll = float(splitPacket[0])*toRad
        pitch = float(splitPacket[1])*toRad
        yaw = float(splitPacket[2])*toRad
        print('roll,pitch,yaw')
        print(roll*toDeg, pitch*toDeg, yaw*toDeg)
        
        Qx = np.array( [[1,0,0 ],[0,np.cos(roll),-np.sin(roll)],[0,np.sin(roll),np.cos(roll)]])
        Qy = np.array( [[np.cos(pitch),0,np.sin(pitch)],[0,1,0],[-np.sin(pitch),0,np.cos(pitch)]])
        Qz = np.array( [[np.cos(yaw),-np.sin(yaw),0],[np.sin(yaw),np.cos(yaw),0],[0,0,1]])
        
        print('rotation matrix')
        Qxyz = np.matmul(np.matmul(Qx,Qy),Qz)
        print(Qxyz)
    except:
        pass