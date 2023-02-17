analyses_init;

% Load data
nonfailCounter = 1; % Lazy
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
        fitCNR(nonfailCounter, :,:,:,:) = fitR;
        fitCNL(nonfailCounter, :,:,:,:) = fitL;
        nonfailCounter = nonfailCounter + 1;
    catch
            disp('FAIL')
        disp(subjectDir)
    end
    
end

nonfailCounter = 1; % Lazy
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
        fitADR(nonfailCounter, :,:,:,:) = fitR;
        fitADL(nonfailCounter, :,:,:,:) = fitL;
        nonfailCounter = nonfailCounter + 1;
    catch
            disp('FAIL')
        disp(subjectDir)
    end
    
end

nonfailCounter = 1; % Lazy
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
        fitMCIR(nonfailCounter, :,:,:,:) = fitR;
        fitMCIL(nonfailCounter, :,:,:,:) = fitL;
        nonfailCounter = nonfailCounter + 1;
    catch
            disp('FAIL')
        disp(subjectDir)
    end
    
end

varTypes = [{'string'};  {'string'};   {'string'};         {'string'}; {'double'}; {'double'}; {'double'};];
varNames = [{'Feature'}; {'Seg type'}; {'Seg Curve Type'}; {'Param'};  {'CN-AD'};  {'CN-MCI'}; {'AD-MCI'};];
paramDiffTable = table('Size',[0 size(varNames, 1)],'VariableTypes', varTypes, 'VariableNames', varNames);

for segType = 1:size(fitCNR,3)
    segTypeShort = "";
    if segTypeLabels(segType) == "Positive Curvature"
       segTypeShort = "P";
    elseif segTypeLabels(segType) == "Negative Curvature"
       segTypeShort = "N";
    end

for imageType = 1:size(fitCNR,2)
for featureType = 1:size(fitCNR,4)
    cfNames = coeffnames(fitCNL{1,1,1,1});
    for cfNameId = 1:size(cfNames,1)
        paramCN = cellfun(@(x) x.(cfNames{cfNameId}), [fitCNL(:,imageType,segType,featureType); fitCNR(:,imageType,segType,featureType)]);
        paramAD = cellfun(@(x) x.(cfNames{cfNameId}), [fitADL(:,imageType,segType,featureType); fitADR(:,imageType,segType,featureType)]);
        paramMCI = cellfun(@(x) x.(cfNames{cfNameId}), [fitMCIL(:,imageType,segType,featureType); fitMCIR(:,imageType,segType,featureType)]);
        
        % P0 = same distribution
        % low p = P0 fails, different distribution
        [~,pCNAD] = kstest2(paramCN, paramAD);
        [~,pCNMCI] = kstest2(paramCN, paramMCI);
        [~,pADMCI] = kstest2(paramAD, paramMCI);

        paramDiffTable = [paramDiffTable; { dataLabels(imageType), segTypeLabels(segType), featureLabels(featureType) ... 
            cfNames{cfNameId}, pCNAD, pCNMCI, pADMCI}];

        if ( pCNAD + pCNMCI + pADMCI ) <= 0.4
            g1 = ones(size(paramCN)) * 1;
            g2 = ones(size(paramAD)) * 2;
            g3 = ones(size(paramMCI)) * 3;
            figure()
            boxplot([paramCN; paramAD; paramMCI], [g1; g2; g3], 'Labels', {'CN', 'AD', 'MCI'}, 'OutlierSize',2)
            title(strcat( ...
            pad(strcat(dataLabels(imageType), "-", segTypeShort, " "), 13), ...
            pad(featureLabels(featureType), 6), " ", ...
            cfNames{cfNameId}))
        end
        disp(strcat( ...
            pad(strcat(dataLabels(imageType), "-", segTypeShort, " "), 13), ...
            pad(featureLabels(featureType), 6), " ", ...
            cfNames{cfNameId}, " ", ...
            num2str(pCNAD, '%.3f'), " ", ...
            num2str(pCNMCI, '%.3f'), " ", ...
            num2str(pADMCI, '%.3f') ...
        ));
    end
end
end
end