%%Merge Data - Alpha

folder = 'Attack/Alpha/';
subname = '_0-1_to_100.mat';

load([folder 'alpha' subname]);
load([folder 'ber' subname]);


len = length(array_alpha);

f1 = figure(1);
plot(array_alpha, array_ber(2, :));
title('Attacks 1-5');
xlabel('Alpha')
ylabel('BER');
axis([-5 150 -0.1 1.1]);

hold on;
plot(array_alpha, array_ber(3, :), 'c');

hold on;
plot(array_alpha, array_ber(4, :), 'g');

hold on;
plot(array_alpha, array_ber(5, :), 'k');

hold on;
plot(array_alpha, array_ber(6, :), 'r');

legend('JPEG', 'Rotation', 'Shift', 'Scale', 'Crop');


hold off;

f2 = figure(2);
plot(array_alpha, array_ber(7, :));
title('Attacks - 6-9');
xlabel('Alpha')
ylabel('BER');
axis([-5 150 -0.1 1.1]);

hold on;
plot(array_alpha, array_ber(8, :), 'c');

hold on;
plot(array_alpha, array_ber(9, :), 'g');

hold on;
plot(array_alpha, array_ber(10, :), 'k');

legend('Average Filter', 'Sharpen', 'Salt & Pepper', 'Gaussian');

% Save figure
saveas(f1, [folder 'ISS_attack_1_5_alpha_to_ber'], 'jpg');
saveas(f2, [folder 'ISS_attack_6_10_alpha_to_ber'], 'jpg');