clear all;
trn=gendatb(1000,2);
scatterd(trn);
tst=gendatd(1000,2);
for i=1:6
    %prwaitbar off;
    nnmap=bpxnc(trn,30,1000)
    enn=testc(tst*nnmap)
    hold on;
    plotc(nnmap);
    hold on;
end
