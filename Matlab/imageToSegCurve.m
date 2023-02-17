function [sums, sizes, means, stds, medians, normFails] = imageToSegCurve(image, ccNum, ccLabeled, distname, cinematic)
%IMAGETOSEGCURVE Summary of this function goes here
%   Detailed explanation goes here

    sums = zeros(ccNum,1);
    sizes = zeros(ccNum,1);
    stds = zeros(ccNum,1);
    means = zeros(ccNum,1);
    medians = zeros(ccNum,1);
    notnormal = 0;
    
    if (cinematic)
        figure
    end
    
    for i = 1:ccNum
        stuff = image(ccLabeled == i);
        
        if (any(isnan(stuff)))
            disp(['      ', num2str(i), ': discarded because ',num2str(sum(isnan(stuff))), ' out of ', num2str(numel(image(ccLabeled == i))),' items are NaN']);
            %notnormal = notnormal + 1;
            continue;
        end

        sizes(i) = numel(stuff);
        
        if (sizes(i) < 10)
            %notnormal = notnormal + 1;
            continue
        end
    
        if (strcmp(distname,'weibull'))
            stuff = stuff - min(stuff, [], 'all');
            stuff(stuff==0) = eps;
        end

        if (strcmp(distname,'lognormal'))
            stuff = stuff - min(stuff, [], 'all');
            stuff(stuff==0) = eps;
        end
        
        if (strcmp(distname,'GeneralizedPareto'))
            stuff = stuff - min(stuff, [], 'all');
            stuff(stuff==0) = 1;
        end

        if size(stuff,1) == 0 || ~any(stuff~=eps) || ~any(stuff~=1)
            %notnormal = notnormal + 1;
            continue
        end
        
        distribution = fitdist(stuff, distname);
        
        st = distribution.std();
        mn = distribution.mean();

        if isnan(st) || isnan(mn)
            notnormal = notnormal + 1;
            continue
        end

        %stds(i) = std(stuff, 0, 'all');
        %means(i) = mean(stuff, 'all');
        stds(i) = st;
        means(i) = mn;
        sums(i) = sum(stuff, 'all');
        medians(i) = median(stuff, 'all');

        % test normality
        [H,P] = kstest(stuff, 'CDF', distribution);
        
        %figure('Name',num2str(i))
        %histogram(stuff)
        if (H)
            %disp(['      ', num2str(i), ': not from ' distname ' distribution with p=', num2str(P)]);
            notnormal = notnormal + 1;
        end
        
        if (cinematic)
            frame = image;
            frame(ccLabeled ~= i) = NaN;
            imshow(frame,[])
            pause(0.1)
        end
    end

    % Do sorting where we visualize, otherwise useful data might be lost
    % sums = sort(sums, 'descend');
    % sizes = sort(sizes, 'descend');
    % stds = sort(stds, 'descend');
    % means = sort(means, 'descend');
    % medians = sort(medians, 'descend');
    normFails = 100 * notnormal / ccNum;
    %disp(num2str(100 * notnormal / cc_num));
end

