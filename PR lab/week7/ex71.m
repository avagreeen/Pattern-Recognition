clear all;
A=gendats([10 10]);
tst=gendats([50 50]);

TR=treec(A,'infcrit',12);
figure(1);
gridsize(1000);
scatterd(A);
plotc(TR);
er=tst*TR*testc


%TRR=treec(A,'infcrit',3)
%figure(2);
%scatterd(A);
%plotc(TRR);

