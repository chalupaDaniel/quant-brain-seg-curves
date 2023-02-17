function [dataR, dataL, dataLabels, ...
          segCurveR, segCurveL, ccLabelsR, ccLabelsL, failuresR, failuresL, segmentationTypes, ...
          gofR, fitR, sourceR, gofL, fitL, sourceL] ...
          = run_all(inputDir, outputDir, imageSize, fitType, verbose)

if verbose, disp(strcat("Running for ", outputDir, "..")), end

if ~exist(outputDir, 'dir')
    mkdir(outputDir)
end

% Retrieve all data
% X Y Feature
dataR = zeros(imageSize(1), imageSize(2), 4);
dataL = zeros(imageSize(1), imageSize(2), 4);

invalidateNextSteps = false;

try
    if invalidateNextSteps, throw(), end
    load(strcat(outputDir, 'mollweide.mat'), 'dataR', 'dataL', 'dataLabels')
    if verbose, disp("  Mollweide conversion loaded.."), end
catch
    if verbose, disp("  Reading freesurfer data.."), end
    [lhCoords, rhCoords, lhData, rhData, dataLabels] = freesurferData(inputDir);

    if verbose, disp("  Mollweide conversion.."), end
    lhImages = convertToMollweide(lhCoords, lhData, imageSize, 1);
    rhImages = convertToMollweide(rhCoords, rhData, imageSize, 1);
    
    dataR(:,:,:) = rhImages;
    dataL(:,:,:) = lhImages;
    save(strcat(outputDir, 'mollweide.mat'), 'dataR', 'dataL', 'dataLabels')
    invalidateNextSteps = true;
end

% Get seg curves
% segTypeLabels = ["Positive Curvature", "Negative Curvature"];
% metricLabels = ["Sums","Sizes","Means","Stds","Medians"];
% subject datatype segtype segment metric
try
    if invalidateNextSteps, throw(), end
    load(strcat(outputDir, 'segCurves.mat'), 'segCurveR', 'segCurveL', 'ccLabelsR', 'ccLabelsL', 'failuresR', 'failuresL', 'segmentationTypes');
    if verbose, disp("  Segmentation curves conversion loaded.."), end
catch
    if verbose, disp("  Gathering segmentation curves.."), end
    [ segCurveR, ccLabelsR, failuresR, segmentationTypes ] = segCurveHemi(dataR(:,:,1:3), 1, dataLabels);
    [ segCurveL, ccLabelsL, failuresL, ~ ] = segCurveHemi(dataL(:,:,1:3), 1, dataLabels);
    
    if verbose == 2
       for imageType = 1:size(failuresR,1)
         for segmentationType = 1:size(failuresR,2)
             
            distName = 'normal';
        
            if (strcmp(dataLabels(imageType),'Curvature'))
                distName = 'weibull';
            end
            disp(strcat("    L ", num2str(failuresL(imageType, segmentationType), '%02.2f'), "% of segments of ", dataLabels(imageType), ...
                " using ", segmentationTypes(segmentationType)," segmentation failed normality for ", distName," distribution"))
            disp(strcat("    R ", num2str(failuresR(imageType, segmentationType), '%02.2f'), "% of segments of ", dataLabels(imageType), ...
                " using ", segmentationTypes(segmentationType)," segmentation failed normality for ", distName," distribution"))
         end
       end
    end

    save(strcat(outputDir, 'segCurves.mat'), 'segCurveR', 'segCurveL', 'ccLabelsR', 'ccLabelsL', 'failuresR', 'failuresL', 'segmentationTypes');
    invalidateNextSteps = true;
end

% Fit seg curves
try
    if invalidateNextSteps, throw(), end
    load(strcat(outputDir, 'gauss.mat'), 'gofR', 'fitR', 'sourceR', 'gofL', 'fitL', 'sourceL');
    if verbose, disp("  Curve fit loaded.."), end
catch
    if verbose, disp('  Fitting curves..'), end
    [fitR, gofR, sourceR] = fitSegCurves(segCurveR, fitType);
    [fitL, gofL, sourceL] = fitSegCurves(segCurveL, fitType);

    save(strcat(outputDir, 'gauss.mat'), 'gofR', 'fitR', 'sourceR', 'gofL', 'fitL', 'sourceL');
    invalidateNextSteps = true;
end

end
