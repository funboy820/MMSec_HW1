function ExecuteScript_ISS(InputImage_Name, wmLen, patternLen, blockSize, alpha, lambda)

fprintf('Improved Spread Spectrum Watermarking\n\n');

ImprovedSpreadSpectrum(InputImage_Name, wmLen, patternLen, blockSize, alpha, lambda, 0);

end