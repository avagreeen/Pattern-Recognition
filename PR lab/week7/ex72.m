clear all;
load('mfeat_kar.mat');
a1=prdataset(a);
load('mfeat_zer.mat');
a2=prdataset(a);
load('mfeat_mor.mat');
a3=prdataset(a);

[b1,c1,I,J]=gendat(a1,0.3); %I J are the indices of the objects selected from a1 for b1 and c1
b2=a2(I,:); c2=a2(J,:);
b3=a3(I,:); c3=a3(J,:);

[br1,cr1,Ir,Jr]=gendat(a1,0.3);
[br2,cr2,Ir,Jr]=gendat(a2,0.3);
[br3,cr3,Ir,Jr]=gendat(a3,0.3);

w1=nmc(b1)*classc; 
w2=nmc(b2)*classc;
w3=nmc(b3)*classc;

er1=c1*w1*testc;
er2=c2*w2*testc;
er3=c3*w3*testc;

b=[b1 b2 b3];
c=[c1 c2 c3];

wwhole=nmc(b)*classc;


erwhole=c*wwhole*testc;

v=[w1; w2 ; w3]*meanc;

ercomb=[c1 c2 c3]*v*testc;

wr1=nmc(br1)*classc;
err1=cr1*wr1*testc;

wr2=nmc(br2)*classc;
err2=cr2*wr2*testc;

wr3=nmc(br3)*classc;
err3=cr3*wr3*testc;

