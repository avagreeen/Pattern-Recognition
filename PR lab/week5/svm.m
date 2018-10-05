clear all;
x=[0 -1;0 3; 2 0];
lab=[1 1 -1];

trsvm=train_SVM(lab',x);
scatterd(x);

xl=-1:3;
yl=-(trsvm.b+xl*trsvm.w(1))/trsvm.w(2);
hold on;
plot(xl,yl);