clear all;
a=gendatb([20 20]);
b=gendatb([30 30]);
kernal=proxm('r',2);
%D=a*W;
[w,j]=a*svc(kernal);
error=b*w*testc
scatterd(b);
plotc(w);
hold on;
scatterd(a(j,:),'o');