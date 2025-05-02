fprintf('\nloading...');
for i = 0:335
    filename = sprintf('../dataset/mitosis-5d%04d.tif', i);
    if (i == 0)
      tmp = imread(filename);
    else
      %fprintf('%s\n', filename);
      in = imread(filename);
      tmp = cat(3, tmp, in);
    end
end
fprintf('\nloading complete\n');

for dim = 2:2
    n = dim;
    if n == 1
        tmp_nd = reshape(tmp, [1 22020096]);      %1d
    end
    if n == 2
        tmp_nd = reshape(tmp, [256 86016]);       %2d
    end
    if n == 3
        tmp_nd = reshape(tmp, [256 256 1 336]);     %3d
    end
    if n == 4
        tmp_nd = reshape(tmp, [256 256 2 168]);   %4d
    end
    if n == 5
        tmp_nd = reshape(tmp, [256 256 2 24 7]);   %5d
    end
    nsteps = 10;
    
    tmp_gpu = gpuArray(single(tmp_nd));

    fprintf('\nmean');
    strel_mean = create_3xcube_mean_es_el(2);
    gd = gpuDevice();
    tic;
    for i = 1:nsteps
        result_mean = convn(tmp_gpu, strel_mean, 'same');
    end
    wait(gd);
    time_mean = toc;
    tmp_mean = reshape(gather(result_mean), [256 256 336]);
    fprintf('\nmean complete\n');

    tmp_gpu = gpuArray(uint8(tmp_nd));
    
    fprintf('\nerode(hypercube)')
    strel_hypercube = create_3xcube_es_el(n);
    gd = gpuDevice();
    tic;
    for i = 1:nsteps
        result_erode_hypercube = imerode(tmp_gpu, strel_hypercube);
    end
    wait(gd);
    time_erode_hypercube = toc;
    tmp_erode_hypercube = reshape(gather(result_erode_hypercube), [256 256 336]);
    fprintf('\nerode(hypercube) complete\n');
    
    fprintf('\nerode(cross)')
    strel_cross = create_3xcross_es_el(n);
    gd = gpuDevice();
    tic;
    for i = 1:nsteps
        result_erode_cross = imerode(tmp_gpu, strel_cross);
    end
    wait(gd);
    time_erode_cross = toc;
    tmp_erode_cross = reshape(gather(result_erode_cross), [256 256 336]);
    fprintf('\nerode(cross) complete\n');

    fprintf('\nsep dilate')
    strel_sep = cell(1,5);
    for i = 1:dim
        strel_dim = ones(1,dim);
        strel_dim(i) = 3;
        strel_sep{i} = ones(strel_dim);
    end
    
    tic;
    for i = 1:nsteps   
       foo = imdilate(input_nd, strel_sep{1});
       for j = 2:dim
           if (mod(j,2) == 0)
               tmp_dilate_sep = imdilate(foo, strel_sep{j});
           else
               foo = imdilate(tmp_dilate_sep, strel_sep{j});
           end
       end
    end
    time_dilate_sep = toc;
    if (mod(dim,2) == 1)
        tmp_dilate_sep = foo;
    end
    tmp_dilate_sep_ = reshape(tmp_dilate_sep, [256 256 336]);
    fprintf('\nsep dilate complete')
    
    fprintf('\ndilate(hypercube)')
    gd = gpuDevice();
    tic;
    for i = 1:nsteps
        result_dilate_hypercube = imdilate(tmp_gpu, strel_hypercube);
    end
    wait(gd);
    time_dilate_hypercube = toc;
    tmp_dilate_hypercube = reshape(gather(result_dilate_hypercube), [256 256 336]);
    fprintf('\ndilate(hypercube) complete\n');
    
    fprintf('\ndilate(cross)')
    gd = gpuDevice();
    tic;
    for i = 1:nsteps
        result_dilate_cross = imdilate(tmp_gpu, strel_cross);
    end
    wait(gd);
    time_dilate_cross = toc;
    tmp_dilate_cross = reshape(gather(result_dilate_cross), [256 256 336]);
    fprintf('\ndilate(cross) complete\n');
    
    fprintf('\nnegative');
    gd = gpuDevice();
    tic;
    for i = 1:nsteps
        result_negative = imcomplement(tmp_gpu);
    end
    wait(gd);
    time_negative = toc;
    tmp_negative = reshape(gather(result_negative), [256 256 336]);
    fprintf('\nnegative complete\n');
    
    fprintf('\ngraythresh');
    gd = gpuDevice();
    level = 128;
    tic;
    for i = 1:nsteps
        result_graythresh = (tmp_gpu >= level);
    end
    wait(gd);
    time_graythresh = toc;
    tmp_graythresh = im2uint8(result_graythresh);
    tmp_graythresh = reshape(gather(tmp_graythresh), [256 256 336]);
    fprintf('\ngraythresh complete\n');
    
    fprintf('\ncopy');
    gd = gpuDevice();
    tic;
    for i = 1:nsteps
        result_copy = tmp_gpu;
    end
    wait(gd);
    time_copy = toc;
    tmp_copy = reshape(gather(result_copy), [256 256 336]);
    fprintf('\ncopy complete\n');
    
    filename_time_gpu = sprintf('./out_gpu/operations_time_%dd.txt', n);
    file_time_gpu = fopen(filename_time_gpu, 'w');
    fprintf(file_time_gpu, 'Times of execution in GPU:\n');
    fprintf(file_time_gpu, '\ncopy                  = %f', time_copy);
    fprintf(file_time_gpu, '\nmean                  = %f', time_mean);
    fprintf(file_time_gpu, '\ndilate(sep)           = %f', time_dilate_sep);
    fprintf(file_time_gpu, '\ndilate(cross)         = %f', time_dilate_cross);
    fprintf(file_time_gpu, '\ndilate(hypercube)     = %f', time_dilate_hypercube);
    fprintf(file_time_gpu, '\ngraythresh            = %f', time_graythresh);
    fprintf(file_time_gpu, '\nnegative              = %f', time_negative);
    fclose(file_time_gpu);
end

fprintf('\nsaving...');
for i = 1:336
    outfilename = sprintf('./out_gpu/out_mean/out%04d.tif', i-1);
    out = tmp_mean(:,:,i);
    imwrite(uint8(out), outfilename);
    %{
    outfilename = sprintf('./out_gpu/out_erode_hypercube/out%04d.tif', i-1);
    out = tmp_erode_hypercube(:,:,i);
    imwrite(uint8(out), outfilename);
    
    outfilename = sprintf('./out_gpu/out_erode_cross/out%04d.tif', i-1);
    out = tmp_erode_cross(:,:,i);
    imwrite(uint8(out), outfilename);
    %}
    outfilename = sprintf('./out_gpu/out_dilate_sep/out%04d.tif', i-1);
    out = tmp_dilate_sep(:,:,i);
    imwrite(uint8(out), outfilename);

    outfilename = sprintf('./out_gpu/out_dilate_hypercube/out%04d.tif', i-1);
    out = tmp_dilate_hypercube(:,:,i);
    imwrite(uint8(out), outfilename);
    
    outfilename = sprintf('./out_gpu/out_dilate_cross/out%04d.tif', i-1);
    out = tmp_dilate_cross(:,:,i);
    imwrite(uint8(out), outfilename);
    
    outfilename = sprintf('./out_gpu/out_negative/out%04d.tif', i-1);
    out = tmp_negative(:,:,i);
    imwrite(uint8(out), outfilename);
    
    outfilename = sprintf('./out_gpu/out_graythresh/out%04d.tif', i-1);
    out = tmp_graythresh(:,:,i);
    imwrite(uint8(out), outfilename);
    
    outfilename = sprintf('./out_gpu/out_copy/out%04d.tif', i-1);
    out = tmp_copy(:,:,i);
    imwrite(uint8(out), outfilename);
    
end
fprintf('\nsave complete\n');