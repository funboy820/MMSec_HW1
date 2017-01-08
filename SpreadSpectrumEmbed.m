function WMImage = SpreadSpectrumEmbed(InputImage, watermark, pattern, alpha, blkSize)

    m = length(pattern);
    n = length(watermark);

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
            
            b = watermark(bCnt);
            
            s = dctX + alpha * b * pattern;
            
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