function ExecuteScript_ISS_ECC(InputImage_Name, wmLen, patternLen, blockSize, alpha, lambda)

fprintf('Improved Spread Spectrum Watermarking with Error Correction Code\n\n');

ImprovedSpreadSpectrum(InputImage_Name, wmLen, patternLen, blockSize, alpha, lambda, 1);

end