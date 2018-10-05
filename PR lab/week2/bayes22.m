a=sqrt(1)*randn(100,2);
b=sqrt(1)*randn(100,2);
b=[b(:,1)+1,b(:,2)+2];
data=[a;b];
lable_a=repmat(['1'],100,1);
lable_b=repmat(['0'],100,1);
lable=[lable_a;lable_b];
dataset=prdataset(data,lable);
datap=prdataset(data);
axis([-3 4 -3 5]);
%figure(1); plotm(ldc(dataset));
axis([-3 4 -3 5]);
figure(1); scatterd(dataset);%plotm(qdc(dataset));
plotc(qdc(dataset))