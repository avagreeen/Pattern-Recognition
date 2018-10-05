% prepend the current directory if needed
function file = prependpwd(file)
    [p,~,~] = fileparts(file);
    if isempty(p) || ~isfullpath(p)
        file = fullfile(pwd,file);
    end
end