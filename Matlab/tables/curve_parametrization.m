analyses_init;

% Load data
dirList = ["../../data/subjects/CN"; "../../data/subjects/AD"; "../../data/subjects/MCI"];

nonfailCounter = 1; % Lazy
for dirId = 1:size(dirList,1)
    subDirList = dir(dirList(dirId));
for i = 1:size(subDirList,1)
    try
        if strcmp(subDirList(i).name, '.') || strcmp(subDirList(i).name,'..')
            continue
        end
        subjectDir = [ subDirList(i).folder '/' subDirList(i).name '/' ];
        %disp(subjectDir)
        targetDir = [ subDirList(i).folder '/' subDirList(i).name '/matlab/' ];
        [dataR, dataL, dataLabels, ...
          segCurveR, segCurveL, ccLabelsR, ccLabelsL, failuresR, failuresL, segmentationTypes, ...
          gofR, fitR, sourceR, gofL, fitL, sourceL] = run_all( subjectDir, targetDir, [360 720], 'gauss6', 0);
        allCurvesR(nonfailCounter, :,:,:,:) = segCurveR;
        allCurvesL(nonfailCounter, :,:,:,:) = segCurveL;
        nonfailCounter = nonfailCounter + 1;
    catch
            disp('FAIL')
        disp(subjectDir)
    end
    
end
end

varTypes = [{'string'};  {'string'};{'string'};     {'string'};  {'string'}; {'string'};   {'string'};         {'double'}; {'double'}; {'double'}; {'double'}; {'double'}];
varNames = [{'Subject'}; {'Group'}; {'Hemisphere'}; {'Feature'}; {'Model'};  {'Seg type'}; {'Seg Curve Type'}; {'r2'};     {'sse'};    {'dfe'};    {'adjr2'};  {'rmse'}];
fitTable = table('Size',[0 size(varNames, 1)],'VariableTypes', varTypes, 'VariableNames', varNames);

allNames = [ CNList; ADList; MCIList ];

for segType = 1:size(allCurvesR,3)
    segTypeShort = "";
    if segTypeLabels(segType) == "Positive Curvature"
       segTypeShort = "P";
    elseif segTypeLabels(segType) == "Negative Curvature"
       segTypeShort = "N";
    end

for imageType = 1:size(allCurvesR,2)
for featureType = 1:size(allCurvesR,5)
for modelId = 1:size(modelLabels,2)
    r2s = zeros(size(allCurvesR,1)*2,1);
    ssse = 0;
    dfes = zeros(size(allCurvesR,1)*2,1);
    adjr2s = zeros(size(allCurvesR,1)*2,1);
    rmses = zeros(size(allCurvesR,1)*2,1);
for i = 1:size(allCurvesR,1)
    if i <= size(CNList,1)
        subjectGroup = 'CN';
    elseif i <= (size(CNList,1) + size(ADList,1))
        subjectGroup = 'AD';
    else
        subjectGroup = 'MCI';
    end

    [fitR, gofR, sourceR] = fitSegCurve(allCurvesR(i, imageType, segType, :, featureType), modelLabels(modelId));
    [fitL, gofL, sourceL] = fitSegCurve(allCurvesL(i, imageType, segType, :, featureType), modelLabels(modelId));
    
    fitTable = [fitTable; { allNames(i), subjectGroup, 'R', dataLabels(imageType), modelLabels(modelId), segTypeLabels(segType), featureLabels(featureType) ...
        gofR.rsquare, gofR.sse, gofR.dfe, gofR.adjrsquare, gofR.rmse }];
    fitTable = [fitTable; { allNames(i), subjectGroup, 'L', dataLabels(imageType), modelLabels(modelId), segTypeLabels(segType), featureLabels(featureType) ... 
        gofL.rsquare, gofL.sse, gofL.dfe, gofL.adjrsquare, gofL.rmse }];

    ssse = ssse + gofL.sse + gofR.sse;
    r2s(i) = gofR.rsquare;
    r2s(i + size(allCurvesR,1)) = gofL.rsquare;
    dfes(i) = gofR.dfe;
    dfes(i + size(allCurvesR,1)) = gofL.dfe;
    adjr2s(i) = gofR.adjrsquare;
    adjr2s(i + size(allCurvesR,1)) = gofL.adjrsquare;
    rmses(i) = gofR.rmse;
    rmses(i + size(allCurvesR,1)) = gofL.rmse;
end
    disp(strcat( ...
        dataLabels(imageType), "-", segTypeShort, " ", ...
        featureLabels(featureType), " ", ...
        modelLabels(modelId), " ", ...
        num2str(ssse, '%.2e'), " ", ...
        num2str(mean(r2s), '%.2f'), " (+-", num2str(std(r2s), '%.2f'), ")"...
    ));
end
end
end
end
