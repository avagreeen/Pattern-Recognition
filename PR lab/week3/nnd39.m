a=gendats([5 5],1,8);
gx=[-3:0.2:11]';
D=sqrt(distm(gx,a));
sort(+D,1); %do sort on colum
sort(+D,2); % do sort on row
phat=4./(10*2*D(:,1));

scatterd(+a);hold on;plot(gx,phat);
axis([-3 11 0 5]);
saveas(gcf,'figknn','m');
