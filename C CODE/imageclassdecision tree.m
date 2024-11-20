%% program for single image classification using decision tree
%%
% % Decision Tree implementation

FinalDecision

%% settings
Depth=9; % maximal depth of decision tree
Splits=100; % number of candidate thresholds at each node
MinNode=10; % minimal size of a non-leaf node

%% training
% load TrainingData.mat;
load('ftrain.mat');

tic;
T=create01Tree(X,Y,Depth,Splits,MinNode);
t1=toc;

clear X Y;

%% testing
% load TestingData.mat;
load ftest.mat;
tic;
y=[];
for i=1:size(X,1)
    x=X(i,:);
    y(i,1)=decide01Tree(x,T);
end
t2=toc;

% % % % % % % % % % % % % % % % % % % % % % % % % % %

img = imread('69.png');
[irow icol] = size(img);   
xtemp=reshape(img',irow*icol,1);

y=decide01Tree(xtemp,T)

%% evaluation
% errorRate=sum(abs(y-Y))/max(size(Y));
% fprintf('Error rate = %.4f\n',errorRate);
fprintf('Training time = %.4f seconds\n',t1);
fprintf('Testing time = %.4f seconds\n',t2);
