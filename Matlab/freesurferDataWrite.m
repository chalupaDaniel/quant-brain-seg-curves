function [interpolatedData] = freesurferDataWrite(fname, coords, data, targetCoords, fnum)


F = scatteredInterpolant(coords(:,1), coords(:,2), coords(:,3), data);
F.ExtrapolationMethod = 'none';
F.Method = 'nearest';

interpolatedData = zeros(size(targetCoords,1),1);
for r = 1:size(targetCoords,1)
    interpolatedData(r) = F(targetCoords(r,1), targetCoords(r,2), targetCoords(r,3));
end

write_curv(fname, interpolatedData, fnum); 

end