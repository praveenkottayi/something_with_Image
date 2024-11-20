clc
clear all
I = imread('car.jpg');
I=rgb2gray(I);
imshow(I);
[m ,n] = size(I);
T = 1;

%% compression using dwt coefficients

[cA,cH,cV,cD] = dwt2(I,'haar');

% soft thresholding
t1 = wthresh(cA,'s',T);
t2 = wthresh(cH,'s',T);
t3 = wthresh(cV,'s',T);
t4 = wthresh(cD,'s',T);
I_idft = idwt2(t1,t2,t3,t4,'haar');

figure(3),subplot(121),imshow((I_idft),[]);
title('compression by dwt:soft threshold')

% hard thresholding
t1 = wthresh(cA,'h',T);
t2 = wthresh(cH,'h',T);
t3 = wthresh(cV,'h',T);
t4 = wthresh(cD,'h',T);
I_idft = idwt2(t1,t2,t3,t4,'haar');
subplot(122),imshow((I_idft),[]);
title('compression by dwt:hard threshold')


[cA,cH,cV,cD] = dwt2(I,'morl');

% soft thresholding
t1 = wthresh(cA,'s',T);
t2 = wthresh(cH,'s',T);
t3 = wthresh(cV,'s',T);
t4 = wthresh(cD,'s',T);
I_idft = idwt2(t1,t2,t3,t4,'morl');

figure(3),subplot(121),imshow((I_idft),[]);
title('compression by dwt:soft threshold')

% hard thresholding
t1 = wthresh(cA,'h',T);
t2 = wthresh(cH,'h',T);
t3 = wthresh(cV,'h',T);
t4 = wthresh(cD,'h',T);
I_idft = idwt2(t1,t2,t3,t4,'morl');
subplot(122),imshow((I_idft),[]);
title('compression by dwt:hard threshold')
