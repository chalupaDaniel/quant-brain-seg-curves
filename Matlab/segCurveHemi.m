function [output, ccLabeled, failures, segmentationTypes] = segCurveHemi(data, segmentationBase, dataLabels)
%UNTITLED Summary of this function goes here
%   allData = expected 3-D matrix with dimensions x y datatype
%   output = 4-D matrix with dimensions datatype segtype segment metric
%   labelMatrices = 3-D matrix showing labeled source data with dimensions
%                   x y labelIndex
segmentationTypes = ["Positive Curvature", "Negative Curvature"];

ccNums = zeros(1, numel(segmentationTypes));
ccLabeled = zeros(size(data,1), size(data,2), numel(segmentationTypes));

    for segType = 1:numel(segmentationTypes)
        image = data(:,:, segmentationBase);
        if segmentationTypes(segType) == "Positive Curvature"
            seg = segmentImage(image);
            cc = bwconncomp(seg,8);
            ccNums(segType) = cc.NumObjects;
            ccLabeled(:,:, segType) = labelmatrix(cc);
        elseif segmentationTypes(segType) == "Negative Curvature"
            seg = segmentImage(-1*image);
            cc = bwconncomp(seg,8);
            ccNums(segType) = cc.NumObjects;
            ccLabeled(:,:, segType) = labelmatrix(cc);
        end
    end

% output = nan(size(allData, 4), size(allData, 3), numel(segmentationTypes), max(ccNums, [], 'all'), 5);
output = nan(size(data, 3), numel(segmentationTypes), 300, 5);
failures = zeros(size(data, 3), numel(segmentationTypes));

for imageType = 1:size(data, 3)
    for segType = 1:numel(segmentationTypes)
        %disp(dataLabels(imageType))
        
            localData = data(:,:,imageType);
            distName = 'normal';

            [sums, sizes, means, stds, medians, normFails] = imageToSegCurve(localData, ccNums(segType), ccLabeled(:,:, segType), distName, false);
            
            failures(imageType, segType) = normFails;
            output(imageType, segType, 1:size(sums), 1) = sums;
            output(imageType, segType, 1:size(sizes), 2) = sizes;
            output(imageType, segType, 1:size(means), 3) = means;
            output(imageType, segType, 1:size(stds), 4) = stds;
            output(imageType, segType, 1:size(medians), 5) = medians;

    end
end
end

