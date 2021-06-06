


# importing modules
import cv2
import numpy as np
import easyocr


def recognize_text(img_path):
    '''loads an image and recognizes text.'''

    reader = easyocr.Reader(['en'])
    return reader.readtext(img_path)