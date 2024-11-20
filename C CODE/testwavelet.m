  
path='E:\SVM or Random Forest\IMAGE_CLASSIFICATION\DATABASE\CarData\CarData\TrainImages\';
filename = [ path 'pos-' '345' '.pgm'];
  img = double(imread(filename));   
  I=img;
  I= wavelettransform( img);
  
  temp=I(:);
  
  