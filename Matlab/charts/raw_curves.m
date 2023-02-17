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

for featureLabel = 1:size(allCurvesR,5)
    figure('Name',featureLabels(featureLabel))
    hF = gcf;
    hF.Position(3:4) = [600 400];
for segTypeLabel = 1:size(allCurvesR,3)
for imageType = 1:size(allCurvesR,2)
    subplot(2,3,(segTypeLabel-1)*size(allCurvesR,2) + imageType)
    title(strcat(dataLabels(imageType), "-", segTypeLabelsShort(segTypeLabel)))
    hold on
    allCurves = cat(6, ...
        allCurvesR(:,imageType,segTypeLabel,:,featureLabel), ...
        allCurvesL(:,imageType,segTypeLabel,:,featureLabel));

    for subject = 1 : size(allCurves, 1)
        v = [squeeze(allCurves(subject,:,:,:,:,1)); squeeze(allCurves(subject,:,:,:,:,2))];
        if subject <= size(CNList,1)
            subjectGroup = 'CN';
            color = 'b--';
        elseif subject <= (size(CNList,1) + size(ADList,1))
            subjectGroup = 'AD';
            color = 'r-.';
        else
            subjectGroup = 'MCI';
            color = 'm--';
            continue
        end
        plot(sort(v(:), 'descend'), color)
    end
    hold off
end
end
end