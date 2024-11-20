clc
clear all
I = imread('lena.gif');
[m ,n] = size(I);
T = 0.25;

%% compression using dft coefficients

I_dft = fft2(I)/(m*n);
I_dftre = real(I_dft);
I_dftim = imag(I_dft);

% soft thresholding
t1 = wthresh(I_dftre,'s',T);
t2 = wthresh(I_dftim,'s',T);
I_idft = m*n*ifft2(t1+i*t2);
subplot(121),imshow((I_idft),[]);
title('compression by dft:soft threshold')

% hard thresholding
t1 = wthresh(I_dftre,'h',T);
t2 = wthresh(I_dftim,'h',T);
I_idft = m*n*ifft2(t1+i*t2);
subplot(122),imshow((I_idft),[]);
title('compression by dft:hard threshold')



%% compression using dct coefficients

I_dft = dct2(I)/sqrt((m*n));

% soft thresholding
t1 = wthresh(I_dft,'s',T);

I_idft = sqrt((m*n))*idct2(t1);
figure(2),subplot(121),imshow(I_idft,[]);
title('compression by dct:soft threshold')


% hard thresholding
t1 = wthresh(I_dft,'h',T);

I_idft = sqrt((m*n))*idct2(t1);
subplot(122),imshow(I_idft,[]);
title('compression by dct:hard threshold')


%% compression using dwt coefficients

[cA,cH,cV,cD] = dwt2(I,'db1');

% soft thresholding
t1 = wthresh(cA,'s',T);
t2 = wthresh(cH,'s',T);
t3 = wthresh(cV,'s',T);
t4 = wthresh(cD,'s',T);
I_idft = idwt2(t1,t2,t3,t4,'db1');

figure(3),subplot(121),imshow((I_idft),[]);
title('compression by dwt:soft threshold')

% hard thresholding
t1 = wthresh(cA,'h',T);
t2 = wthresh(cH,'h',T);
t3 = wthresh(cV,'h',T);
t4 = wthresh(cD,'h',T);
I_idft = idwt2(t1,t2,t3,t4,'db1');
subplot(122),imshow((I_idft),[]);
title('compression by dwt:hard threshold')



