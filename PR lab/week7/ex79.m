clear all;

a=gendatb([50 50]);

b=gendatb([50 50]);

[W V ALF]=adaboostc(a,stumpc,100,[],0);
C=adaboostc(a,stumpc,100,[],0);

%scatterd(a);
%plotc(C);

error_rate=testc(b*C);