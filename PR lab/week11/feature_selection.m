clear all;

a=gendatd(100,10);  % 100 samples, 10 features

%[w1,r1]=featself(a,'maha-s',2);
%[w2,r2]=featselb(a,'maha-s',2);
[w3,r3]=featsellr(a,'maha-s',2);
%[w4,r4]=featselp(a,'maha-s',2);

tst=gendatd(100,10);


%e1=clevalf(a,fisehr,2,[],[],tst)
e1=clevalf(a*w3,fisherc,2,[],1,tst*w3)
via 谷歌翻译
%e3=tst*w3*testc;
%%

a=diabetes;
[tst trn]=gendat(a,0.5);


