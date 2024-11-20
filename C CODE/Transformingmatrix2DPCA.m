function [T] = Transformingmatrix2DPCA(p,n,path)
pos=p;
neg=n;
Train_points= p + n-20;

 T = [];
for i = 11 :pos
    str = int2str(i);
    filename = [ path 'pos-' num2str(i,'%02d') '.pgm'];
    img = double(imread(filename));    
    [irow icol] = size(img);
     
%     img = rgb2gray(img);

     A(:,:,i)=img;       
end
for j = 11 : neg
    str = int2str(i);
    filename = [ path 'neg-' num2str(j,'%02d') '.pgm'];
    img = double(imread(filename));    
    [irow icol] = size(img);
     
%     img = rgb2gray(img);

    A(:,:,i+j-1)=img;       
end
%%
  Amean=A(:,:,3);
   
 for i = 1 : irow
     for j = 1 : icol
                         Amean(i,j)=mean(A(i,j,:));                
     end
 end
 
for k = 1 : Train_points
    Anorm(:,:,k)=A(:,:,k)-Amean;
end

%  imshow(Anorm(:,:,2));
 
 S=zeros(icol);
 for k =1:Train_points
 
 S= S+((double(Anorm(:,:,k))'*double(Anorm(:,:,k))));
 
 end
 
 SA=(1/Train_points)*S;
 
% [u v w]=svd(SA);
  
[V D]=eig(SA);


L_eig_vec = [];
for i = 1 : size(V,2) 
    if( D(i,i)>10000) % 100000
        L_eig_vec = [L_eig_vec V(:,i)];
    end
%     Xopt=max(D(i,i)); Xoptev=V(:,i);
end
T=L_eig_vec;
size(T)
end

