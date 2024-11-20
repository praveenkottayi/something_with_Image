% function to create a lookup table for the stitching output

% Transformation T has to be applied on image2. Instead, the transformed
% cordinates for image 2 is computed and saved into Table for use on 
% all frames in the video.

% Cordinates of image1 could be translated to avoid negative/zero index
% subscripts on the resulting image

% Both images are blended together at the overlapping region. The Table
% output of the function also hold the weight of each pixel in each image
% to enable the blending.

% Author: Arun D Panicker, April 2011 

function Table = create_table(image1, image2, T, blend)

I1 = double(image1);
[h1 w1 d1] = size(I1);
I2 = double(image2);
[h2 w2 d2] = size(I2);

% warp incoming corners to determine the size of the output image
% (in to out)
cp = T*[ 1 1 w2 w2 ; 1 h2 1 h2 ; 1 1 1 1 ];
Xpr = min( [ cp(1,:) 0 ] ) : max( [cp(1,:) w1] ); % min x : max x
Ypr = min( [ cp(2,:) 0 ] ) : max( [cp(2,:) h1] ); % min y : max y
[Xp,Yp] = ndgrid(Xpr,Ypr);
[wp hp] = size(Xp); % = size(Yp)

% do backwards transform (from out to in)
X = T \ [ Xp(:) Yp(:) ones(wp*hp,1) ]';  % warp
xI = reshape( X(1,:),wp,hp)';
yI = reshape( X(2,:),wp,hp)';

% offset for untransformed image
offset =  -round( [ min( [ cp(1,:) 0 ] ) min( [ cp(2,:) 0 ] ) ] );

% constructing table

table1 = zeros([hp wp 2]);  % temeroray table of image1 cordinates(x,y)
table2 = zeros([hp wp 2]);  % temporary table of image2 cordinates(x,y)
weights = zeros([hp wp 2]); % temporary table of weights(image1,image2)

[X1 Y1] = meshgrid([1:w1], [1:h1]);
table1(1+offset(2):h1+offset(2),1+offset(1):w1+offset(1),1) = X1;
table1(1+offset(2):h1+offset(2),1+offset(1):w1+offset(1),2) = Y1;
mask1 = (table1(:, :, 1) > 0);  % mask1 marks the image1 region
mask2 = ((xI > 0) & (xI <= w2) & (yI > 0) & (yI <= h2));
                                % mask2 marks the image2 region
table2(:, :, 1) = xI .* mask2;
table2(:, :, 2) = yI .* mask2;

imageMap = (mask1 * 1) + (mask2 *2);
mask3 = (imageMap == 3);        % mask3 marks the overlapping region

% computing the blending factors
step = 1 / blend;
contribution = [step : step : 1];
len = length(contribution) - 1;

wts1 = zeros(len);
wts2 = eye(len);
for i = 1:len
    wts1(i, i) = contribution(i);
end;
wts2 = wts2 - wts1;

[rows columns] = find(imageMap == 3);
minR = min(rows);
maxR = max(rows);
minC = min(columns);
maxC = max(columns);
[rows columns] = find(imageMap == 1);
minR1 = min(rows);
maxR1 = max(rows);
minC1 = min(columns);
maxC1 = max(columns);

% computing the weights/contribution of image1 on the overlapping region
weights(:, :, 1) = double(mask3);
if(minR == minR1)
    [r c] = find(imageMap(minR, :) == 3);
    weights(minR:(minR + len - 1), min(c):max(c), 1) = ...
        (weights(minR:(minR + len - 1), min(c):max(c), 1)' * wts1)';
end;
if(maxC == maxC1)
    [r c] = find(imageMap(:, maxC) == 3);
    weights(min(r):max(r), (maxC - len + 1):maxC, 1) = ...
        weights(min(r):max(r), (maxC - len + 1):maxC, 1) * wts2;
end;
if(maxR == maxR1)
    [r c] = find(imageMap(maxR, :) == 3);
    weights((maxR - len + 1): maxR, min(c):max(c), 1) = ...
        (weights((maxR - len + 1): maxR, min(c):max(c), 1)' * wts2)';
end;
if(minC == minC1)
    [r c] = find(imageMap(:, minC) == 3);
    weights(min(r):max(r), minC : (minC + len - 1), 1) = ...
        weights(min(r):max(r), minC : (minC + len - 1), 1) * wts1;
end;
% computing the weights/contribution of image2 on the overlapping region
weights(:, :, 2) = double(mask3) - weights(:, :, 1);
% filling up the weights on non-overlapping region
weights(:, :, 1) = weights(:, :, 1) + double(imageMap == 1);
weights(:, :, 2) = weights(:, :, 2) + double(imageMap == 2);

% convert the cordinates to integer values
table1 = ceil(table1);
table2 = ceil(table2);

Table = zeros([hp wp 7]);
Table(:, :, 1) = table1(:, :, 1);   % 1 - x on image 1
Table(:, :, 2) = table1(:, :, 2);   % 2 - y on image 1
Table(:, :, 4) = table2(:, :, 1);   % 4 - x on image 2
Table(:, :, 5) = table2(:, :, 2);   % 5 - y on image 2
Table(:, :, 3) = weights(:, :, 1);  % 3 - weight for image 1
Table(:, :, 6) = weights(:, :, 2);  % 6 - weight for image 2
Table(:, :, 7) = imageMap;          % 7 - mask

end
