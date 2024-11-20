function [T] = TransformingmatrixPCA(p,n,path)
pos=p;
neg=n;
 Train_points= p + n-20;
% Train_points= p-10;
 T = [];
for i = 11 :pos
    str = int2str(i);
    filename = [ path 'pos-' num2str(i,'%02d') '.pgm'];
    img = double(imread(filename));    
    [irow icol] = size(img);
     
%     img = rgb2gray(img);

    temp = reshape(img',irow*icol,1);   % Reshaping 2D images into 1D image vectors
    T = [T temp]; % 'T' grows after each turn    
    
%     A(:,:,i)=img;       
end
for j = 11 : neg
    str = int2str(i);
    filename = [ path 'neg-' num2str(j,'%02d') '.pgm'];
    img = double(imread(filename));    
    [irow icol] = size(img);
     
%     img = rgb2gray(img);
    temp = reshape(img',irow*icol,1);   % Reshaping 2D images into 1D image vectors
    T = [T temp]; % 'T' grows after each turn     

%   A(:,:,i+j-1)=img;       
    
end
%%%%%%%%%%%%%%%%%%%%%%%% Calculating the mean image 
m = mean(T,2); % Computing the average face image m = (1/P)*sum(Tj's)    (j = 1 : P)
Train_Number = size(T,2);

%%%%%%%%%%%%%%%%%%%%%%%% Calculating the deviation of each image from mean image
A = [];  
for i = 1 : Train_Number  % Train_Number
    temp = double(T(:,i)) - m; % Computing the difference image for each image in the training set Ai = Ti - m
    A = [A temp]; % Merging all centered images
end

% L = A'*A; % L is the surrogate of covariance matrix C=A*A'.
L=A*A';
[V D] = eig(L); % Diagonal elements of D are the eigenvalues for both L=A'*A and C=A*A'.

%%%%%%%%%%%%%%%%%%%%%%%% Sorting and eliminating eigenvalues
% All eigenvalues of matrix L are sorted and those who are less than a
% specified threshold, are eliminated. So the number of non-zero
% eigenvectors may be less than (P-1).

L_eig_vec = [];
for i = 1 : size(V,2) 
   if( D(i,i)>100000000)
        L_eig_vec = [L_eig_vec V(:,i)];
   end
end
T=L_eig_vec;
% size(T)
end




















