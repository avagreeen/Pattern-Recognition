clear all;
trn=gendatb(1000,2);
tst=gendatb(2000,2);
scatterd(tst);
tun=gendatb(500,2);
for i=1:6
    tic
    %prwaitbar off;
    
    nnmap=bpxnc(trn,[3;8],1000, [],tun);
    toc
    enn=testc(tst*nnmap)
    hold on;
    plotc(nnmap);
    hold on;
end