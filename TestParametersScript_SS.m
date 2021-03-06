% Execute ISS embed and extract process

%% Set path of images

    Output_Dir = 'Output/';

    if exist(Output_Dir, 'dir') ~= 7
        mkdir(Output_Dir);
    end
    
    InputImage_Name = 'airplane.bmp';

    InputImage_Dir = '';
    InputImage_Path = [InputImage_Dir InputImage_Name];
    
    tmp = strsplit(InputImage_Name, '.');
    filetype = tmp(end); filetype = filetype{1};
    filename = InputImage_Name(1:(length(InputImage_Name) - length(filetype) - 1));
	
    
	WMImage_Dir = Output_Dir;
    WMImage_Name = [filename '_watermarked.' filetype];
    WMImage_Path = [WMImage_Dir WMImage_Name];
	
	AttackedImage_Dir = Output_Dir;
	

%% ISSembed process	
	% Preprocessing - read original image
    orgImg = imread(InputImage_Path);
    subplot(1, 2, 1);
    imshow(orgImg);
    title('Original Image');

    
	
	% Prepoorcessing - generate watermark (n*1 +-1 vector)
    % n: watermark length, b: watermark
    n = 4096;
    b = sign(randn(n, 1));
	

	% Watermark embedding settings - set alpha, lambda, blockSize, pattern
    % m: pattern length & x length
    alpha = 0.5;
    lambda = 1.00;
    blockSize = 8;
    %Modified
    m = 64;
    total_u = sign(randn(m, 1));
    %
    
    % Print parameters
    fprintf('Parameters:\n');
    fprintf('\tWatermark length = %d\n', n);
    fprintf('\tPattern length = %d\n', m);
    fprintf('\tBlock size = %d\n', blockSize);
    fprintf('\tAlpha = %.2f\n', alpha);
    fprintf('\tLambda = %.2f\n', lambda);
	
    %Modified
    lowerbound = 1;
    upperbound = 64;
    offset = 1;
    %
    
    num_test = (upperbound - lowerbound) / offset + 1;
    %Modified
    array_patternLen = zeros(1, num_test);
    %
    array_capacity = zeros(1, num_test);
    array_psnr = zeros(1, num_test);
    array_ber = zeros(1, num_test);
    
    %Modified
    fprintf('Testing patternLen from %f to %f by %f:\n', lowerbound, upperbound, offset);
    %
    
    i = 1;
    %Modified
    for patternLen_i = lowerbound: offset : upperbound
        
        fprintf('patternLen_i = %f\n', patternLen_i);
        
        u = total_u(1:patternLen_i);

        % Improved Spread Spectrum Embed
        watermarkedImg = SpreadSpectrumEmbed(orgImg, b, u, alpha, blockSize);
        %

        %subplot(1, 2, 2);
        %imshow(watermarkedImg, [0 255]);
        %title('Watermarked Image');

        % Save watermarked image
        %imwrite(watermarkedImg, WMImage_Path);
        
        
        
    %% ISSextract process
        % Watermark extraction settings - set pattern, blkSize, wmSize
        %Modified
        watermark0 = SpreadSpectrumExtract(watermarkedImg, u, blockSize, n);
        %


    %% Measurement

        %fprintf('Measurements:\n');

        % Measuring capacity
        capacity = n;
        fprintf('\tCapacity : %d\n', capacity);


        % Measuring fidelity
        PSNR = psnr(watermarkedImg, orgImg);
        fprintf('\tFidelity : PSNR = %f\n', PSNR);

        % Measuring robustness
        numDiff = sum((b == watermark0) == 0);
        BER = numDiff / n;
        fprintf('\tRobustness : BER = %.2f\n', BER);
        
        %Modified
        array_patternLen(i) = patternLen_i;
        %
        array_capacity(i) = capacity;
        array_psnr(i) = PSNR;
        array_ber(i) = BER;
        
        
        i = i + 1;
    end
    
    %Modified
    parameterFolder = 'PatternLength_Test/SS/';
    %

    if exist(parameterFolder, 'dir') ~= 7
        mkdir(parameterFolder);
    end
    
    %Modified
    subname = '_1_to_64_by_1';
    %
    
    fileID = fopen([parameterFolder 'data' subname '.txt'], 'w');
    %Modified
    fprintf(fileID, 'Testing PatternLength from %f to %f by %f:\n', lowerbound, upperbound, offset);
    %
    
    fprintf(fileID, 'Parameters:\n');
    fprintf(fileID, '\tWatermark length = %d\n', n);
    fprintf(fileID, '\tPattern length = %d\n', m);
    fprintf(fileID, '\tBlock size = %d\n', blockSize);
    fprintf(fileID, '\tAlpha = %.2f\n', alpha);
    fprintf(fileID, '\tLambda = %.2f\n', lambda);
    
    %Modified
    fprintf(fileID, 'patternLen\n\t');
    fprintf(fileID, '%10f ', array_patternLen);
    %
    fprintf(fileID, '\ncapacity\n\t');
    fprintf(fileID, '%10f ', array_capacity);
    fprintf(fileID, '\npsnr\n\t');
    fprintf(fileID, '%10f ', array_psnr);
    fprintf(fileID, '\nber\n\t');
    fprintf(fileID, '%10f ', array_ber);
    
    %Modified
    save([parameterFolder 'patternLength' subname '.mat'], 'array_patternLen');
    %
    save([parameterFolder 'capacity' subname '.mat'], 'array_capacity');
    save([parameterFolder 'psnr' subname '.mat'], 'array_psnr');
    save([parameterFolder 'ber' subname '.mat'], 'array_ber');