
function [F NF] = getcardata()
path='E:\SVM or Random Forest\IMAGE_CLASSIFICATION\DATABASE\CarData\CarData\TrainImages\';
neg=499; pos=549;

F = [];NF=[];F1=[];NF1=[];


%display(pos);

display(' Select the Feature Extraction method, to create data matix for classification ');
display('1.PCA    2.2DPCA     3.HOG     4.SIFT    5.DISCRETE WAVELET TRANSFORM   0.No Feature Extraction');
     ch=0;
    ch=input('Enter UR choice:');
    
switch(ch)
    
       
    %%    
case 0
for i = 11 : pos
    str = int2str(i);
    filename = [ path 'pos-' num2str(i,'%02d') '.pgm'];
    img = double(imread(filename));    
    [irow icol] = size(img);
    
            temp = reshape(img',irow*icol,1);   % Reshaping 2D images into 1D image vectors
%        temp=HOGmatlab(img);
%         temp=img*T;temp=temp(:);        
    
    F = [F temp]; % 'T' grows after each turn                    
end

for i = 11 : neg
    str = int2str(i);
    filename = [ path 'neg-' num2str(i,'%02d') '.pgm'];
    img = double(imread(filename));    
    [irow icol] = size(img);
    
        temp = reshape(img',irow*icol,1);   % Reshaping 2D images into 1D image vectors
%        temp=HOGmatlab(img);
%         temp=img*T;temp=temp(:);
    
    NF = [NF temp]; % 'T' grows after each turn                    
end
%% 



case 1    % some trouble with dimension matching !!! check
T=[];
            T=TransformingmatrixPCA(pos,neg,path);
            
    for i = 11 : pos
    str = int2str(i);
    filename = [ path 'pos-' num2str(i,'%02d') '.pgm'];
    img = double(imread(filename));    
    [irow icol] = size(img);
    temp = reshape(img',irow*icol,1);
    %        temp=img*T; temp=temp(:);        
       F1 = [F1 temp]; % 'T' grows after each turn  
    
    end
%        F=F1*T;

for i = 11 : neg
    str = int2str(i);
    filename = [ path 'neg-' num2str(i,'%02d') '.pgm'];
    img = double(imread(filename));    
    [irow icol] = size(img);
    
      temp = reshape(img',irow*icol,1);   % Reshaping 2D images into 1D image vectors
     temp=temp(:);
    
    F1 = [F1 temp]; % 'T' grows after each turn                    
end
 display('f1');size(F1)
 display('T');size(T)
   NF1=T'*F1;
  display('NF1=T*F1'); size(NF1)
   
   F=NF1(:,1:539);
   NF=NF1(:,540:1028);
 size(F)
 size(NF)
%%

case 2
T=[];
T=Transformingmatrix2DPCA(pos,neg,path);
                        
    for i = 11 : pos
    str = int2str(i);
    filename = [ path 'pos-' num2str(i,'%02d') '.pgm'];
    img = double(imread(filename));    
    [irow icol] = size(img);
    
%             temp = reshape(img',irow*icol,1);   % Reshaping 2D images into 1D image vectors
%        temp=HOGmatlab(img);
       temp=img*T;temp=temp(:);        
    
    F = [F temp]; % 'T' grows after each turn                    
end

for i = 11 : neg
    str = int2str(i);
    filename = [ path 'neg-' num2str(i,'%02d') '.pgm'];
    img = double(imread(filename));    
    [irow icol] = size(img);
    
%         temp = reshape(img',irow*icol,1);   % Reshaping 2D images into 1D image vectors
%        temp=HOGmatlab(img);
       temp=img*T;temp=temp(:);
    
    NF = [NF temp]; % 'T' grows after each turn                    
end


%%

case 3
% T=[];
% T=Transformingmatrix2DPCA(pos,neg,path);
                        
    for i = 11 : pos
    str = int2str(i);
    filename = [ path 'pos-' num2str(i,'%02d') '.pgm'];
    img = (imread(filename));    
    [irow icol] = size(img);
    
%             temp = reshape(img',irow*icol,1);   % Reshaping 2D images into 1D image vectors
      temp=HOGmatlab(img);
%        temp=img*T;temp=temp(:);        
    
    F = [F temp]; % 'T' grows after each turn                    
end

for i = 11 : neg
    str = int2str(i);
    filename = [ path 'neg-' num2str(i,'%02d') '.pgm'];
    img = (imread(filename));    
    [irow icol] = size(img);
    
%         temp = reshape(img',irow*icol,1);   % Reshaping 2D images into 1D image vectors
       temp=HOGmatlab(img);
%        temp=img*T;temp=temp(:);
    
    NF = [NF temp]; % 'T' grows after each turn                    
end
%%
    case 4         % SIFT
        k=2;
        for i = 11 : pos
    str = int2str(i);
    filename = [ path 'pos-' num2str(i,'%02d') '.pgm'];
    img = double(imread(filename));    
%     [irow icol] = size(img);
%     [frames,descriptors,scalespace,difofg]=siftfeatures(double(img));
    temp=getSIFTfeatures( img );
    t=temp(1:128*k);
    F = [F t']; % 'T' grows after each turn                    
end

for i = 11 : neg
    str = int2str(i);
    filename = [ path 'neg-' num2str(i,'%02d') '.pgm'];
    img = double(imread(filename));    
%     [irow icol] = size(img);
  
    temp=getSIFTfeatures( img );
%     size(temp)
    
    if size(temp,1)==0
%         display('hello maadam');
        t=NF(:,1)';
    end
    if size(temp,1)>0
        t=temp(1:128*k);
    end
        
    NF = [NF t']; % 'T' grows after each turn                    
end

 display('SIFT features extracrted');

%%

    case 5 % Discete wavelet transform
        
  
for i = 11 : pos
    str = int2str(i);
    filename = [ path 'pos-' num2str(i,'%02d') '.pgm'];
    img = double(imread(filename));    
    I= wavelettransform( img);  
    temp=I(:);               
    
    F = [F temp]; % 'T' grows after each turn                    
end

for i = 11 : neg
    str = int2str(i);
    filename = [ path 'neg-' num2str(i,'%02d') '.pgm'];
    img = double(imread(filename));    
    I= wavelettransform( img);  
    temp=I(:); 
    
    NF = [NF temp]; % 'T' grows after each turn                    
end
%%     

    case 6 
        
        cd 'E:\SVM or Random Forest\IMAGE_CLASSIFICATION\OBJECT DETECTION\CAR DETECTION';
        car_detection
        
        
   
%%
otherwise
            display('wrong choice');
            getback=input('Press any KEY to go back to main MENU');
            main();
end


end

