#!/usr/bin/env python
# coding: utf-8

# In[1]:


import numpy as np
import time
import cv2
import os
import subprocess


# In[5]:


LABELS = open("coco.names").read().strip().split("\n")


print("[INFO] loading YOLO from disk...")
net = cv2.dnn.readNetFromDarknet("yolov3.cfg", "yolov3.weights")


ln = net.getLayerNames()
ln = [ln[i[0] - 1] for i in net.getUnconnectedOutLayers()]


# In[6]:


import imageio
from PIL import Image


# In[29]:


def take_photo(imagepath):
    frame = imageio.imread(imagepath)
# print(frame.shape)
    (H, W) = frame.shape[:2]
#     print(H, W)
    blob = cv2.dnn.blobFromImage(frame, 1 / 255.0, (416, 416),
    swapRB=True, crop=False)
    net.setInput(blob)
    layerOutputs = net.forward(ln)


    boxes = []
    confidences = []
    classIDs = []
    centers = []

# loop over each of the layer outputs
    for output in layerOutputs:
# loop over each of the detections


        for detection in output:


            scores = detection[5:]
            classID = np.argmax(scores)
            confidence = scores[classID]

       
            if confidence > 0.5:

                        box = detection[0:4] * np.array([W, H, W, H])
                        (centerX, centerY, width, height) = box.astype("int")


                        x = int(centerX - (width / 2))
                        y = int(centerY - (height / 2))


                        boxes.append([x, y, int(width), int(height)])
                        confidences.append(float(confidence))
                        classIDs.append(classID)
                        centers.append((centerX, centerY))


        idxs = cv2.dnn.NMSBoxes(boxes, confidences, 0.5, 0.3)
        texts = []

#         print(confidences)
        if len(idxs) > 0:

            for i in idxs.flatten():

                
                centerX, centerY = centers[i][0], centers[i][1]
                if centerX <= W/3:
                    W_pos = "left "
                elif centerX <= (W/3 * 2):
                    W_pos = "center "
                else:
                    W_pos = "right "

                if centerY <= H/3:
                    H_pos = "top" 
                elif centerY <= (H/3 * 2):
                    H_pos = "mid "
                else:
                    H_pos = "bottom "

                texts.append('H_pos + W_pos + {0} + {1} + {2} + {3} + {4}'.format(LABELS[classIDs[i]],confidences[i], centerX, centerY, boxes[i]))

    return (texts)


# In[30]:





# In[ ]:




