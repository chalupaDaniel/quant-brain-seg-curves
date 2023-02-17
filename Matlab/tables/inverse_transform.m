analyses_init;

%% Load data
nonfailCounter = 1;
subDirListCN = dir("../../data/subjects/CN");
for i = 1:size(subDirListCN,1)
    try
        if strcmp(subDirListCN(i).name, '.') || strcmp(subDirListCN(i).name,'..')
            continue
        end
        subjectDir = [ subDirListCN(i).folder '/' subDirListCN(i).name '/' ];
        %disp(subjectDir)
        targetDir = [ subDirListCN(i).folder '/' subDirListCN(i).name '/matlab/' ];
        [dataR, dataL, dataLabels, ...
          segCurveR, segCurveL, ccLabelsR, ccLabelsL, failuresR, failuresL, segmentationTypes, ...
          gofR, fitR, sourceR, gofL, fitL, sourceL] = run_all( subjectDir, targetDir, [360 720], 'gauss6', 0);
        segCurveCNR(nonfailCounter, :,:,:,:) = segCurveR;
        segCurveCNL(nonfailCounter, :,:,:,:) = segCurveL;
        indexesCNR(nonfailCounter,:,:,:,:) = reshape([sourceR.sortIdx], [], size(sourceR,1),size(sourceR,2),size(sourceR,3),size(sourceR,4));
        indexesCNL(nonfailCounter,:,:,:,:) = reshape([sourceL.sortIdx], [], size(sourceL,1),size(sourceL,2),size(sourceL,3),size(sourceL,4));
        ccLabelCNR(nonfailCounter,:,:,:) = ccLabelsR;
        ccLabelCNL(nonfailCounter,:,:,:) = ccLabelsL;
        srcLabelsCNR(nonfailCounter,:,:) = dataR(:,:,4);
        srcLabelsCNL(nonfailCounter,:,:) = dataL(:,:,4);
        nonfailCounter = nonfailCounter + 1;
    catch
            disp('FAIL')
        disp(subjectDir)
    end
    
end

nonfailCounter = 1;
subDirListAD = dir("../../data/subjects/AD");
for i = 1:size(subDirListAD,1)
    try
        if strcmp(subDirListAD(i).name, '.') || strcmp(subDirListAD(i).name,'..')
            continue
        end
        subjectDir = [ subDirListAD(i).folder '/' subDirListAD(i).name '/' ];
        %disp(subjectDir)
        targetDir = [ subDirListAD(i).folder '/' subDirListAD(i).name '/matlab/' ];
        [dataR, dataL, dataLabels, ...
          segCurveR, segCurveL, ccLabelsR, ccLabelsL, failuresR, failuresL, segmentationTypes, ...
          gofR, fitR, sourceR, gofL, fitL, sourceL] = run_all( subjectDir, targetDir, [360 720], 'gauss6', 0);
        segCurveADR(nonfailCounter, :,:,:,:) = segCurveR;
        segCurveADL(nonfailCounter, :,:,:,:) = segCurveL;
        indexesADR(nonfailCounter,:,:,:,:) = reshape([sourceR.sortIdx], [], size(sourceR,1),size(sourceR,2),size(sourceR,3),size(sourceR,4));
        indexesADL(nonfailCounter,:,:,:,:) = reshape([sourceL.sortIdx], [], size(sourceL,1),size(sourceL,2),size(sourceL,3),size(sourceL,4));
        ccLabelADR(nonfailCounter,:,:,:) = ccLabelsR;
        ccLabelADL(nonfailCounter,:,:,:) = ccLabelsL;
        srcLabelsADR(nonfailCounter,:,:) = dataR(:,:,4);
        srcLabelsADL(nonfailCounter,:,:) = dataL(:,:,4);
        nonfailCounter = nonfailCounter + 1;
    catch
            disp('FAIL')
        disp(subjectDir)
    end
    
end

nonfailCounter = 1;
subDirListMCI = dir("../../data/subjects/MCI");
for i = 1:size(subDirListMCI,1)
    try
        if strcmp(subDirListMCI(i).name, '.') || strcmp(subDirListMCI(i).name,'..')
            continue
        end
        subjectDir = [ subDirListMCI(i).folder '/' subDirListMCI(i).name '/' ];
        %disp(subjectDir)
        targetDir = [ subDirListMCI(i).folder '/' subDirListMCI(i).name '/matlab/' ];
        [dataR, dataL, dataLabels, ...
          segCurveR, segCurveL, ccLabelsR, ccLabelsL, failuresR, failuresL, segmentationTypes, ...
          gofR, fitR, sourceR, gofL, fitL, sourceL] = run_all( subjectDir, targetDir, [360 720], 'gauss6', 0);
        segCurveMCIR(nonfailCounter, :,:,:,:) = segCurveR;
        segCurveMCIL(nonfailCounter, :,:,:,:) = segCurveL;
        indexesMCIR(nonfailCounter,:,:,:,:) = reshape([sourceR.sortIdx], [], size(sourceR,1),size(sourceR,2),size(sourceR,3),size(sourceR,4));
        indexesMCIL(nonfailCounter,:,:,:,:) = reshape([sourceL.sortIdx], [], size(sourceL,1),size(sourceL,2),size(sourceL,3),size(sourceL,4));
        ccLabelMCIR(nonfailCounter,:,:,:) = ccLabelsR;
        ccLabelMCIL(nonfailCounter,:,:,:) = ccLabelsL;
        srcLabelsMCIR(nonfailCounter,:,:) = dataR(:,:,4);
        srcLabelsMCIL(nonfailCounter,:,:) = dataL(:,:,4);
        nonfailCounter = nonfailCounter + 1;
    catch
            disp('FAIL')
        disp(subjectDir)
    end
    
end


%%
% Mean normal seg curves
% datatype segtype metric


meanSegCurves(:,:,:,:) = squeeze(mean(cat(1, segCurveCNR,  segCurveCNL), 1));
ADCount = size(segCurveADR,1) * size(segCurveADR,2) * size(segCurveADR,3) * size(segCurveADR,5) * size(annotationIdx,2) * 2;
CNCount = size(segCurveCNR,1) * size(segCurveCNR,2) * size(segCurveCNR,3) * size(segCurveCNR,5) * size(annotationIdx,2) * 2;
MCICount = size(segCurveMCIR,1) * size(segCurveMCIR,2) * size(segCurveMCIR,3) * size(segCurveMCIR,5) * size(annotationIdx,2) * 2;

varTypes = [{'string'};  {'string'};     {'string'};     {'string'};   {'string'};         {'string'}; {'string'};            {'double'}];
varNames = [{'Subject'}; {'Hemisphere'}; {'Image type'}; {'Seg type'}; {'Seg Curve Type'}; {'Group'};  {'Anatomical Region'}; {'Sum of differences'}];
inverseTransformTable = table('Size',[ADCount + CNCount + MCICount, size(varNames, 1)],'VariableTypes', varTypes, 'VariableNames', varNames);

% AD
figure
for i = 1:size(segCurveADR,1)
    ADCurveDiffR(i,:,:,:,:) = (meanSegCurves - squeeze(segCurveADR(i,:,:,:,:))) ./ meanSegCurves;
    ADCurveDiffL(i,:,:,:,:) = (meanSegCurves - squeeze(segCurveADL(i,:,:,:,:))) ./ meanSegCurves;
end

rowIdx = 1;
for subject = 1:size(segCurveADR,1)
totalSumR = zeros(size(annotationIdx,2),1);
totalSumL = zeros(size(annotationIdx,2),1);
for imageType = 1:size(segCurveADR,2)
for segType = 1:size(segCurveADR,3)
for featureType = 1:size(segCurveADR,5)
    % Unsort
    uR(indexesADR(subject,:,imageType,segType,featureType)) = ADCurveDiffR(subject,imageType,segType,:,featureType);
    uL(indexesADL(subject,:,imageType,segType,featureType)) = ADCurveDiffL(subject,imageType,segType,:,featureType);
    %unsortedR(subject, imageType, segType, featureType, :) = uR;
    %unsortedL(subject, imageType, segType, featureType, :) = uL;
    
    % Prepare the diff image
    overlayR = nan(size(ccLabelADR,2), size(ccLabelADR,3));
    overlayL = nan(size(ccLabelADL,2), size(ccLabelADL,3));
    ccLabelR = ccLabelADR(subject,:,:,segType);
    ccLabelL = ccLabelADL(subject,:,:,segType);
    for i = 1:size(uR,2)
        overlayR(ccLabelR == i) = uR(i);
    end
    for i = 1:size(uL,2)
        overlayL(ccLabelL == i) = uL(i);
    end

    % Use source atlas to sum the parts
    for i = 1:size(annotationIdx,2)
        sR = sum(abs(overlayR(srcLabelsADR(subject,:,:) == annotationIdx(i))), 'omitnan') / sum(srcLabelsADR(subject,:,:) == annotationIdx(i), 'all');
        sL = sum(abs(overlayL(srcLabelsADL(subject,:,:) == annotationIdx(i))), 'omitnan') / sum(srcLabelsADL(subject,:,:) == annotationIdx(i), 'all');
        
        inverseTransformTable(rowIdx, :) = { ADList(subject), 'R', dataLabels(imageType), segTypeLabels(segType), featureLabels(featureType), 'AD', annotationLabels(i), sR };
        inverseTransformTable(rowIdx+1, :) = { ADList(subject), 'L', dataLabels(imageType), segTypeLabels(segType), featureLabels(featureType), 'AD', annotationLabels(i), sL };
        rowIdx = rowIdx + 2;

        if ~isnan(sR)
            totalSumR(i) = totalSumR(i) + sR;
        end
        if ~isnan(sL)
            totalSumL(i) = totalSumL(i) + sL;
        end
    end
end
end
end

plot(totalSumR)
hold on
plot(totalSumL)
drawnow

end


% CN
figure
for i = 1:size(segCurveCNR,1)
    CNCurveDiffR(i,:,:,:,:) = (meanSegCurves - squeeze(segCurveCNR(i,:,:,:,:))) ./ meanSegCurves;
    CNCurveDiffL(i,:,:,:,:) = (meanSegCurves - squeeze(segCurveCNL(i,:,:,:,:))) ./ meanSegCurves;
end

for subject = 1:size(segCurveCNR,1)
totalSumR = zeros(size(annotationIdx,2),1);
totalSumL = zeros(size(annotationIdx,2),1);
for imageType = 1:size(segCurveCNR,2)
for segType = 1:size(segCurveCNR,3)
for featureType = 1:size(segCurveCNR,5)
    % Unsort
    uR(indexesCNR(subject,:,imageType,segType,featureType)) = CNCurveDiffR(subject,imageType,segType,:,featureType);
    uL(indexesCNL(subject,:,imageType,segType,featureType)) = CNCurveDiffL(subject,imageType,segType,:,featureType);
    %unsortedR(subject, imageType, segType, featureType, :) = uR;
    %unsortedL(subject, imageType, segType, featureType, :) = uL;
    
    % Prepare the diff image
    overlayR = nan(size(ccLabelCNR,2), size(ccLabelCNR,3));
    overlayL = nan(size(ccLabelCNL,2), size(ccLabelCNL,3));
    ccLabelR = ccLabelCNR(subject,:,:,segType);
    ccLabelL = ccLabelCNL(subject,:,:,segType);
    for i = 1:size(uR,2)
        overlayR(ccLabelR == i) = uR(i);
    end
    for i = 1:size(uL,2)
        overlayL(ccLabelL == i) = uL(i);
    end

    % Use source atlas to sum the parts
    for i = 1:size(annotationIdx,2)
        sR = sum(abs(overlayR(srcLabelsCNR(subject,:,:) == annotationIdx(i))), 'omitnan') / sum(srcLabelsCNR(subject,:,:) == annotationIdx(i), 'all');
        sL = sum(abs(overlayL(srcLabelsCNL(subject,:,:) == annotationIdx(i))), 'omitnan') / sum(srcLabelsCNL(subject,:,:) == annotationIdx(i), 'all');
        
        inverseTransformTable(rowIdx, :) = { CNList(subject), 'R', dataLabels(imageType), segTypeLabels(segType), featureLabels(featureType), 'CN', annotationLabels(i), sR };
        inverseTransformTable(rowIdx+1, :) = { CNList(subject), 'L', dataLabels(imageType), segTypeLabels(segType), featureLabels(featureType), 'CN', annotationLabels(i), sL };
        rowIdx = rowIdx + 2;

        if ~isnan(sR)
            totalSumR(i) = totalSumR(i) + sR;
        end
        if ~isnan(sL)
            totalSumL(i) = totalSumL(i) + sL;
        end
    end
end
end
end

plot(totalSumR)
hold on
plot(totalSumL)
drawnow

end

% MCI
figure
for i = 1:size(segCurveMCIR,1)
    MCICurveDiffR(i,:,:,:,:) = (meanSegCurves - squeeze(segCurveMCIR(i,:,:,:,:))) ./ meanSegCurves;
    MCICurveDiffL(i,:,:,:,:) = (meanSegCurves - squeeze(segCurveMCIL(i,:,:,:,:))) ./ meanSegCurves;
end

for subject = 1:size(segCurveMCIR,1)
totalSumR = zeros(size(annotationIdx,2),1);
totalSumL = zeros(size(annotationIdx,2),1);
for imageType = 1:size(segCurveMCIR,2)
for segType = 1:size(segCurveMCIR,3)
for featureType = 1:size(segCurveMCIR,5)
    % Unsort
    uR(indexesMCIR(subject,:,imageType,segType,featureType)) = MCICurveDiffR(subject,imageType,segType,:,featureType);
    uL(indexesMCIL(subject,:,imageType,segType,featureType)) = MCICurveDiffL(subject,imageType,segType,:,featureType);
    %unsortedR(subject, imageType, segType, featureType, :) = uR;
    %unsortedL(subject, imageType, segType, featureType, :) = uL;
    
    % Prepare the diff image
    overlayR = nan(size(ccLabelMCIR,2), size(ccLabelMCIR,3));
    overlayL = nan(size(ccLabelMCIL,2), size(ccLabelMCIL,3));
    ccLabelR = ccLabelMCIR(subject,:,:,segType);
    ccLabelL = ccLabelMCIL(subject,:,:,segType);
    for i = 1:size(uR,2)
        overlayR(ccLabelR == i) = uR(i);
    end
    for i = 1:size(uL,2)
        overlayL(ccLabelL == i) = uL(i);
    end
    % Use source atlas to sum the parts
    for i = 1:size(annotationIdx,2)
        sR = sum(abs(overlayR(srcLabelsMCIR(subject,:,:) == annotationIdx(i))), 'omitnan') / sum(srcLabelsMCIR(subject,:,:) == annotationIdx(i), 'all');
        sL = sum(abs(overlayL(srcLabelsMCIL(subject,:,:) == annotationIdx(i))), 'omitnan') / sum(srcLabelsMCIL(subject,:,:) == annotationIdx(i), 'all');
        
        inverseTransformTable(rowIdx, :) = { MCIList(subject), 'R', dataLabels(imageType), segTypeLabels(segType), featureLabels(featureType), 'MCI', annotationLabels(i), sR };
        inverseTransformTable(rowIdx+1, :) = { MCIList(subject), 'L', dataLabels(imageType), segTypeLabels(segType), featureLabels(featureType), 'MCI', annotationLabels(i), sL };
        rowIdx = rowIdx + 2;

        if ~isnan(sR)
            totalSumR(i) = totalSumR(i) + sR;
        end
        if ~isnan(sL)
            totalSumL(i) = totalSumL(i) + sL;
        end
    end
end
end
end

plot(totalSumR)
hold on
plot(totalSumL)
drawnow

end
%%

curveIdxR =reshape([sourceR.sortIdx], [], size(sourceR,1),size(sourceR,2),size(sourceR,3),size(sourceR,4));

ADdiffSample = squeeze(ADdiff(:,1,1,1));
curveIdxRSample = squeeze(curveIdxR(:,15,1,1,1));

unsorted(curveIdxRSample) = ADdiffSample;

labelSample = ccLabelsR(:,:,15,1);
imageSample = allData(:,:,1,15);

overlayR = zeros(imageSize(1), imageSize(2));
for i = 1:size(unsorted,2)
    overlayR(labelSample == i) = unsorted(i);
end

[tc, td] = convertFromMollweide(overlayR);
[tlc, trc, ~, ~, ~, tln, trn] = freesurferData(all(15));
tid = freesurferDataWrite('test', tc, td, trc, trn);
