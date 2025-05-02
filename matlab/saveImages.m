for i = 1:336
    outfilename = sprintf('./out/out%04d.tif', i-1);
    fprintf('%s\n', outfilename);
    save = out(:,:,i);
    imwrite(save, outfilename);
end