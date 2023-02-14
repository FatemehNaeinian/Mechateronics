import cv2
import mediapipe as mp
import numpy as np
from vpython import *

scene.range = 4
scene.forward = vector(-1,-1,-1)
scene.width = 600
scene.height = 600
xarr = arrow(length=2 , shaftwidth=0.1 ,color=color.red, axis=vector(1,0,0))
yarr = arrow(length=2 , shaftwidth=0.1 ,color=color.green, axis=vector(0,1,0))
zarr = arrow(length=2 , shaftwidth=0.1 ,color=color.blue, axis=vector(0,0,1))

bb = box(length=6,width=2,height=0.2,opacity=0.8,pos=vector(0,0,0))
hand = box(length=1.75,width=0.6,height=0.1,color=color.green,pos=vector(2,0.15,0))
obj = compound([bb,hand])

mp_drawing = mp.solutions.drawing_utils
mp_drawing_styles = mp.solutions.drawing_styles
mp_hands = mp.solutions.hands

IMAGE_FILES = []
with mp_hands.Hands(
    static_image_mode=True,
    max_num_hands=1,
    min_detection_confidence=0.5) as hands:
    for idx, file in enumerate(IMAGE_FILES):
        image = cv2.flip(cv2.imread(file), 1)
        results = hands.process(cv2.cvtColor(image, cv2.COLOR_BGR2RGB))
        print('Handedness:', results.multi_handedness)
        if not results.multi_hand_landmarks:
            continue
        image_height, image_width, _ = image.shape
        annotated_image = image.copy()
        for hand_landmarks in results.multi_hand_landmarks:
            print('hand_landmarks:', hand_landmarks)
            print(
            f'Index finger tip coordinates: (',
            f'{hand_landmarks.landmark[mp_hands.HandLandmark.INDEX_FINGER_TIP].x * image_width}, '
            f'{hand_landmarks.landmark[mp_hands.HandLandmark.INDEX_FINGER_TIP].y * image_height})'
            )
            mp_drawing.draw_landmarks(
            annotated_image,
            hand_landmarks,
            mp_hands.HAND_CONNECTIONS,
            mp_drawing_styles.get_default_hand_landmarks_style(),
            mp_drawing_styles.get_default_hand_connections_style())
            cv2.imwrite(
            '/tmp/annotated_image' + str(idx) + '.png', cv2.flip(annotated_image, 1))
        if not results.multi_hand_world_landmarks:
            continue
        for hand_world_landmarks in results.multi_hand_world_landmarks:
            mp_drawing.plot_landmarks(
            hand_world_landmarks, mp_hands.HAND_CONNECTIONS, azimuth=5)

cap = cv2.VideoCapture(0)
with mp_hands.Hands(
    model_complexity=0,
    min_detection_confidence=0.5,
    min_tracking_confidence=0.5) as hands:
    while cap.isOpened():
        success, image = cap.read()
        if not success:
            print("Ignoring empty camera frame.")
            continue
        image.flags.writeable = False
        image = cv2.cvtColor(image, cv2.COLOR_BGR2RGB)
        results = hands.process(image)
        image.flags.writeable = True
        image = cv2.cvtColor(image, cv2.COLOR_RGB2BGR)
        if results.multi_hand_landmarks:
            for hand_landmarks in results.multi_hand_landmarks:
                point1 = hand_landmarks.landmark[mp_hands.HandLandmark(0).value]
                point2 = hand_landmarks.landmark[mp_hands.HandLandmark(5).value]
                point3 = hand_landmarks.landmark[mp_hands.HandLandmark(17).value]
                vect1 = vector(point2.x-point1.x,-point2.y+point1.y,-point2.z+point1.z)
                vect2 = vector(point3.x-point1.x,-point3.y+point1.y,-point3.z+point1.z)
                up = cross(vect2,vect1)
                up = norm(up)
                vect1=norm(vect1+vect2)
                obj.axis = -vect1
                obj.up = -up
                mp_drawing.draw_landmarks(
                image,
                hand_landmarks,
                mp_hands.HAND_CONNECTIONS,
                mp_drawing_styles.get_default_hand_landmarks_style(),
                mp_drawing_styles.get_default_hand_connections_style())
        cv2.imshow('MediaPipe Hands', cv2.flip(image, 1))
        if cv2.waitKey(5) & 0xFF == 27:
            break
cap.release()
