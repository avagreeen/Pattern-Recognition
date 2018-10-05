for i = 1:8
    a = prdataset(randn(100,2));
    scatterd([-3 -3;3 3],'.w') % trick to set the figure axes about right
    plotm(gaussm(a))
    hold on
    pause
end
hold off
