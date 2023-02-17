analyses_init;

%% Load data
dirList = ["../../data/subjects/CN"; "../../data/subjects/AD"; "../../data/subjects/MCI"];

for dirId = 1:size(dirList,1)
    subDirList = dir(dirList(dirId));
    nonfailCounter = 1; % Lazy
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
      imshow(squeeze(ccLabelsL(:,:,2)),[])
        if contains(subjectDir, CNList)
            CNDataR(nonfailCounter, :,:,:) = dataR(:,:,1:3);
            CNDataL(nonfailCounter, :,:,:) = dataL(:,:,1:3);
        elseif contains(subjectDir, ADList)
            ADDataR(nonfailCounter, :,:,:) = dataR(:,:,1:3);
            ADDataL(nonfailCounter, :,:,:) = dataL(:,:,1:3);
        elseif contains(subjectDir, MCIList)
            MCIDataR(nonfailCounter, :,:,:) = dataR(:,:,1:3);
            MCIDataL(nonfailCounter, :,:,:) = dataL(:,:,1:3);
        end
        nonfailCounter = nonfailCounter + 1;
    catch
            disp('FAIL')
        disp(subjectDir)
    end
    
end
end

allData = cat(1, CNDataR, ADDataR, MCIDataR, CNDataL, ADDataL, MCIDataL);

%%

limitsDown(1:3) = prctile(allData,1, [1 2 3]);
limitsUp(1:3) = prctile(allData,99, [1 2 3]);

varTypes = [{'string'};    {'string'};  {'string'};    {'string'};  {'string'};     {'string'}; {'double'};   {'double'};{'double'};  {'double'};];
varNames = [{'Subject A'}; {'A Group'}; {'Subject B'}; {'B Group'}; {'Hemisphere'}; {'Feature'}; {'Pearson'}; {'Chi'}; {'Intersect'}; {'Bhat'}];
comparisonTable = table('Size',[0 size(varNames, 1)],'VariableTypes', varTypes, 'VariableNames', varNames);

for hemisphere = 1:2
    if hemisphere == 1
        ADData = ADDataR;
        CNData = CNDataR;
        MCIData = MCIDataR;
    else
        ADData = ADDataL;
        CNData = CNDataL;
        MCIData = MCIDataL;
    end
    for feature = 1:size(CNDataR,4)

        [cors, chis, intersects,bhats] = compareImageGroups(ADData(:,:,:,feature), ADData(:,:,:,feature), [limitsDown(feature); limitsUp(feature)]);
        comparisonTable = writeComparisonsToTable(comparisonTable, ADList, "AD", ADList, "AD", hemisphereLabels(hemisphere), dataLabels(feature), cors, chis, intersects, bhats);
        [cors, chis, intersects,bhats] = compareImageGroups(ADData(:,:,:,feature), CNData(:,:,:,feature), [limitsDown(feature); limitsUp(feature)]);
        comparisonTable = writeComparisonsToTable(comparisonTable, ADList, "AD", CNList, "CN", hemisphereLabels(hemisphere), dataLabels(feature), cors, chis, intersects, bhats);
        [cors, chis, intersects,bhats] = compareImageGroups(ADData(:,:,:,feature), MCIData(:,:,:,feature), [limitsDown(feature); limitsUp(feature)]);
        comparisonTable = writeComparisonsToTable(comparisonTable, ADList, "AD", MCIList, "MCI", hemisphereLabels(hemisphere), dataLabels(feature), cors, chis, intersects, bhats);
        
        [cors, chis, intersects,bhats] = compareImageGroups(CNData(:,:,:,feature), CNData(:,:,:,feature), [limitsDown(feature); limitsUp(feature)]);
        comparisonTable = writeComparisonsToTable(comparisonTable, CNList, "CN", CNList, "CN", hemisphereLabels(hemisphere), dataLabels(feature), cors, chis, intersects, bhats);
        [cors, chis, intersects,bhats] = compareImageGroups(CNData(:,:,:,feature), MCIData(:,:,:,feature), [limitsDown(feature); limitsUp(feature)]);
        comparisonTable = writeComparisonsToTable(comparisonTable, CNList, "CN", MCIList, "MCI", hemisphereLabels(hemisphere), dataLabels(feature), cors, chis, intersects, bhats);

        [cors, chis, intersects,bhats] = compareImageGroups(MCIData(:,:,:,feature), MCIData(:,:,:,feature), [limitsDown(feature); limitsUp(feature)]);
        comparisonTable = writeComparisonsToTable(comparisonTable, MCIList, "MCI", MCIList, "MCI", hemisphereLabels(hemisphere), dataLabels(feature), cors, chis, intersects, bhats);
    end
end