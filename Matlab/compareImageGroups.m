function [cors, chis, intersects, bhats] = compareImageGroups(groupA, groupB, histLimits)
% compareImageGroups
% group(A,B) - matrix individual x imageX x imageY
% histLimits - [low; high]
% outputs are vectors with elements groupA(1) vs groupB(1);
%                                   groupA(2) vs groupB(1);
%                                   ...,
%                                   groupA(end) vs groupB(end - 1);
%                                   groupA(end) vs groupB(end);

same = isequaln(groupA, groupB); % If both groups are equal, the computation cost can be cut in half

binCount = 2048;

cors = NaN(size(groupA, 1), size(groupB, 1));
chis = NaN(size(groupA, 1), size(groupB, 1));
intersects = NaN(size(groupA, 1), size(groupB, 1));
bhats = NaN(size(groupA, 1), size(groupB, 1));

for i = 1:size(groupA, 1)    
    for j = 1:size(groupB, 1)
        if same && (i >= j)
            continue
        end
        [cors(i,j),chis(i,j),intersects(i,j),bhats(i,j)] = compareImages(groupA(i,:,:), groupB(j,:,:), histLimits(1), histLimits(2), binCount);
    end
end

end