import time
import serial
import numpy as np
from vpython import *
import math 

arduinoData = serial.Serial('com7', 115200)
time.sleep(10)

toRad = np.pi/180.0
toDeg = 1/toRad

scene.range = 4
scene.forward = vector(-1,-1,-1)
scene.width = 600
scene.height = 600
xarr = arrow(length=2 , shaftwidth=0.1 ,color=color.red, axis=vector(1,0,0))
yarr = arrow(length=2 , shaftwidth=0.1 ,color=color.green, axis=vector(0,1,0))
zarr = arrow(length=2 , shaftwidth=0.1 ,color=color.blue, axis=vector(0,0,1))

frontarr = arrow(length=4 ,shaftwidth=0.1 ,color=color.purple,axis=vector(1,0,0))
uparr = arrow(length=1,shaftwidth=0.1 ,color=color.magenta,axis=vector(0,1,0))
sidearr = arrow(length=1,shaftwidth=0.1 ,color=color.orange,axis=vector(0,0,1))
bBoard = box(length=6,width=2,height=0.2,opacity=0.8,pos=vector(0,0,0))
sensor = box(length=1,width=0.75,height=0.1,color=color.blue,pos=vector(0.5,0.15,0))
arduino = box(length=1.75,width=0.6,height=0.1,color=color.green,pos=vector(2,0.15,0))
obj = compound([bBoard,sensor,arduino])

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
    
        roll = math.atan2(2*(q0*q1+q2*q3),1-2*(q1*q1+q2*q2))
        pitch = -asin(2*(q0*q2-q3*q1))
        yaw = math.atan2(2*(q0*q3+q1*q2),1-2*(q2*q2+q3*q3))
        
        k = vector(cos(yaw)*cos(pitch),sin(pitch),sin(yaw)*cos(pitch))
        y = vector(0,1,0)
        s = cross(k,y)
        v = cross(s,k)
        vrot = v*cos(roll)+cross(k,v)*sin(roll)
        frontarr.axis = k 
        uparr.axis = vrot
        sidearr.axis = cross(k,vrot)
        obj.axis = k
        obj.up = vrot
        frontarr.length = 2
        uparr.length = 4
        sidearr.length = 1
        
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