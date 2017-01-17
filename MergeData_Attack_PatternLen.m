%%Merge Data - Pattern Length

folder = 'Attack/PatternLength/';
subname = '_1_to_64_by_1.mat';

load([folder 'patternLength' subname]);
load([folder 'ber' subname]);

len = length(array_patternLen);

f1 = figure;
plot(array_patternLen, array_ber(2, :));
title('Attacks 1-5');
xlabel('Pattern Length')
ylabel('BER');
axis([-Inf Inf -0.1 1.1]);

hold on;
plot(array_patternLen, array_ber(3, :), 'c');

hold on;
plot(array_patternLen, array_ber(4, :), 'g');

hold on;
plot(array_patternLen, array_ber(5, :), 'k');

hold on;
plot(array_patternLen, array_ber(6, :), 'r');

legend('JPEG', 'Rotation', 'Shift', 'Scale', 'Crop');


hold off;

f2 = figure;
plot(array_patternLen, array_ber(7, :));
title('Attacks - 6-9');
xlabel('Pattern Length')
ylabel('BER');
axis([-Inf Inf -0.1 1.1]);

hold on;
plot(array_patternLen, array_ber(8, :), 'c');

hold on;
plot(array_patternLen, array_ber(9, :), 'g');

hold on;
plot(array_patternLen, array_ber(10, :), 'k');

legend('Average Filter', 'Sharpen', 'Salt & Pepper', 'Gaussian');

% Save figure
saveas(f1, [folder 'ISS_attack_1_5_patternLen_to_ber'], 'jpg');
saveas(f2, [folder 'ISS_attack_6_10_patternLen_to_ber'], 'jpg');