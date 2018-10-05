clear all;
a=gendath([50 50]);

w1=nmc(a);
w2=ldc(a);

p1=a*w1*classc;
p2=a*w2*classc;

p=[p1 p2];

%w3=a*p*nmc;
scatterd(p(:,[1 3]));
figure(2)
scatterd(p1);
figure(3)
scatterd(p2);

figure(4);

scatterd(a);
plotc(w1,'b');
plotc(w2);
plotc(w3);
