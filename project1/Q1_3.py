import time
import serial
import numpy as np
from vpython import *

arduinoData = serial.Serial('com7', 115200)
time.sleep(100)

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
        roll = float(splitPacket[0])*toRad
        pitch = float(splitPacket[1])*toRad
        yaw = float(splitPacket[2])*toRad
        print('roll,pitch,yaw')
        print(roll*toDeg, pitch*toDeg, yaw*toDeg)
        
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
        
        Qx = np.array( [[1,0,0 ],[0,cos(roll),-sin(roll)],[0,sin(roll),cos(roll)]])
        Qy = np.array( [[cos(pitch),0,sin(pitch)],[0,1,0],[-sin(pitch),0,cos(pitch)]])
        Qz = np.array( [[cos(yaw),-sin(yaw),0],[sin(yaw),cos(yaw),0],[0,0,1]])
        
        print('rotation matrix')
        Qxyz = np.matmul(np.matmul(Qx,Qy),Qz)
        print(Qxyz)
    except:
        pass