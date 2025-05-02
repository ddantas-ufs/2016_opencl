out = imread('./in/mitosis-5d0000.tif');
for i = 1:335
    filename = sprintf('./in/mitosis-5d%04d.tif', i);
    fprintf('%s\n', filename);
    in = imread(filename);
    out = cat(3, out, in);
end