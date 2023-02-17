function [fitresult, gof, source] = fitSegCurve(segCurve, fitType)
% gauss6

[source.curve, source.sortIdx] = sort(squeeze(segCurve), 'Descend', 'MissingPlacement', 'last');
testCurve = source.curve;
testCurve(isnan(testCurve)) = [];

if (strcmp(fitType,'Weibull'))
    testCurve = testCurve - min(testCurve, [], 'all');
    testCurve(testCurve==0) = eps;
end

x = 1:size(testCurve);
[source.x, source.y] = prepareCurveData( x, testCurve' );

% Set up fittype and options.
ft = fittype( fitType );

if (~contains(fitType,'Poly'))
    opts = fitoptions( 'Method', 'NonlinearLeastSquares' );
    opts.Display = 'Off';
    opts.Normalize = 'Off';
    
    if (strcmp(fitType,'Weibull'))
        opts.StartPoint = [0 0];
    end
else
    opts = fitoptions( 'Method', 'LinearLeastSquares' );
    opts.Normalize = 'On';
end


if (contains(fitType,'gauss'))
if (contains(fitType,'6'))
    opts.Lower = [-Inf -Inf 0 -Inf -Inf 0 -Inf -Inf 0 -Inf -Inf 0 -Inf -Inf 0 -Inf -Inf 0];
elseif (contains(fitType,'5'))
    opts.Lower = [-Inf -Inf 0 -Inf -Inf 0 -Inf -Inf 0 -Inf -Inf 0 -Inf -Inf 0];
end
end

% Fit model to data.

[fitresult, gof] = fit( source.x, source.y, ft, opts );