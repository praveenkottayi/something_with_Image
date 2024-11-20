import numpy as np
import cv2
from matplotlib import pyplot as plt
import os
import io
import sys
from os import listdir
from os.path import isfile, join

#image = cv2.imread('blob.jpg')
#image = cv2.imread('test3.jpg')
#image = cv2.imread('sample1.jpg')
#image = cv2.imread('blob.png')
#image=255-image

def extract_connected_components(image):
    gray = cv2.cvtColor(image,cv2.COLOR_BGR2GRAY)
    ret, thresh = cv2.threshold(gray,0,255,cv2.THRESH_BINARY_INV+cv2.THRESH_OTSU)
#    cv2.imshow("image",thresh)
    # find contours in the thresholded image
    cnts = cv2.findContours(thresh.copy(), cv2.RETR_EXTERNAL,
    	cv2.CHAIN_APPROX_SIMPLE)[-2]
    print("[INFO] {} unique contours found".format(len(cnts)))
#    extracted_wave_image=image
    extracted_wave_image=255-(image*0)
    # loop over the contours
    for (i, c) in enumerate(cnts):
    	# draw the contour
    	if len(c)>700 :
                	((x, y), _) = cv2.minEnclosingCircle(c)
                	print len(c)
                	cv2.putText(image, "#{}".format(i + 1), (int(x) - 10, int(y)), cv2.FONT_HERSHEY_SIMPLEX, 0.6, (0, 0, 255), 2)
                	cv2.drawContours(extracted_wave_image, [c], -1, (0, 0, 0), 2)
    cv2.imshow("Connected components",extracted_wave_image)
    cv2.imwrite("test_writing.jpg",extracted_wave_image)
    cv2.waitKey(0)

#######################   main  ##################
image = cv2.imread('blob.png')
image=255-image
#image = cv2.imread('test3.jpg')
extract_connected_components(image)

