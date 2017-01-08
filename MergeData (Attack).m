%%Merge Data

%Modified
folder = 'Attack/Alpha/';
subname = '_1_to_100_by_1.mat';
%

%Modified
load([folder 'alpha' subname]);
%
load([folder 'capacity' subname]);
load([folder 'psnr' subname]);
load([folder 'ber' subname]);

%Modified
len = length(array_alpha);

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

plot(array_alpha, array_ber(2, :));
%axis([1, 50, 0, 1]);
title('Attacks 1-5');
xlabel('Alpha')
ylabel('BER');

hold on;
plot(array_alpha, array_ber(3, :), 'c');

hold on;
plot(array_alpha, array_ber(4, :), 'g');

hold on;
plot(array_alpha, array_ber(5, :), 'k');

hold on;
plot(array_alpha, array_ber(6, :), 'r');


hold off;

figure;
plot(array_alpha, array_ber(7, :));
title('Attacks - 6-9');
xlabel('Alpha')
ylabel('BER');

hold on;
plot(array_alpha, array_ber(8, :), 'c');

hold on;
plot(array_alpha, array_ber(9, :), 'g');

hold on;
plot(array_alpha, array_ber(10, :), 'k');

hold off;

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
