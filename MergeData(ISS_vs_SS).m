%%Merge Data

%Modified
folder = 'Alpha_Test/SS/';
subname = '_0-1_to_100_by_0-1.mat';
%

%Modified
load([folder 'alpha' subname]);
%
load([folder 'capacity' subname]);
load([folder 'psnr' subname]);
load([folder 'ber' subname]);

array_alpha_ss = array_alpha;
array_ber_ss = array_ber;
array_psnr_ss = array_psnr;
array_capacity_ss = array_capacity;

%Modified
len = length(array_alpha);



%Modified
folder = 'Alpha_Test/';
subname = '_0-1_to_100_by_0-1.mat';
%

%Modified
load([folder 'alpha' subname]);
%
load([folder 'capacity' subname]);
load([folder 'psnr' subname]);
load([folder 'ber' subname]);

% data_ss_alpha = zeros(4,len);
% %
% 
% for i = 1 : len
%     %Modified
%     data_ss_alpha(1, i) = array_alpha(i);
%     %
%     data_ss_alpha(2, i) = array_capacity(i);
%     data_ss_alpha(3, i) = array_psnr(i);
%     data_ss_alpha(4, i) = array_ber(i);
% end

plot(array_alpha, array_ber);
axis([1, 10, 0, 1]);
title('ISS v.s. SS');
xlabel('Alpha')
ylabel('BER');

hold on;
plot(array_alpha, array_ber_ss, 'g');
hold off;


figure
plot(array_alpha, array_psnr);
%axis([1, 50, -Inf, Inf]);
title('ISS v.s. SS');
xlabel('Alpha');
ylabel('PSNR');

hold on;
plot(array_alpha, array_psnr_ss, 'g');
hold off;


figure
plot(array_alpha, array_capacity);
title('Spread Spectrum');
xlabel('Alpha');
ylabel('Capacity');

hold on;
plot(array_alpha, array_capacity_ss, 'g');
hold off;