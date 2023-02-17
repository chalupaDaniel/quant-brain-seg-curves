function [results] = gofTest(segCurves, CNIndexes)
%GOFTEST Test various gofs primarily for segmentation curves
%   segCurves - 5D matrix with dimensions of subject datatype segtype segment metric

%fitTypes = ["gauss3", "gauss4", "gauss5", "gauss6", "poly3", "poly4" "poly5", "poly6", "fourier3", "fourier4", "fourier5", "fourier6"];

fitTypes = ["poly9", "gauss6"];

numRows = 3 * numel(fitTypes);
numCols = 1                    + 1                   + 5;
varTypes = [{'string'};          {'string'};           repmat({'double'}, 5, 1)];
varNames = [{'Group'};    {'Fit type'};           {'sse'};           {'rsquare'}; {'dfe'}; {'adjrsquare'}; {'rmse'}];
results = table('Size',[numRows numCols],'VariableTypes', varTypes, 'VariableNames', varNames);
tableRow = 1;

figure

for fitType = size(fitTypes,2):-1:1
    [~, gofs, fits, source] = fitSegCurves(segCurves, fitTypes(fitType));

    results(tableRow,'Group') = {"AD"};
    results(tableRow,'Fit type') = {fitTypes(fitType)};
    results(tableRow,'sse') = {mean([gofs(setdiff(1:end,CNIndexes),:,:,:).sse])};
    results(tableRow,'rsquare') = {mean([gofs(setdiff(1:end,CNIndexes),:,:,:).rsquare])};
    results(tableRow,'dfe') = {mean([gofs(setdiff(1:end,CNIndexes),:,:,:).dfe])};
    results(tableRow,'adjrsquare') = {mean([gofs(setdiff(1:end,CNIndexes),:,:,:).adjrsquare])};
    results(tableRow,'rmse') = {mean([gofs(setdiff(1:end,CNIndexes),:,:,:).rmse])};
    tableRow = tableRow + 1;
    results(tableRow,'Group') = {"CN"};
    results(tableRow,'Fit type') = {fitTypes(fitType)};
    results(tableRow,'sse') = {mean([gofs(CNIndexes,:,:,:).sse])};
    results(tableRow,'rsquare') = {mean([gofs(CNIndexes,:,:,:).rsquare])};
    results(tableRow,'dfe') = {mean([gofs(CNIndexes,:,:,:).dfe])};
    results(tableRow,'adjrsquare') = {mean([gofs(CNIndexes,:,:,:).adjrsquare])};
    results(tableRow,'rmse') = {mean([gofs(CNIndexes,:,:,:).rmse])};
    tableRow = tableRow + 1;

    results(tableRow,'Group') = {"All"};
    results(tableRow,'Fit type') = {fitTypes(fitType)};
    results(tableRow,'sse') = {mean([gofs(:,:,:,:).sse])};
    results(tableRow,'rsquare') = {mean([gofs(:,:,:,:).rsquare])};
    results(tableRow,'dfe') = {mean([gofs(:,:,:,:).dfe])};
    results(tableRow,'adjrsquare') = {mean([gofs(:,:,:,:).adjrsquare])};
    results(tableRow,'rmse') = {mean([gofs(:,:,:,:).rmse])};
    tableRow = tableRow + 1;

    sums = zeros(1000,1);
    maxSize = 0;
    for i = 1:size(source, 1)
        for j = 1:size(source, 2)
            for k = 1:size(source, 3)
                for l = 1:size(source, 4)
                    residuals = source(i,j,k,l).y - feval(fits{i,j,k,l}, source(i,j,k,l).x);
                    sums(1:size(residuals)) = sums(1:size(residuals)) + abs(residuals);
                    
                    if (maxSize < size(residuals))
                        maxSize = size(residuals);
                    end
                end
            end
        end
    end
    plot(sums(1:maxSize), '-x')
    legend(fitTypes(end:-1:1))
    hold on
end

end

