function [lhCoords, rhCoords, lhData, rhData, dataLabels, lhNumFaces, rhNumFaces] = freesurferData(directory)
%freesurferData Reads all the relevant data from a freesurfer study
% directory
%   coords - N*3 XYZ coordinates of the hemisphere data
%   data - N*M where M is the number of various data (thickness, area, volume)
%   dataLabels - array of labels of the data

[lhCoords, lhData, lhNumFaces] = hemisphere(directory, 'l');
[rhCoords, rhData, rhNumFaces] = hemisphere(directory, 'r');
dataLabels = ["Curvature" "Area" "Volume" "Labels"];
end

function [coords, data, numFaces] = hemisphere(directory, hemisphere)

[coords, ~] = read_surf(strcat(directory, 'surf/', hemisphere, 'h.sphere'));
[curv, numFaces] = read_curv(strcat(directory, 'surf/', hemisphere, 'h.curv'));
[area, ~] = read_curv(strcat(directory, 'surf/', hemisphere, 'h.area'));
[volume, ~] = read_curv(strcat(directory, 'surf/', hemisphere, 'h.volume'));
[~, label, ~] = read_annotation(strcat(directory, 'label/', hemisphere, 'h.aparc.annot'));

data = zeros(size(coords, 1),4);
data(:,1) = curv;
data(:,2) = area;
data(:,3) = volume;
data(:,4) = label;

end