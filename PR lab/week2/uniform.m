a=rand(1000,2);
a=prdataset(a);
figure(1);scatterd(a);
w=gaussm(a);
figure(2);plotm(w);
am=[a(:,1)*3,a(:,2)];
figure(3);scatterd(am);
A=[cos(pi/3) -sin(pi/3) ;sin(pi/3) cos(pi/3)];
ar=am*A; %rotate clockwise for 30 degree
figure(4);scatterd(ar);