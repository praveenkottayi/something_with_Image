function [] = savematformat(F,NF)

% cross vadlidation
% test and train from train set

DB=F;
DB=[DB NF];
ftrue=[];ftrue=ones(1,size(F,2));
ffalse=[];

% ffalse=zeros(1,size(NF,2));

ffalse=-ones(1,size(NF,2));

DBans=[ftrue ffalse];
o=size(DBans,2);
ind=randperm(o);
s = struct('X',{DB'},'Y',{DBans'},'index',{ind}); % till cross validation
Trz=floor(0.7*o);
% 
ftrain=struct();
ftest=struct();
c=0;d=0;


for u=1:o
    if s.index(u) < Trz
        c=c+1;
        ftrain.X(c,:)=double(s.X(u,:));
        ftrain.Y(c,:)=double(s.Y(u,:));
    else
         d=d+1;
         ftest.X(d,:)=double(s.X(u,:));
         ftest.Y(d,:)=double(s.Y(u,:));           
    end
end

% % % % % put it in mat...thts itt!!!!!!

% % save('newstruct.mat', '-struct', 'S')
        
save('ftraincar.mat', '-struct','ftrain' );
save('ftestcar.mat','-struct', 'ftest' );

% k=load ('ftrain.mat');
display(' Have a Great Day.... ;)');

end

