clear all;
trn=gendatb(100,10);

tst=gendatb(100,10);
scatterd(tst);
for i=1:6
    %prwaitbar off;
    nnmap=bpxnc(trn,2.^10,1000)
    enn=testc(tst*nnmap)
    hold on;
    plotc(nnmap);
    hold on;
end
