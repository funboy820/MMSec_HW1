function WMImage = ImprovedSpreadSpectrumEmbed_MultipleWatermark(InputImage, watermark1, watermark2, pattern, alpha, lambda, blkSize)

    m = length(pattern);
    n = length(watermark1) + length(watermark2);

	% Preprocessing - change color space and get image size
    ycbcrImg = rgb2ycbcr(InputImage);
    yImg = ycbcrImg(:, :, 1);
    
    [height, width] = size(yImg);

    ycbcr_WMImg = ycbcrImg;
    y_WMImg = yImg;

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
			
			% Embedding each bit of watermark into each block:
			dctBlock = dct2(tmpBlock);
            dctVector = reshape(dctBlock, 1, []);
			dctX = transpose(dctVector(indexSequence));
            
            dctX1 = dctX(1:len1);
            dctX2 = dctX(len1+1:end);
            
            b1 = watermark1(bCnt);
            b2 = watermark2(bCnt);
            
            s1 = dctX1 + (alpha*b1 - lambda*dot(dctX1, pattern1)/dot(pattern1, pattern1)) * pattern1;
            s2 = dctX2 + (alpha*b2 - lambda*dot(dctX2, pattern2)/dot(pattern2, pattern2)) * pattern2;
            s = [s1; s2];
            
            wmDctVector = dctVector;
            
            wmDctVector(indexSequence) = transpose(s);
            wmDctBlock = reshape(wmDctVector, blkSize, blkSize);
            
            wmBlock = idct2(wmDctBlock);
			
			% Write watermarked block to Y_WMImage
            y_WMImg(iStart:iEnd, jStart:jEnd) = wmBlock;
			
			bCnt = bCnt + 1;
			
        end
        
        if bCnt > n
            break;
        end
        
	end


	% Transform back to RGB color space
    ycbcr_WMImg(:, :, 1) = y_WMImg;
    WMImage = ycbcr2rgb(ycbcr_WMImg);

end