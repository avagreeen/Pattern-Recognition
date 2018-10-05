% test for full path name
function isfull = isfullpath(p)
    if ispc
        p(p=='/') = '\';
        isfull = strncmp(p,'\\',2) || (length(p)>2 && strcmp(p(2:3),':\'));
    else
        isfull = p(1) == filesep;
    end
end