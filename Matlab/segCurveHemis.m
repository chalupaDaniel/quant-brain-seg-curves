function [output, ccLabeled] = segCurveHemis(allData, segmentationBase, CNs, dataLabels, description, cinematic)
%UNTITLED Summary of this function goes here
%   allData = expected 4-D matrix with dimensions x y datatype subject
%   output = 5-D matrix with dimensions subject datatype segtype segment metric
%   labelMatrices = 3-D matrix showing labeled source data with dimensions
%                   x y labelIndex
segmentationTypes = ["Positive Curvature", "Negative Curvature"];

ccNums = zeros(size(allData, 4), numel(segmentationTypes));
ccLabeled = zeros(size(allData,1), size(allData,2), size(allData,4), numel(segmentationTypes));

for subject = 1:size(allData, 4)
    for segType = 1:numel(segmentationTypes)
        image = allData(:,:, segmentationBase, subject);
        if segmentationTypes(segType) == "Positive Curvature"
            seg = segmentImage(image);
            cc = bwconncomp(seg,8);
            ccNums(subject, segType) = cc.NumObjects;
            ccLabeled(:,:,subject, segType) = labelmatrix(cc);
        elseif segmentationTypes(segType) == "Negative Curvature"
            seg = segmentImage(-1*image);
            cc = bwconncomp(seg,8);
            ccNums(subject, segType) = cc.NumObjects;
            ccLabeled(:,:,subject, segType) = labelmatrix(cc);
        end
    end
end

% output = nan(size(allData, 4), size(allData, 3), numel(segmentationTypes), max(ccNums, [], 'all'), 5);
output = nan(size(allData, 4), size(allData, 3), numel(segmentationTypes), 300, 5);

for imageType = 1:size(allData, 3)
    for segType = 1:numel(segmentationTypes)
        %disp(dataLabels(imageType))
        if (cinematic)
            figure('Name',strcat(dataLabels(imageType),' - ',description, ' - ', segmentationTypes(segType)))
            a = subplot(3,2,1);
            title(a,"Sums")
            b = subplot(3,2,2);
            title("Sizes")
            c = subplot(3,2,3);
            title("Means")
            d = subplot(3,2,4);
            title("Stds")
            e = subplot(3,2,5);
            title("Medians")
        end
        for subject = 1:size(allData, 4)
            %disp(['  ', all(subject)])
        
            data = allData(:,:,imageType, subject);
            distName = 'normal';
        
            if (strcmp(dataLabels(imageType),'Curvature'))
                distName = 'weibull';
            end
            [sums, sizes, means, stds, medians] = imageToSegCurve(data, ccNums(subject, segType), ccLabeled(:,:,subject, segType), distName, false);
            output(subject, imageType, segType, 1:size(sums), 1) = sums;
            output(subject, imageType, segType, 1:size(sizes), 2) = sizes;
            output(subject, imageType, segType, 1:size(means), 3) = means;
            output(subject, imageType, segType, 1:size(stds), 4) = stds;
            output(subject, imageType, segType, 1:size(medians), 5) = medians;

            if (cinematic)
                color = 'r';
                if (subject <= size(CNs,1))
                    color = 'b';
                end
                hold(a, 'on')
                plot(a, sort(sums, 'descend'), color)
                hold(a, 'off')
                hold(b, 'on')
                plot(b, sort(sizes, 'descend'), color)
                hold(b, 'off')
                hold(c, 'on')
                plot(c, sort(means, 'descend'), color)
                hold(c, 'off')
                hold(d, 'on')
                plot(d, sort(stds, 'descend'), color)
                hold(d, 'off')
                hold(e, 'on')
                plot(e, sort(medians, 'descend'), color)
                hold(e, 'off')
            end
        end
        if (cinematic)
            sgtitle(dataLabels(imageType))
        end
    end
end
end

