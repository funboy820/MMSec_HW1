function ExecuteScript_ISS_ImageWatermark(InputImage_Name, patternLen, blockSize, alpha, lambda)

fprintf('Improved Spread Spectrum Watermarking with Image watermark\n\n');

if blockSize > 16
    fprintf('Block size cannot be more than 16: \tSetting block size to 16\n\n');
    blockSize = 16;
end

ImprovedSpreadSpectrum(InputImage_Name, 1, patternLen, blockSize, alpha, lambda, 2);

end