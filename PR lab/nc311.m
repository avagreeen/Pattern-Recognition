n=100;
for i = 1:10
a = gauss(n,0);
h(i,:) = hist(+a,-5:5);
end;
errorbar (-5:5, mean(h), std(h));
