%%Merge Data

%Modified
folder = 'Nai/BlockSize_Test/';
subname = '_4_to_512_by_1.mat';
%

%Modified
load([folder 'blockSize' subname]);
%
load([folder 'capacity' subname]);
load([folder 'psnr' subname]);
load([folder 'ber' subname]);

%Modified
len = length(array_blockSize);


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

plot(array_blockSize, array_ber);
%axis([1, 10, 0, 1]);
xlabel('Block Size')
ylabel('BER');

figure
plot(array_blockSize, array_psnr);
%axis([1, 50, -Inf, Inf]);
xlabel('Block Size');
ylabel('PSNR');


figure
plot(array_blockSize, array_capacity);
xlabel('Block Size');
ylabel('Capacity');