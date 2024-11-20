function [  ] = svmclassification()

    t1sum=0;t2sum=0;svmacc=0;
    k=load('ftraincar.mat');
    XX=k.X;YY=k.Y;


%%    CROSS VALIDATION....................

iter=3;
cvcount=1;
svmaccuracy=zeros(iter,1);
mysvmaccuracy=zeros(iter,1);

while (cvcount<=iter)
     
    u=randperm(size(YY,1));
    X=XX(u,:);Y=YY(u);
    tic;
    SVMSTRUCT = svmtrain(X, Y);
    
    
%%   mysvm ......
%%
% display('hi');
% [r c]=size(X);
% cc=c;
% X=X(1:r,1:cc);
% % Tolerance limit
% C = 0.2;
% for i = 1 : r
%     for j = 1: r
%         Q(i,j) = Y(i)*Y(j)*X(i,:)*X(j,:)';
%     end
% end
% % % p=30 ;
% % % for i = 1 : r %% gaussian.kernel
% % %     for j = 1: r
% % %         Q(i,j) = Y(i)*Y(j)*exp(-((X(i,:) - X(j,:))*(X(i,:) - X(j,:))')/2*p^2);
% % %     end
% % % end
% 
% Q  = Q + 0.1*eye(r);
% f = -ones(1,r);
% beq = 0;
% Aeq = Y';
% lb  = zeros(1,r);
% ub  = C*ones(1,r);
% [alpha val flag] = quadprog(Q,f,[],[],Aeq,beq,lb,ub);
% 
% epsilon = C*1e-6; % -6
% 
% %Compute Support vectors
% sv = alpha(find(alpha > epsilon));
% 
% %copmute hyperplane parameters
% w = zeros(1,cc);
% for i = 1 : r
%     w = w + alpha(i)*Y(i)*X(i,:);
% end
% 
% %compute bias b
% z = 0;
% for i = 1 : r
%     e = w*X(i,:)';
%     z = z + alpha(i)*Y(i)*e;
% end
% b = (sum(alpha) - z)/(alpha'*Y);
% 
% 
% % fy=w*X(3,:)'+b;
% fyy=w*X';
% fy=fyy;
% 
% for l=1:size(fy,2)
%     if fy(l)>0
%         fy(l)=1;
%     else fy(l)<=0
%         fy(l)=-1;
%     end
% end
%         


%%
t1=toc;
t1sum=t1sum+t1;
clear X Y;
%%
m=load('ftestcar.mat');
Xt=m.X;Yt=m.Y;
tic
Group = svmclassify(SVMSTRUCT,Xt,'Showplot',true);

% now we can compare with the .........Y outputs ...nd calculate the
% accuracy
c=0;cfy=0;
[s v]=size(Group);
for svm=1:s
    if Group(svm)== Yt(svm)
        c=c+1;
    end
%     if fy(svm)== Yt(svm)
%         cfy=cfy+1;
%     end
    
end
t2=toc;
t2sum=t2sum+t2;
svmaccuracy(cvcount)=(c/s);
svmacc=svmacc+svmaccuracy(cvcount);
% mysvmaccuracy(cvcount)= (cfy/s);

% fprintf('Accuracy with SVM= %.4f\n',svmaccuracy(cvcount));



%%
    cvcount=cvcount+1;
    clear Q;
    
end


fprintf('Average Accuracy with SVM= %.4f\n',mean(svmaccuracy));
fprintf('Training time = %.4f seconds\n',t1sum/cvcount);
fprintf('Testing time = %.4f seconds\n',t2sum/cvcount);
display('For holdout data');

% mean(mysvmaccuracy)


end

