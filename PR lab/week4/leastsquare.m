clear all;
x=gendats([20,20],2,6);
scatterd(x);
x=[x,ones(40,1)];
y=genlab([20 20],[1;-1]);
w=inv(x'*x)*x'*y;

xl=-5:10;
yl=-(w(3)+xl*w(1))/w(2);
hold on;
plot(xl,yl);