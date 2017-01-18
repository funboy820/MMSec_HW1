%function ExecuteScript_ProfHsuScheme(InputImage_Name)

InputImage_Name = 'airplane_gray.bmp';
blockSize = 8;

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
	

%% Preprocessing - read original image
    orgImg = imread(InputImage_Path);
    figure;
    imshow(orgImg);
    title('Original Image');
    height = size(orgImg, 1);
    width = size(orgImg, 2);
    
    watermark = double(imread('Watermark/watermark256.bmp'));
    [rowsW, colsW] = size(watermark);

%% Pseudorandom Permutation of the Watermark
    
    lenRan = rowsW * colsW;
    randomSequence = 0:lenRan-1;
    switchTarget = randi([1 lenRan], 1, lenRan);
    
    % Shuffle
    for i = 1:lenRan
        idx = switchTarget(i);
        % Switch the two numbers
        tmp = randomSequence(idx);
        randomSequence(idx) = randomSequence(i);
        randomSequence(i) = tmp;
    end
    
    Wp = zeros(rowsW, colsW);
    k = 1;
    for i=1:rowsW
        for j=1:colsW
            r = floor(randomSequence(k) / rowsW);
            c = mod(randomSequence(k), rowsW);
            Wp(r+1, c+1) = watermark(i, j);
            
            k = k + 1;
        end
    end

%% Block-Based Image-Dependent Permutation of the Watermark
    
    % Calculate Variance
    nRowBlock = floor(height / blockSize);
    var = zeros(nRowBlock, nRowBlock);
    for i=1:nRowBlock
        iHead = (i-1)*blockSize+1;
        iTail = i*blockSize;

        for j=1:nRowBlock
            jHead = (j-1)*blockSize+1;
            jTail = j*blockSize;

            imgBlock = double(orgImg(iHead:iTail, jHead:jTail));

            meanVal = mean(mean(imgBlock));
            tmp = imgBlock-meanVal;
            var(i, j) = sum(dot(tmp, tmp));
        end
    end

    var_1d = reshape(var, 1, []);
    [var_1d, var_map] = sort(var_1d);
    var_1d = fliplr(var_1d);
    var_map = fliplr(var_map);
    
    % Calculate signed pixels
    wmBlockSize = floor(blockSize * rowsW / height);
    signedNum = zeros(nRowBlock, nRowBlock);
    for i=1:nRowBlock
        iHead = (i-1)*wmBlockSize+1;
        iTail = i*wmBlockSize;

        for j=1:nRowBlock
            jHead = (j-1)*wmBlockSize+1;
            jTail = j*wmBlockSize;

            wmBlock = Wp(iHead:iTail, jHead:jTail);
            
            signedNum(i, j) = sum(sum(wmBlock));
        end
    end
    
    signedNum_1d = reshape(signedNum, 1, []);
    [signedNum_1d, signedNum_map] = sort(signedNum_1d);
    signedNum_1d = fliplr(signedNum_1d);
    signedNum_map = fliplr(signedNum_map);
    
    Wb = zeros(rowsW, colsW);
    k=1;
    for i=1:nRowBlock
        for j=1:nRowBlock
            new_r = ceil(var_map(k) / nRowBlock);
            new_c = mod(var_map(k), nRowBlock);
            if new_c == 0
                new_c  = new_c + nRowBlock;
            end
            
            index = signedNum_map(k);
            old_r = ceil(index / nRowBlock);
            old_c = mod(index, nRowBlock);
            if old_c == 0
                old_c = old_c + nRowBlock;
            end
            
            rHead = (old_r-1)*wmBlockSize+1;
            rTail = old_r*wmBlockSize;
            cHead = (old_c-1)*wmBlockSize+1;
            cTail = old_c*wmBlockSize;
            wmBlock = Wp(rHead:rTail, cHead:cTail);
            
            rHead = (new_r-1)*wmBlockSize+1;
            rTail = new_r*wmBlockSize;
            cHead = (new_r-1)*wmBlockSize+1;
            cTail = new_r*wmBlockSize;
            
            Wb(rHead:rTail, cHead:cTail) = wmBlock;
            
            k = k + 1;
        end
    end

%% DCT

    %Y = dct(orgImg);
    Y = zeros(height, width);
    for i=1:nRowBlock
        iHead = (i-1)*blockSize + 1;
        iTail = i*blockSize;
        for j=1:nRowBlock
            jHead = (j-1)*blockSize + 1;
            jTail = j*blockSize;
            
            imgBlock = orgImg(iHead:iTail, jHead:jTail);
            
            Y(iHead:iTail, jHead:jTail) = dct2(imgBlock);
            
        end
    end
   


%% Choice of Middle-Frequency Coefficients
    % Preprocessing - preparing zigzag scan index
    zzOrder = ZigzagOrder(blockSize);
    zzOrder = reshape(zzOrder, 1, []);
    [~, zzOrder]= sort(zzOrder,'ascend');
    
    zzStart = 18;
    
    indexSequence = zzOrder(zzStart : (zzStart+16-1));

%% Modification of the DCT Coefficients

    for i=1:nRowBlock
        iHead = (i-1)*blockSize+1;
        iTail = i*blockSize;
        
        wiHead = (i-1)*wmBlockSize+1;
        wiTail = i*wmBlockSize;
        for j=1:nRowBlock
            jHead = (j-1)*blockSize+1;
            jTail = j*blockSize;
            
            prej = j-1;
            if prej == 0
                prej = nRowBlock;
            end
            prejHead = (prej-1)*blockSize+1;
            prejTail = prej*blockSize;
            
            % Extract block information
            preBlock = Y(iHead:iTail, prejHead:prejTail);
			tmpBlock = Y(iHead:iTail, jHead:jTail);
			
			% Embedding each bit of watermark into each block:
            
            dctVector0 =reshape(preBlock, 1, []);
            dctVector = reshape(tmpBlock, 1, []);
            Yr0 =transpose(dctVector0(indexSequence)); 
			Yr = transpose(dctVector(indexSequence));
            
            % Calculate Polarity
            P = zeros(16, 1);
            for k=1:16
                if Yr(k) > Yr0(k)
                    P(k) = 1;
                end
            end
            
            wjHead = (j-1)*wmBlockSize + 1;
            wjTail = j*wmBlockSize;
            b = Wb(wiHead:wiTail, wjHead:wjTail);
            b = reshape(b, [], 1);
            
            % Calculate new Polarity
            newP = xor(P, b);
            
            % Calculate new Yr
        end
    end


%% Inverse - Pseudorandom Permutation of the Watermark

    extractWM = zeros(rowsW, colsW);

    k = 1;
    for i=1:rowsW
        for j=1:colsW
            r = floor(randomSequence(k) / rowsW);
            c = mod(randomSequence(k), rowsW);
            extractWM(i, j) = Wp(r+1, c+1);
            
            k = k + 1;
        end
    end
    
    figure;
    imshow(extractWM);
%end
