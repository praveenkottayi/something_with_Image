function [  ] = mysvmchunk()

MAXCOUNT = 1;      % for number of cross validation
for i = 1:MAXCOUNT

iter=5; count=1;CC=[];YY=[];c=10;
C=TRNX; Y=TRNY;crr=0;chunk=30;
zz=zeros(chunk,iter);

while(count<=iter )


u=randperm(size(C,1));
C=C(u,:);Y=Y(u);

U=C(1:chunk,:);  % chunk
K=length(C);
d=length(U);

for i=1:d
    for j=1:d
        Q(i,j) = Y(i) * Y(j) * U(i,:)*U(j,:)';
    end
end

f=-1*ones(1,length(U));
 Q=Q+(10^-5*eye(d));
Aeq=Y(1:d)';
Beq=0;
lb=zeros(1,d);
ub=c*ones(1,d);

L=quadprog(Q,f,[],[],Aeq,Beq,lb,ub);    %% quad program for fining alphas

%calculation of W's
w=zeros(1,9);
for i=1:d
    w=w+L(i)*Y(i)*U(i,:);
end
yy=w*C(d:K,:)';

%%      counting the number of data points not satisfying KKT conditions 
%%
b=0;
for i=1:K-d
%     if((Y(d+i)*sign(yy(i))>=1))
    if((Y(d+i)*(yy(i))>=1))
        b=b+1;
    else
        s(i+d)=i;
    end
end
h=find(s);
     
ss=d;i=1;
while(ss>0)
     if(L(i)>0&&L(i)<=c)
        z(i)=L(i);
        zz(count,i)=L(i);
     end
        i=i+1;
        ss=ss-1;
end
        
        
sv=find(z);supportvector=sv;
n=length(sv);
m=length(h);
p=length(L)-length(sv);

for i=1:n
    workingset(i)=sv(i);
end
for i=1:m
    workingset(i+n)=h(i);
end

t=workingset;
crr=crr+b;

C=C(workingset,:);Y=Y(workingset);
clear workingset s sv 
%%
count=count+1;
end

%%                         Testing with TEST DATA..
%%
%%                       support vector count
spvc=1; 
for i=1:chunk
    for j=1:count-1
        
        if(zz(i,j)>0)
        spv(spvc)=zz(i,j);
        spvc=spvc+1;        
        end
    end    
end



S=size(spv,1);
L1=spv;                          %% final alphas
w=zeros(1,9);
for i=1:S
    w=w+L1(i)*Y(i)*U(i,:);
end
 yy=w*TESTX';
ccp=0;
lyy=length(yy);

 for i=1:lyy
     if((TESTY(i)*sign(yy(i))==1))
         ccp=ccp+1;                    %% correctly classified points
     end
 end
 
  
%%                                accuracy ............!!!     
%%
acc=ccp/lyy;                          %% accuracy for single iteration
% display(acc);
sum = sum + acc;                      %% cummulative accuracy
% acc1=cc/lyy
end

Total_accuracy = sum/MAXCOUNT;
display(Total_accuracy);             %% final display of accuracy

%%                                  THE END
%%





end

