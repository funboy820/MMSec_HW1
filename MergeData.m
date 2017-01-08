%%Merge Data

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

%Modified
len = length(array_alpha);


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
axis([0.1, 1, 0, 1]);
xlabel('Alpha')
ylabel('BER');

figure
plot(array_alpha, array_psnr);
%axis([1, 50, -Inf, Inf]);
xlabel('Alpha');
ylabel('PSNR');


figure
plot(array_alpha, array_capacity);
xlabel('Alpha');
ylabel('Capacity');