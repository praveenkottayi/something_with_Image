function [ I ] = wavelettransform( img)
T=.25;

[cA,cH,cV,cD] = dwt2(img,'haar');

% soft thresholding

t1 = wthresh(cA,'h',T);
t2 = wthresh(cH,'h',T);
t3 = wthresh(cV,'h',T);
t4 = wthresh(cD,'h',T);
I= idwt2(t1,t2,t3,t4,'haar');

end

