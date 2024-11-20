import numpy as np
import cv2
from matplotlib import pyplot as plt
import os
cwd = os.getcwd()
print(cwd)
os.chdir("G:\Imagesearch")
cwd = os.getcwd()
print(cwd)



# Load an color image in grayscale
img = cv2.imread("dataset/test1.JPG",1)
print(img.shape)
print(img.size)
print(img.dtype)

cv2.imshow('image',img)

# Histogram
hist = cv2.calcHist([img],[0],None,[256],[0,256])

# R G B histogram

color = ('b','g','r')
for i,col in enumerate(color):
 histr = cv2.calcHist([img],[i],None,[256],[0,256])
 plt.plot(histr,color = col)
plt.xlim([0,256])
plt.show()

# Gray scale image 
img_gray_image = cv2.cvtColor(img, cv2.COLOR_BGR2GRAY)


# Histogarm equaliszed image 

equ = cv2.equalizeHist(img_gray_image)
cv2.imshow('equaliszed',equ)
print(equ.shape)
print(equ.size)
print(equ.dtype)


hsv = cv2.cvtColor(img,cv2.COLOR_BGR2HSV)
hist = cv2.calcHist( [hsv], [0, 1], None, [180, 256], [0, 180, 0, 256] )
plt.imshow(hist,interpolation = 'nearest')
plt.show()


# edge detection

# SIFT

# SURF

cv2.waitKey(0)
cv2.destroyAllWindows()

















