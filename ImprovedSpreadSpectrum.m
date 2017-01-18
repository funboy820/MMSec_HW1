function ImprovedSpreadSpectrum(InputImage_Name, wmLen, patternLen, blockSize, alpha, lambda, specialMethod)

% Execute ISS embed and extract process

%% Set path of images

    Output_Dir = 'Output/';

    if exist(Output_Dir, 'dir') ~= 7
        mkdir(Output_Dir);
    end


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
    height = size(orgImg, 1);
    width = size(orgImg, 2);
    
    if specialMethod == 1
        % Error Correction Code Mode
        
        ECC_dataLen = 1;
        ECC_parityLen = 2;
        ECC_totalLen = ECC_dataLen + ECC_parityLen;
        
        numECCSet = ceil(wmLen / ECC_totalLen);
        wmLen = numECCSet * ECC_totalLen;
    end
	
	% Prepoorcessing - generate watermark (n*1 +-1 vector)
    % n: watermark length, b: watermark
    maxWatermarkLength = floor(height/blockSize) * floor(width/blockSize);
    if wmLen > maxWatermarkLength
        n = maxWatermarkLength;
        fprintf('Can not embed this much length of watermark whtis this block size and this image.\n');
        fprintf('Reduce the watermark length to the maximum number under current setting\n\n');
    else
        n = wmLen;
    end
    b = sign(randn(n, 1));
    save('watermark.mat', 'b');
    load('watermark.mat');
    
    
    if specialMethod == 1
        % Error Correction Code Mode
        n = floor(n/ECC_totalLen)*ECC_totalLen;
        numECCSet = n / ECC_totalLen;
        
        b = b(1:n);
        
        % Set parity bits
        
        %   Turn -1 to 0
        for i=1:n
            if b(i) == -1
                b(i) = 0;
            end
        end
        
        %   Start setting
        for i=1:numECCSet
            sHead = (i-1)*ECC_totalLen+1;
            sTail = i*ECC_totalLen;
            
            segment = b(sHead:sTail);
 
%             parityPos = [1 2 4 8];
            parityPos = [1 2];
            for j=1:length(parityPos)
                segment(parityPos(j)) = 0;
                segment(parityPos(j)) = ECC_GetEvenParity(segment, parityPos(j));
            end
            
            b(sHead:sTail) = segment;
        end
        
        
        %   Turn 0 to -1
        for i=1:n
            if b(i) == 0
                b(i) = -1;
            end
        end
        
%         save('watermark2.mat', 'b');
    end


	% Watermark embedding settings - set alpha, lambda, blockSize, pattern
    % m: pattern length & x length
    m = patternLen;
    u = sign(randn(m, 1));
    save('pattern.mat', 'u');
    load('pattern.mat');
    
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
	
	
%% Attack watermarked image
	% Read watermarked image
	% Attack
	% Save attacked image
	% hint: imread(), imwrite()
    watermarkedImg = imread(WMImage_Path);
    
    figure
    
    % 1. JPEG compression
    Attacked_Type1 = 'JPEG compression';
    AttackedImage_Name = [filename '_attacked.jpg'];
    AttackedImage_Path1 = [AttackedImage_Dir AttackedImage_Name];
    imwrite(watermarkedImg, AttackedImage_Path1, 'jpg');
    attackedImg = imread(AttackedImage_Path1);
    subplot(3, 3, 1);
    imshow(attackedImg);
    title('JPEG');

    % 2. Rotation
    Attacked_Type2 = 'Rotation';
    AttackedImage_Name = [filename '_attacked_rotation.' filetype];
    AttackedImage_Path2 = [AttackedImage_Dir AttackedImage_Name];
    attackedImg = imrotate(watermarkedImg, 0.5, 'nearest', 'crop');
    imwrite(attackedImg, AttackedImage_Path2);
    subplot(3, 3, 2);
    imshow(attackedImg);
    title('Rotation');
    
    % 3. Shift
    Attacked_Type3 = 'Shift';
    AttackedImage_Name = [filename '_attacked_shift.' filetype];
    AttackedImage_Path3 = [AttackedImage_Dir AttackedImage_Name];
    attackedImg = imtranslate(watermarkedImg, [1 0]);
    imwrite(attackedImg, AttackedImage_Path3);
    subplot(3, 3, 3);
    imshow(attackedImg);
    title('Shift');
    
    % 4. Scale
    Attacked_Type4 = 'Scale';
    AttackedImage_Name = [filename '_attacked_scale.' filetype];
    AttackedImage_Path4 = [AttackedImage_Dir AttackedImage_Name];
    attackedImg = imresize(watermarkedImg, 0.99);
    imwrite(attackedImg, AttackedImage_Path4);
    subplot(3, 3, 4);
    imshow(attackedImg);
    title('Scale');
    
    % 5. Crop
    Attacked_Type5 = 'Crop';
    AttackedImage_Name = [filename '_attacked_crop.' filetype];
    AttackedImage_Path5 = [AttackedImage_Dir AttackedImage_Name];
    attackedImg = imcrop(watermarkedImg, [0 0 512 448]);
    imwrite(attackedImg, AttackedImage_Path5);
    subplot(3, 3, 5);
    imshow(attackedImg);
    title('Crop');
    
    % 6. Average filter
    Attacked_Type6 = 'Average filter';
    AttackedImage_Name = [filename '_attacked_average.' filetype];
    AttackedImage_Path6 = [AttackedImage_Dir AttackedImage_Name];
    filter = fspecial('average');
    attackedImg = imfilter(watermarkedImg, filter, 'replicate');
    imwrite(attackedImg, AttackedImage_Path6);
    subplot(3, 3, 6);
    imshow(attackedImg);
    title('Average filter');
    
    % 7. Sharpen
    Attacked_Type7 = 'Sharpen';
    AttackedImage_Name = [filename '_attacked_sharpen.' filetype];
    AttackedImage_Path7 = [AttackedImage_Dir AttackedImage_Name];
    attackedImg = imsharpen(watermarkedImg);
    imwrite(attackedImg, AttackedImage_Path7);
    subplot(3, 3, 7);
    imshow(attackedImg);
    title('Sharpen');
    
    % 8. Add salt & pepper noise
    Attacked_Type8 = 'Noise';
    AttackedImage_Name = [filename '_attacked_noise.' filetype];
    AttackedImage_Path8 = [AttackedImage_Dir AttackedImage_Name];
    attackedImg = imnoise(watermarkedImg, 'salt & pepper');
    imwrite(attackedImg, AttackedImage_Path8);
    subplot(3, 3, 8);
    imshow(attackedImg);
    title('Salt & Pepper noise');
    
    % 9. Gaussian lowpass filter
    Attacked_Type9 = 'Gaussian lowpass filter';
    AttackedImage_Name = [filename '_attacked_gaussian.' filetype];
    AttackedImage_Path9 = [AttackedImage_Dir AttackedImage_Name];
    filter = fspecial('gaussian');
    attackedImg = imfilter(watermarkedImg, filter, 'replicate');
    imwrite(attackedImg, AttackedImage_Path9);
    subplot(3, 3, 9);
    imshow(attackedImg);
    title('Gaussian lowpass filter');
	
%% ISSextract process
	% Preprocessing - read attacked image
    attackedImg1 = imread(AttackedImage_Path1);
    attackedImg2 = imread(AttackedImage_Path2);
    attackedImg3 = imread(AttackedImage_Path3);
    attackedImg4 = imread(AttackedImage_Path4);
    attackedImg5 = imread(AttackedImage_Path5);
    attackedImg6 = imread(AttackedImage_Path6);
    attackedImg7 = imread(AttackedImage_Path7);
    attackedImg8 = imread(AttackedImage_Path8);
    attackedImg9 = imread(AttackedImage_Path9);
	
	
	
	% Watermark extraction settings - set pattern, blkSize, wmSize
    watermark0 = ImprovedSpreadSpectrumExtract(watermarkedImg, u, blockSize, n);
	watermark1 = ImprovedSpreadSpectrumExtract(attackedImg1, u, blockSize, n);
    watermark2 = ImprovedSpreadSpectrumExtract(attackedImg2, u, blockSize, n);
    watermark3 = ImprovedSpreadSpectrumExtract(attackedImg3, u, blockSize, n);
    watermark4 = ImprovedSpreadSpectrumExtract(attackedImg4, u, blockSize, n);
    watermark5 = ImprovedSpreadSpectrumExtract(attackedImg5, u, blockSize, n);
    watermark6 = ImprovedSpreadSpectrumExtract(attackedImg6, u, blockSize, n);
    watermark7 = ImprovedSpreadSpectrumExtract(attackedImg7, u, blockSize, n);
    watermark8 = ImprovedSpreadSpectrumExtract(attackedImg8, u, blockSize, n);
    watermark9 = ImprovedSpreadSpectrumExtract(attackedImg9, u, blockSize, n);
    
    
    if specialMethod == 1
        % Error Correction Code Mode
        % Do error correction
        watermark0 = ECC_Correct(watermark0);
        watermark1 = ECC_Correct(watermark1);
        watermark2 = ECC_Correct(watermark2);
        watermark3 = ECC_Correct(watermark3);
        watermark4 = ECC_Correct(watermark4);
        watermark5 = ECC_Correct(watermark5);
        watermark6 = ECC_Correct(watermark6);
        watermark7 = ECC_Correct(watermark7);
        watermark8 = ECC_Correct(watermark8);
        watermark9 = ECC_Correct(watermark9);
    end
	
	
%% Measurement
    
    fprintf('Measurements:\n');

	% Measuring capacity
	capacity = n;
    fprintf('\tCapacity : %d\n', capacity);
	
	
	% Measuring fidelity
	PSNR = psnr(watermarkedImg, orgImg);
	fprintf('\tFidelity : PSNR = %f\n', PSNR);
	
	% Measuring robustness
	numDiff = sum((b == watermark0) == 0);
	BER = numDiff / n;
    fprintf('\tRobustness : BER = %f (%d / %d)\n', BER, numDiff, n);
    %find((b==watermark0)==0);
    
    fprintf('\nBER of Attacks:\n');
    fprintf('\t1. %-30s: %f\n', Attacked_Type1, (sum((b == watermark1) == 0)) / n);
    fprintf('\t2. %-30s: %f\n', Attacked_Type2, (sum((b == watermark2) == 0)) / n);
    fprintf('\t3. %-30s: %f\n', Attacked_Type3, (sum((b == watermark3) == 0)) / n);
    fprintf('\t4. %-30s: %f\n', Attacked_Type4, (sum((b == watermark4) == 0)) / n);
    fprintf('\t5. %-30s: %f\n', Attacked_Type5, (sum((b == watermark5) == 0)) / n);
    fprintf('\t6. %-30s: %f\n', Attacked_Type6, (sum((b == watermark6) == 0)) / n);
    fprintf('\t7. %-30s: %f\n', Attacked_Type7, (sum((b == watermark7) == 0)) / n);
    fprintf('\t8. %-30s: %f\n', Attacked_Type8, (sum((b == watermark8) == 0)) / n);
    fprintf('\t9. %-30s: %f\n', Attacked_Type9, (sum((b == watermark9) == 0)) / n);
    
end
