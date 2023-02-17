function showHistograms(sources, images, dataLabels)
%UNTITLED3 Summary of this function goes here
%   Detailed explanation goes here

rows = ceil(size(sources,2) / 2);
bins = 256;

figure
for i = 1:size(sources, 2)
        subplot(rows,4,2*i - 1)
        histogram(sources(:,i), bins)
        title([dataLabels(i) + " - Source"])
        subplot(rows,4,2*i)
        saneData = images(:,:,i);
        saneData(isnan(saneData)) = [];
        histogram(saneData(:), bins);
        title([dataLabels(i) + " - After projection"])
end

end

