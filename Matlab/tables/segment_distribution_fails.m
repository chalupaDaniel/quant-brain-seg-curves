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
        AllDataR(nonfailCounter, :,:,:) = dataR(:,:,1:3);
        AllDataL(nonfailCounter, :,:,:) = dataL(:,:,1:3);
        nonfailCounter = nonfailCounter + 1;
    catch
            disp('FAIL')
        disp(subjectDir)
    end
    
end
end



varTypes = [{'string'};  {'string'};{'string'};     {'string'};  {'string'};       {'string'};   {'double'};];
varNames = [{'Subject'}; {'Group'}; {'Hemisphere'}; {'Feature'}; {'Distribution'}; {'Seg type'}; {'Failure rate'};];
distributionTable = table('Size',[0 size(varNames, 1)],'VariableTypes', varTypes, 'VariableNames', varNames);

allNames = [ CNList; ADList; MCIList ];

for segType = 1:2
for imageType = 1:size(AllDataR, 4)
for distributionId = 1:size(distributionLabels,2)
    totalSegments = 0;
    totalFails = 0;
for i = 1:size(AllDataR,1)
    if i <= size(CNList,1)
        subjectGroup = 'CN';
    elseif i <= (size(CNList,1) + size(ADList,1))
        subjectGroup = 'AD';
    else
        subjectGroup = 'MCI';
    end
    data = squeeze(AllDataR(i,:,:,1:3));
    ccLabeled = zeros(size(data,1), size(data,2));

    image = data(:,:,1);
    if segTypeLabels(segType) == "Positive Curvature"
       seg = segmentImage(image);
    elseif segTypeLabels(segType) == "Negative Curvature"
       seg = segmentImage(-1*image);
    end
    cc = bwconncomp(seg,8);
    ccNums = cc.NumObjects;
    ccLabeled(:,:) = labelmatrix(cc);

    localData = data(:,:,imageType);

    [~, sizes, ~, ~, ~, fails] = imageToSegCurve(localData, ccNums, ccLabeled, distributionLabels(distributionId), false);
    totalSegments = totalSegments + size(sizes, 1);
    totalFails = totalFails + (fails * size(sizes, 1)) / 100;
    distributionTable = [distributionTable; { allNames(i), subjectGroup, 'R', dataLabels(imageType), distributionLabels(distributionId), segTypeLabels(segType), fails }];

    data = squeeze(AllDataL(i,:,:,1:3));
    ccLabeled = zeros(size(data,1), size(data,2));

    image = data(:,:,1);
    if segTypeLabels(segType) == "Positive Curvature"
       seg = segmentImage(image);
    elseif segTypeLabels(segType) == "Negative Curvature"
       seg = segmentImage(-1*image);
    end
    cc = bwconncomp(seg,8);
    ccNums = cc.NumObjects;
    ccLabeled(:,:) = labelmatrix(cc);

    localData = data(:,:,imageType);

    [~, sizes, ~, ~, ~, fails] = imageToSegCurve(localData, ccNums, ccLabeled, distributionLabels(distributionId), false);
    totalSegments = totalSegments + size(sizes, 1);
    totalFails = totalFails + (fails * size(sizes, 1)) / 100;
    distributionTable = [distributionTable; { allNames(i), subjectGroup, 'L', dataLabels(imageType), distributionLabels(distributionId), segTypeLabels(segType), fails }];
    
    %disp(distributionTable(end-1:end,:))
end
    segTypeShort = "";
    if segTypeLabels(segType) == "Positive Curvature"
       segTypeShort = "P";
    elseif segTypeLabels(segType) == "Negative Curvature"
       segTypeShort = "N";
    end
   disp(strcat(dataLabels(imageType), "-", segTypeShort, " ", distributionLabels(distributionId), ": ", num2str(totalFails/totalSegments)))
end
end
end