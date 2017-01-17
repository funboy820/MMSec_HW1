function encodeScript(InputImage_Name, wmLen, patternLen, blockSize, alpha, lambda)

% Execute ISS embed and extract process

%% Set path of images

    Output_Dir = 'Alpha_Test/';

    if exist(Output_Dir, 'dir') ~= 7
        mkdir(Output_Dir);
    end


    InputImage_Dir = '';
    InputImage_Path = [InputImage_Dir InputImage_Name];
    
    tmp = strsplit(InputImage_Name, '.');
    filetype = tmp(end); filetype = filetype{1};
    filename = InputImage_Name(1:(length(InputImage_Name) - length(filetype) - 1));
	
    
	WMImage_Dir = Output_Dir;
    WMImage_Name = [filename '_watermarked2.' filetype];
    WMImage_Path = [WMImage_Dir WMImage_Name];

%% ISSembed process	
	% Preprocessing - read original image
    orgImg = imread(InputImage_Path);
    subplot(1, 2, 1);
    imshow(orgImg);
    title('Original Image');

    
	
	% Prepoorcessing - generate watermark (n*1 +-1 vector)
    % n: watermark length, b: watermark
    n = wmLen;
    b = sign(randn(n, 1));
	

	% Watermark embedding settings - set alpha, lambda, blockSize, pattern
    % m: pattern length & x length
    m = patternLen;
    u = sign(randn(m, 1));
    
    % Print parameters
    fprintf('Parameters:\n');
    fprintf('\tWatermark length = %d\n', n);
    fprintf('\tPattern length = %d\n', m);
    fprintf('\tBlock size = %d\n', blockSize);
    fprintf('\tAlpha = %.2f\n', alpha);
    fprintf('\tLambda = %.2f\n', lambda);
	

	% Improved Spread Spectrum Embed
    watermarkedImg = ImprovedSpreadSpectrumEmbed(orgImg, b, u, alpha, lambda, blockSize);
    
    subplot(1, 2, 2);
    imshow(watermarkedImg, [0 255]);
    title('Watermarked Image');

	% Save watermarked image
    imwrite(watermarkedImg, WMImage_Path);
end