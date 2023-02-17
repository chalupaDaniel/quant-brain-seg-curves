function [cor, chi, intersect, bhat] = compareImages(im1, im2, downLimit, upLimit, bins)
%compareData Compares the data and returns the comparisons
%   cor - pearson's corr coef

% Uncomment for normalization
% im1 = double(im1);
% im1 = im1/max(im1(:));
% im2 = double(im2);
% im2 = im2/max(im2(:));

data1 = im1(:);
data1(isnan(data1)) = 0;
data2 = im2(:);
data2(isnan(data2)) = 0;

d1h = histcounts(data1, bins,'BinLimits',[downLimit,upLimit]);
d2h = histcounts(data2, bins,'BinLimits',[downLimit,upLimit]);

cor = corr(d1h', d2h');
chi = pdist3(d1h, d2h, 'chisq');
intersect = histogram_intersection(d1h, d2h);
bhat = bhattacharyya(d1h, d2h);
end