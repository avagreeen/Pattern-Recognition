a=gendats([20 20],1,8);
h=0.8;
w=parzenm(+a,h);
scatterd(+a);plotm(w,1);
gridsize(100);
