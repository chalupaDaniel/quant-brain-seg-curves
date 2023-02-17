function [vertexCoords, data] = convertFromMollweide(im)
% convertToMollweide Converts the supplied data from spherical to mollweide
% coordinates
%   vertexCoords is an Nx3 matrix defining xyz position for each vertex
%   imageSize = [ height width ] is the output image size
%   data is an NxM matrix with M values for each of the N vertices
%   decimation is useful for testing, it selects each decimation-th point

% A little geographic help below
% lon ->
% lat ^
m_proj('Mollweide', 'lon', [-180 180], 'lat', [-90 90]);

lons = nan(size(im,1)*size(im,2),1);
lats = nan(size(im,1)*size(im,2),1);
data = nan(size(im,1)*size(im,2),1);
for x = 1:size(im,2)
    startIndex = (x - 1) * size(im,1);
    for y = 1:size(im,1)
        [lon, lat] = m_xy2ll((4 * x / size(im,2)) - 2, (2 * y / size(im,1)) - 1);
        lons(startIndex + y) = lon;
        lats(startIndex + y) = lat;
        data(startIndex + y) = im(y,x);
    end
end

S = referenceSphere; % A unit sphere

[X,Y,Z] = geodetic2ecef(S,lons,lats,0);
vertexCoords = 100*[X';Y';Z']';

end