clear all;
trn=gendats(50,30);
tst=gendats(1000,30);
scatterd(trn);
r=loglc(trn);
plotm(r);