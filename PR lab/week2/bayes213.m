a=rand(10,2);
b=randn(10,2);
%b=[b(:,1)+1,b(:,2)+2];
data=[a;b];
lable_a=repmat(['a'],10,1);
lable_b=repmat(['b'],10,1);
lable=[lable_a;lable_b];
dataset=prdataset(data,lable);

cla=ldc(dataset);
axis([-3 4 -3 5]);
%figure(1); plotm(ldc(dataset));
figure(1); scatterd(dataset);%plotm(qdc(dataset));
plotc(cla);
%w=gaussm(dataset);
dataset*cla*labeld;