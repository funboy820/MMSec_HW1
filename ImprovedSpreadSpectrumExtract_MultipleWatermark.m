function [extractWM, extractWM1, extractWM2] = ImprovedSpreadSpectrumExtract_MultipleWatermark(SuspImage, pattern, blkSize, wmSize)
    
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
    
    len1 = floor(m/2);
    pattern1 = pattern(1:len1);
    pattern2 = pattern(len1+1:end);
    
    wm1Len = floor(n/2);
    extractWM1 = zeros(wm1Len, 1);
    extractWM2 = zeros(wm1Len, 1);
    bCnt = 1;
	% Do blockDCT
    for i = 1 : floor(height/blkSize)
		iStart =  1 + (i-1) * blkSize;
		iEnd = iStart + blkSize - 1;
        for j = 1 : floor(width/blkSize)
            
            if bCnt > wm1Len
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
            
            dctS1 = dctS(1:len1);
            dctS2 = dctS(len1+1:end);
            
            sim1 = dot(dctS1, pattern1) / dot(pattern1, pattern1);
            sim2 = dot(dctS2, pattern2) / dot(pattern2, pattern2);
            b1 = sign(sim1);
            b2 = sign(sim2);
            
            extractWM1(bCnt) = b1;
            extractWM2(bCnt) = b2;

			bCnt = bCnt + 1;
            
        end
        
        if bCnt > wm1Len
            break;
        end
        
    end
    
    extractWM = [extractWM1; extractWM2];

end