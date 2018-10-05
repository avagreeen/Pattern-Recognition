clear all;
a=gendats([20,20],2,6);
scatterd(a);

lab=genlab([20 20],[1;-1]);
x=[a,ones(40,1)];
%w=[sum(a(:,2))/40,sum(a(:,1))/40,1];
l0=mean(a(:,1));y0=mean(a(:,2));
w=[rand(1,2),-1.5];
p=0.2;

for i=1:40
    if (lab(i)*w'*+x(i,:)>=0)
        w=w-p*lab(i)*+x(i,:);

    end
 l=-5:10;
        y=-(w(3)+l*w(1))/w(2);
      hold on;
        plot(l,y);
end
