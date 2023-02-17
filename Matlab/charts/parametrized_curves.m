analyses_init;

%% Load data
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

%% Plot
% Based on SUM
% CN - AD: 
% Volume	Positive Curvature	Std dev	b4
% Volume	Positive Curvature	Median	a6
% Volume	Positive Curvature	Sum	b2

% CN - MCI
% Volume	Positive Curvature	Median	a6
% Volume	Positive Curvature	Mean	b4
% Volume	Positive Curvature	Median	b3

% AD - MCI
% Volume	Negative Curvature	Std dev	c5
% Area      Negative Curvature	Sum	a2
% Volume	Positive Curvature	Sum	b2



CNAD_CN = [...
    cellfun(@(x) x.b4, reshape([fitCNL(:,3,1,4); fitCNR(:,3,1,4)], [], 1)) ...
    cellfun(@(x) x.a6, reshape([fitCNL(:,3,1,5); fitCNR(:,3,1,5)], [], 1)) ...
    cellfun(@(x) x.b2, reshape([fitCNL(:,3,1,1); fitCNR(:,3,1,1)], [], 1)) ];

CNAD_AD = [...
    cellfun(@(x) x.b4, reshape([fitADL(:,3,1,4); fitADR(:,3,1,4)], [], 1)) ...
    cellfun(@(x) x.a6, reshape([fitADL(:,3,1,5); fitADR(:,3,1,5)], [], 1)) ...
    cellfun(@(x) x.b2, reshape([fitADL(:,3,1,1); fitADR(:,3,1,1)], [], 1)) ];

CNMCI_CN = [...
    cellfun(@(x) x.a6, reshape([fitCNL(:,3,1,5); fitCNR(:,3,1,5)], [], 1)) ...
    cellfun(@(x) x.b4, reshape([fitCNL(:,3,1,3); fitCNR(:,3,1,3)], [], 1)) ...
    cellfun(@(x) x.b3, reshape([fitCNL(:,3,1,5); fitCNR(:,3,1,5)], [], 1)) ];

CNMCI_MCI = [...
    cellfun(@(x) x.a6, reshape([fitMCIL(:,3,1,5); fitMCIR(:,3,1,5)], [], 1)) ...
    cellfun(@(x) x.b4, reshape([fitMCIL(:,3,1,3); fitMCIR(:,3,1,3)], [], 1)) ...
    cellfun(@(x) x.b3, reshape([fitMCIL(:,3,1,5); fitMCIR(:,3,1,5)], [], 1)) ];

ADMCI_AD = [...
    cellfun(@(x) x.c5, reshape([fitADL(:,3,2,4); fitADR(:,3,2,4)], [], 1)) ...
    cellfun(@(x) x.a2, reshape([fitADL(:,2,2,1); fitADR(:,2,2,1)], [], 1)) ...
    cellfun(@(x) x.b2, reshape([fitADL(:,3,1,1); fitADR(:,3,1,1)], [], 1)) ];

ADMCI_MCI = [...
    cellfun(@(x) x.c5, reshape([fitMCIL(:,3,2,4); fitMCIR(:,3,2,4)], [], 1)) ...
    cellfun(@(x) x.a2, reshape([fitMCIL(:,2,2,1); fitMCIR(:,2,2,1)], [], 1)) ...
    cellfun(@(x) x.b2, reshape([fitMCIL(:,3,1,1); fitMCIR(:,3,1,1)], [], 1)) ];

%{
figure
% scatter3(log(CNAD_AD(:,1)), log(CNAD_AD(:,2)), log(CNAD_AD(:,3)),'ro')
% hold on
% scatter3(log(CNAD_CN(:,1)), log(CNAD_CN(:,2)), log(CNAD_CN(:,3)),'bo')

figure
scatter3(log(CNMCI_CN(:,1)), log(CNMCI_CN(:,2)), log(CNMCI_CN(:,3)),'ro')
hold on
scatter3(log(CNMCI_MCI(:,1)), log(CNMCI_MCI(:,2)), log(CNMCI_MCI(:,3)),'bo')

figure
scatter3(log(ADMCI_AD(:,1)), log(ADMCI_AD(:,2)), log(ADMCI_AD(:,3)),'ro')
hold on
scatter3(log(ADMCI_MCI(:,1)), log(ADMCI_MCI(:,2)), log(ADMCI_MCI(:,3)),'bo')
%}

figure('Name', 'CNAD')
boxplotAB(CNAD_CN, CNAD_AD, 'CN', 'AD', ' Vol P Std b4', 'Vol P Med a6', 'Vol P Sum b2')
figure('Name', 'CNMCI')
boxplotAB(CNMCI_CN, CNMCI_MCI, 'CN', 'MCI', 'Vol P Med a6', 'Vol P Mean b4', 'Vol P Med b3')
figure('Name', 'ADMCI')
boxplotAB(ADMCI_AD, ADMCI_MCI, 'AD', 'MCI', 'Vol N Std c5', 'Area N Sum a2', 'Vol P Sum b2')

function boxplotAB(A, B, lA, lB, lOne, lTwo, lThree)

    g1 = ones(size(A(:,1))) * 1;
    g2 = ones(size(B(:,1))) * 2;

    subplot(1,3,1)
    boxplot([A(:,1); B(:,1)], [g1;g2], 'Labels', {[lA lOne], [lB lOne]})
    subplot(1,3,2)
    boxplot([A(:,2); B(:,2)], [g1;g2], 'Labels', {[lA lTwo], [lB lTwo]})
    subplot(1,3,3)
    boxplot([A(:,3); B(:,3)], [g1;g2], 'Labels', {[lA lThree], [lB lThree]})
end
