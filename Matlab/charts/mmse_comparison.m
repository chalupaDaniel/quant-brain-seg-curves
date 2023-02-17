analyses_init;

%%

inverseTable = readtable('inverseTransform.xlsx');
mmseData = readtable('MMSE.csv'); % RID is the last number part of subject string, i.e. 006_S_4867

%%


[xsAD,ysAD] = getDiffAndMMSE(ADList, inverseTable, mmseData);
[xsCN,ysCN] = getDiffAndMMSE(CNList, inverseTable, mmseData);
[xsMCI,ysMCI] = getDiffAndMMSE(MCIList, inverseTable, mmseData);

figure
scatter(xsAD,ysAD,'r')
hold on

scatter(xsCN,ysCN, 'b')
scatter(xsMCI,ysMCI,'c')

function [xs, ys] = getDiffAndMMSE(list, tableOfDiffs, tableOfMMSE)

xs = zeros(size(list,1),1);
ys = zeros(size(list,1),1);

for subject = 1:size(list,1)
    subjectID = str2num(extractAfter(list(subject), regexpPattern('_.*_')));
    differences = tableOfDiffs{endsWith(tableOfDiffs.Subject,list(subject)) & ((...
        contains(tableOfDiffs.SegType,'Positive Curvature') & ...
        contains(tableOfDiffs.ImageType,regexpPattern('Volume|Curvature')) & ...
        contains(tableOfDiffs.SegCurveType,'Mean')) | ...
        (contains(tableOfDiffs.SegType,'Positive Curvature') & contains(tableOfDiffs.SegCurveType,'Sum') ) | ...
        (contains(tableOfDiffs.SegType,'Negative Curvature') & contains(tableOfDiffs.SegCurveType,'Px cnt') ) ...
        ) &  contains(tableOfDiffs.AnatomicalRegion,regexpPattern('frontalpole|insula|parsorbitalis|posteriorcingulate')) ,8};
    mmses = tableOfMMSE{tableOfMMSE.RID == subjectID,57};
    
    xs(subject) = mean(mmses);
    ys(subject) = mean(differences, 'omitnan');
    
end
end
