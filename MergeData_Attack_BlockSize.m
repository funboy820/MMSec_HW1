%%Merge Data - Block Size

folder = 'Attack/BlockSize/';
subname = '_4_to_512_by_1_alpha_05.mat';

load([folder 'blockSize' subname]);
load([folder 'ber' subname]);

len = length(array_blockSize);

f1 = figure;
plot(array_blockSize, array_ber(2, :));
title('Attacks 1-5');
xlabel('Block Size')
ylabel('BER');
axis([-5 650 -0.1 1.1]);

hold on;
plot(array_blockSize, array_ber(3, :), 'c');

hold on;
plot(array_blockSize, array_ber(4, :), 'g');

hold on;
plot(array_blockSize, array_ber(5, :), 'k');

hold on;
plot(array_blockSize, array_ber(6, :), 'r');

legend('JPEG', 'Rotation', 'Shift', 'Scale', 'Crop');


hold off;

f2 = figure;
plot(array_blockSize, array_ber(7, :));
title('Attacks - 6-9');
xlabel('Block Size')
ylabel('BER');
axis([-5 650 -0.1 1.1]);

hold on;
plot(array_blockSize, array_ber(8, :), 'c');

hold on;
plot(array_blockSize, array_ber(9, :), 'g');

hold on;
plot(array_blockSize, array_ber(10, :), 'k');

legend('Average Filter', 'Sharpen', 'Salt & Pepper', 'Gaussian');

% Save figure
saveas(f1, [folder 'ISS_attack_1_5_blockSize_to_ber'], 'jpg');
saveas(f2, [folder 'ISS_attack_6_10_blockSize_to_ber'], 'jpg');