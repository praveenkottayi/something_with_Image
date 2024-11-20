#############################################################
##             Praveen's Moon TRacker
##
#############################################################
# import the necessary packages

import numpy as np

import cv2


# load the image and perform pyramid mean shift filtering
# to aid the thresholding step
image = cv2.imread("blob.jpg") # test image

image = cv2.imread("moon_tracker.jpg")
image=255-image


cv2.imshow("Input", image)

# convert the mean shift image to grayscale, then apply
# Otsu's thresholding
gray = cv2.cvtColor(image, cv2.COLOR_BGR2GRAY)
ret, thresh = cv2.threshold(gray,180,255,cv2.THRESH_BINARY_INV+cv2.THRESH_OTSU)
cv2.imshow("Thresh", thresh)


# find contours in the thresholded image
cnts = cv2.findContours(thresh.copy(), cv2.RETR_EXTERNAL,
	cv2.CHAIN_APPROX_SIMPLE)[-2]
print("[INFO] {} unique contours found".format(len(cnts)))

# loop over the contours
for (i, c) in enumerate(cnts):
	# draw the contour
	((x, y), _) = cv2.minEnclosingCircle(c)
	cv2.putText(image, "#{}".format(i + 1), (int(x) - 10, int(y)),
		cv2.FONT_HERSHEY_SIMPLEX, 0.6, (0, 0, 255), 2)
	cv2.drawContours(image, [c], -1, (0, 255, 0), 2)

# show the output image
cv2.imshow("Image", image)
cv2.waitKey(0)