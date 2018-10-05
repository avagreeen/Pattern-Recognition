function [a] = load_data

a = prnist([0:9],[1:40:1000]);
struct(a)
fprintf('Image file loaded \n');
end