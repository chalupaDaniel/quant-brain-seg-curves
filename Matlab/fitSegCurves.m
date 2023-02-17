function [fits, gofs, sources] = fitSegCurves(segCurves, fitType)
%FITSEGCURVES Fits the segmentation curves and outputs coefficient values,
%             goodness of fits and the fitted curves themselves
%   segCurves - 4D matrix with dimensions of
%   fittype - the type of the fit
%   cvals - coefficient values, 4-D matrix with dimensions of
%           datatype, segmentation type, metric and coefficient
%   gofs - goodness of fits, 3-D struct with dimensions of 
%          datatype, segmentation type and metric
%   fits - the fit objects, 3-D cell with the same dimensions as gofs

    for dataType = size(segCurves,1):-1:1
        for segType = size(segCurves,2):-1:1
            for metric = size(segCurves,4):-1:1
                [fitted, gof, source] = fitSegCurve(segCurves(dataType,segType,:,metric), fitType);
                sources(dataType, segType, metric) = source;
                fits{dataType,segType,metric} = fitted;
                gofs(dataType,segType,metric) = gof;
                %cvals(dataType,segType,metric,:) = coeffvalues(fitted);
                % disp(strcat(all(subject)," - ", dataLabels(dataType)," - ", segTypeLabels(segType)," - ", metricLabels(metric), ": RMSE ",num2str(gof.rmse)));
            end
        end
    end

end

