%%Merge Data - Block Size

%Modified
folder = 'Attack/BlockSize/';
subname = '_4_to_512_by_1_alpha_05.mat';
%

%Modified
load([folder 'blockSize' subname]);
%
load([folder 'capacity' subname]);
load([folder 'psnr' subname]);
load([folder 'ber' subname]);

%Modified
len = length(array_blockSize);

% data_iss_attack_alpha = zeros(4,len);
% %
% 
% for i = 1 : len
%     %
%     data_iss_attack_alpha(1, i) = array_alpha(i);
%     %
%     data_iss_attack_alpha(2, i) = array_capacity(i);
%     data_iss_attack_alpha(3, i) = array_psnr(i);
%     data_iss_attack_alpha(4, i) = array_ber(i);
% end

plot(array_blockSize, array_ber(2, :));
%axis([1, 50, 0, 1]);
title('Attacks 1-5');
xlabel('Block Size')
ylabel('BER');

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

figure;
plot(array_blockSize, array_ber(7, :));
title('Attacks - 6-9');
xlabel('Block Size')
ylabel('BER');

hold on;
plot(array_blockSize, array_ber(8, :), 'c');

hold on;
plot(array_blockSize, array_ber(9, :), 'g');

hold on;
plot(array_blockSize, array_ber(10, :), 'k');

legend('Average Filter', 'Sharpen', 'Salt & Pepper', 'Gaussian');


% figure
% plot(array_alpha, array_psnr);
% %axis([1, 50, -Inf, Inf]);
% title('Attack 1');
% xlabel('Alpha');
% ylabel('PSNR');
% 
% 
% figure
% plot(array_alpha, array_capacity);
% title('Attack 1');
% xlabel('Alpha');
% ylabel('Capacity');
