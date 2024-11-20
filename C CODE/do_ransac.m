% this function perform RANSAC to find the best transformation
% that fits maximum matches

% Author: Arun D Panicker, April 2011 

function bestTransformation = do_ransac(points1, points2)

maxInliers = 0;
minError = 999;
tolerance = 1.25; % in pixels
maxTrials = 1500;
npts = size(points1, 1);
p = 3;

for i = 1:maxTrials
    ind = randsample(npts, p);
    X1 = points1(ind, 1);
    Y1 = points1(ind, 2);
    X2 = points2(ind, 1);
    Y2 = points2(ind, 2);
        P = [X2'; Y2'; 1 1 1; X1'; Y1'; 1 1 1];
    while(isdegenerate(P))
        ind = randsample(npts, p);
        X1 = points1(ind, 1);
        Y1 = points1(ind, 2);
        X2 = points2(ind, 1);
        Y2 = points2(ind, 2);
        P = [X2'; Y2'; 1 1 1; X1'; Y1'; 1 1 1];
    end;
    
    input_points = [X1 Y1];
    base_points = [X2 Y2];
    t = cp2tform(input_points,base_points,'affine');    % transformation
    Tinv = t.tdata.Tinv; % = [sc -ss  0;
                         %    ss  sc  0;
                         %    tx  ty  1]
    T = Tinv';          
    inliers = 0;
    dError = 0;
    for j = 1:npts
        p1 = [points1(j, 1); points1(j, 2); 1];
        p2 = [points2(j, 1); points2(j, 2); 1];
        Tp = T * p2;
        d = distance(Tp, p1);
        if (d < tolerance)
            inliers = inliers + 1;
            dError = dError + d;
        end;
    end;
    if ((inliers >= maxInliers))% && (minError >= dError))
        bestTransformation = T;
        maxInliers = inliers;
        minError = dError;
    end;
end;
end

function d = distance(x1, x2)
dx = x1(1) - x2(1);
dy = x1(2) - x2(2);
d = sqrt((dx * dx) + (dy * dy));
% d = abs(dx) + abs(dy);
end

function r = isdegenerate(x)
% function check whether the 3 points in either of the image are colinear
    x1 = x(1:3,:);    % Extract x1 and x2 from x
    x2 = x(4:6,:);    
    r = ...
    iscolinear(x1(:,1),x1(:,2),x1(:,3)) | ...
    iscolinear(x2(:,1),x2(:,2),x2(:,3));
end
