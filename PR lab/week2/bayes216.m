a=rand(10,2);
b=randn(10,2);
T=[2 1; 3 4];
bt=b*T;
at=a*T;
data=[a;b];
datat=[at;bt];
lable_a=repmat(['a'],10,1);
lable_b=repmat(['b'],10,1);
lable=[lable_a;lable_b];
dataset=prdataset(data,lable);
datasett=prdataset(datat,lable);

axis([-3 4 -3 5]);
figure(1); scatterd(dataset);%plotm(qdc(dataset));
plotc(qdc(dataset));

axis([-3 4 -3 5]);
figure(2); scatterd(datasett);%plotm(qdc(dataset));
plotc(qdc(datasett));