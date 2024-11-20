%% for single image ........myfn2dpca

Train_Number=20;
 A=[];
%  T = [];
for i = 1 : Train_Number
    str = int2str(i);
    str = strcat('\',str,'.jpg');   
    img = (imread(str));    
    img = rgb2gray(img);
    [irow icol ] = size(img);
    A(:,:,i)=img;       
end

  Amean=A(:,:,3);
   
 for i = 1 : irow
     for j = 1 : icol
                         Amean(i,j)=mean(A(i,j,:));                
     end
 end
 
for k = 1 : Train_Number
    Anorm(:,:,k)=A(:,:,k)-Amean;
end

 imshow(Anorm(:,:,2));
 
 S=zeros(icol);
 for k =1:Train_Number
 
 S= S+((double(Anorm(:,:,k))'*double(Anorm(:,:,k))));
 
 end
 
 SA=(1/Train_Number)*S;
 
 [u v w]=svd(SA);
  
[V D]=eig(SA);




L_eig_vec = [];
for i = 1 : size(V,2) 
    if( D(i,i)>1000000) % 100000
        L_eig_vec = [L_eig_vec V(:,i)];
    end
    Xopt=max(D(i,i)); Xoptev=V(:,i);
end

% % % % % SX=Xoptev'*SA*Xoptev;  % scatter matrix ofbest eigen value ;) 
% % % % % test= L_eig_vec'*SA*L_eig_vec;  % scatter matrix
 

Eigenfaces = SA * L_eig_vec; % A: centered image vectors
%  '.....................feature    vector........................

TestImage='0.jpg';
Img = imread(TestImage);
Test = rgb2gray(Img);




% [irow icol] = size(temp);

Y0=double(Test)*L_eig_vec;
Y1=double(A(:,:,1))*L_eig_vec;
Y2=double(A(:,:,2))*L_eig_vec;
Y3=double(A(:,:,3))*L_eig_vec;
Y4=double(A(:,:,4))*L_eig_vec;

Ytest=[norm(Y0-Y3) norm(Y0-Y4)]


% Image reconstruction;
g=double(Test)*L_eig_vec*L_eig_vec'
imshow(uint8(g))











