function extractWM = SpreadSpectrumExtract(SuspImage, pattern, blkSize, wmSize)
    
    m = length(pattern);
    n = wmSize;

	% preprocessing - change color space and get image size
    ycbcrImg = rgb2ycbcr(SuspImage);
    yImg = ycbcrImg(:, :, 1);
    
    [height, width] = size(yImg);
	
	% Preprocessing - preparing zigzag scan index
    zzOrder = ZigzagOrder(blkSize);
    zzOrder = reshape(zzOrder, 1, []);
    [~, zzOrder]= sort(zzOrder,'ascend');
    
    zzStart = floor((blkSize^2) / 2 - floor(m/2));
    
    if zzStart <= 0
        zzStart = 1;
    end
    
    indexSequence = zzOrder(zzStart : (zzStart+m-1));
    
    extractWM = zeros(n, 1);
    bCnt = 1;
	% Do blockDCT
    for i = 1 : floor(height/blkSize)
		iStart =  1 + (i-1) * blkSize;
		iEnd = iStart + blkSize - 1;
        for j = 1 : floor(width/blkSize)
            
            if bCnt > n
                break;
            end
            
			jStart = 1 + (j-1) * blkSize;
			jEnd = jStart + blkSize - 1;
			
			% Extract block information
			tmpBlock = yImg(iStart:iEnd, jStart:jEnd);
			
			% Extract each bit of watermark:			
            dctBlock = dct2(tmpBlock);
            dctVector = reshape(dctBlock, 1, []);
			dctS = transpose(dctVector(indexSequence));
            
            sim = dot(dctS, pattern) / dot(pattern, pattern);
            b = sign(sim);
            
            extractWM(bCnt) = b;

			bCnt = bCnt + 1;
            
        end
        
        if bCnt > n
            break;
        end
        
    end

end