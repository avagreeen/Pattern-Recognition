clear all;
A=gendats([50 50]);
tst=gendats([50 50]);
TR=treec(A,'infcrit',0);
figure(1);
gridsize(1000);
scatterd(A);
plotc(TR);

TRB=baggingc(A,treec([],'infcrit',0));
figure(2);
scatterd(A);
plotc(TRB);

er=tst*TR*testc;
erb=tst*TRB*testc;