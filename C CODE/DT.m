function [] = DT( )

% % Decision Tree implementation
display('namaste');
% FinalDecision


%% settings

%%
% Depth=20; % maximal depth of decision tree 5
% Splits=140; % number of candidate thresholds at each node 100
% MinNode=17; % minimal size of a non-leaf node 10
%%
Depth=5; % maximal depth of decision tree 5
Splits=50; % number of candidate thresholds at each node 100
MinNode=5;



%% training
load('ftraincar.mat');
tic;
T=create01Tree(X,Y,Depth,Splits,MinNode);
t1=toc;
clear X Y;

%% testing
load ftestcar.mat ;
tic;
y=[];

for i=1:size(X,1)
    x=X(i,:);
    y(i,1)=decide01Tree(x,T);
end
t2=toc;

% % % % % % % % % % % % % % % % % % % % % % % % % % %

%% evaluation
acc=sum(abs(y-Y))/max(size(Y));
fprintf('Accuracy with Decision tree= %.4f\n',acc);
fprintf('Training time = %.4f seconds\n',t1);
fprintf('Testing time = %.4f seconds\n',t2);
end

