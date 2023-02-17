function [image] = convertToMollweide(vertexCoords, data, imageSize, decimation)
% convertToMollweide Converts the supplied data from spherical to mollweide
% coordinates
%   vertexCoords is an Nx3 matrix defining xyz position for each vertex
%   imageSize = [ height width ] is the output image size
%   data is an NxM matrix with M values for each of the N vertices
%   decimation is useful for testing, it selects each decimation-th point

S = referenceSphere; % A unit sphere

% It might also be cleaner to scale the vertexCoords to match the unit
% sphere, but it seems like it doesn't matter

dataDec = data(1:decimation:end, :);
xDec = vertexCoords(1:decimation:end,1);
yDec = vertexCoords(1:decimation:end,2);
zDec = vertexCoords(1:decimation:end,3);

% A little geographic help below
% lon ->
% lat ^
[lat,lon,~] = ecef2geodetic(S,xDec, yDec, zDec);

m_proj('Mollweide', 'lon', [-180 180], 'lat', [-90 90]);
[X,Y]=m_ll2xy(lon,lat);
minX = min(X);
maxX = max(X);
minY = min(Y);
maxY = max(Y);

image = zeros([imageSize, size(dataDec, 2)]);

for i = 1:size(data,2)
    F{i} = scatteredInterpolant(X,Y,dataDec(:,i));
    F{i}.ExtrapolationMethod = 'none';
    F{i}.Method = 'nearest';
end

for i = 1:imageSize(1)
    for j = 1:imageSize(2)
        thisX = (maxX - minX) * (j / (imageSize(2))) + minX;
        thisY = (maxY - minY) * (i / (imageSize(1))) + minY;
        
        for k = 1:size(data,2)
            interpolator = F{k};
            image(i,j,k) = interpolator(thisX, thisY);
        end
    end
end

end