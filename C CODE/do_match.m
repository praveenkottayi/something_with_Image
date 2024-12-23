function [num, pts1, pts2] = do_match(im1, des1, loc1, im2, des2, loc2, fhand)

% This function matchings the SIFT keys from two iamges
% distRatio: Only keep matches in which the ratio of vector angles from the
%   nearest to second nearest neighbor is less than distRatio.
% Postprocessing: check each matching point, eliminate false matches by voting from
% neighbouring area
% Author: Yantao Zheng. Nov 2006.  For Project of CS5240
% Modified: Arun D Panicker, April 2011 

distRatio = 0.75;
% distRatio = 0.65;   %| arundp updated
matched_points_img1 =[];
% For each descriptor in the first image, select its match to second image.
des2t = des2';                          % Precompute matrix transpose
for i = 1 : size(des1,1)
   dotprods = des1(i,:) * des2t;        % Computes vector of dot products
   [vals,indx] = sort(acos(dotprods));  % Take inverse cosine and sort results

   % Check if nearest neighbor has angle less than distRatio times 2nd.
   if (vals(1) < distRatio * vals(2))
      match(i) = indx(1);
      matched_points_img1 = [matched_points_img1; i];
   else
      match(i) = 0;
   end
end


%---------------------------------------------------------
% check each matching point, eliminate false matches by voting from
% neighbouring area
%------
dis_thres = 0.3;
orien_thres = 0.3;
num = sum(match > 0);
final_match = zeros(1,length(match));  % if == 1, the corresponding match(i) is accepted. if ==0, the corresponding match(i) is rejected
dis_img_1= zeros(num ,num); % each row contains the spatial distance vector that descript the correctness of the point 
dis_img_2= zeros(num ,num);

orien_diff_img_1= zeros(num ,num); % each row contains the orientation difference vector that descript the correctness of the point 
orien_diff_img_2= zeros(num ,num);
for k = 1: num
    dis_img_1(k, k)  = 0;
    dis_img_2(k, k)  = 0; % the distance between the point and distance is 0
    
    orien_diff_img_1(k,k) = 0;
    orien_diff_img_2(k,k) = 0;
     
    for j = k+ 1: num
           dis_img_1(k, j) = sqrt( (loc1(matched_points_img1(k), 1) - loc1(matched_points_img1(j), 1))^2 ... 
                    + (loc1(matched_points_img1(k), 2) - loc1(matched_points_img1(j), 2))^2 );
           dis_img_1(j, k) =  dis_img_1(k, j); % dis_img_1 is a symmetric matrix
           
           % compute the corresponding distances of the matching points in
           % image 2
           dis_img_2(k, j) = sqrt( ((loc2(match(matched_points_img1(k)), 1) - loc2(match(matched_points_img1(j)), 1))^2 + (loc2(match(matched_points_img1(k)), 2) - loc2(match(matched_points_img1(j)), 2))^2 ));
           dis_img_2(j, k) =  dis_img_2(k, j); % dis_img_1 is a symmetric matrix
           
           
           orien_diff_img_1(k, j) =  loc1(matched_points_img1(k), 4) - loc1(matched_points_img1(j), 4);
           orien_diff_img_1(j, k) =  orien_diff_img_1(k, j); % dis_img_1 is a symmetric matrix

           orien_diff_img_2(k, j) =  loc2(match(matched_points_img1(k)), 4) - loc2(match(matched_points_img1(j)), 4);
           orien_diff_img_2(j, k) =  orien_diff_img_2(k, j); % dis_img_1 is a symmetric matrix

           
    end
end

% normalize the distance and orein_diff vector
for ii =1: num
    dis_img_1(ii, :) = dis_img_1(ii, :) ./ norm(dis_img_1(ii, :) );
    dis_img_2(ii, :) = dis_img_2(ii, :) ./ norm(dis_img_2(ii, :) );
    
    orien_diff_img_1(ii,:) = orien_diff_img_1(ii,:) ./( eps + norm(orien_diff_img_1(ii,:)));
    orien_diff_img_2(ii,:) = orien_diff_img_2(ii,:) ./( eps +norm(orien_diff_img_2(ii,:)));

end

for m = 1: num
    dis_coherence = dot(dis_img_1(m,:), dis_img_2(m,:));
    orein_coh = dot(orien_diff_img_1(m,:), orien_diff_img_2(m,:));
    if dis_coherence > dis_thres && (orein_coh > orien_thres  || ( sum(orien_diff_img_1(m,:)>0) == 0 && sum(orien_diff_img_2(m,:)>0) == 0 ) )
        % if the orientations are the same, then orein_coh will be 0, so
        % cope with this with another condition
        final_match(matched_points_img1(m)) = 1;
    end
end


num = sum(match > 0);
% fprintf('Found %d matches.\n', num);

% Create a new image showing the two images side by side.
im3 = appendimages(im1,im2);

% Show a figure with lines joining the accepted matches.

axes(fhand);
colormap('gray');
imagesc(im3); axis equal; axis off;
hold on;
cols1 = size(im1,2);
counter = 0;
pts1(1, :) = [0 0];
pts2(1, :) = [0 0];
for i = 1: size(des1,1)
    if (match(i) > 0)
        line([loc1(i,1) loc2(match(i),1)+cols1], ...
            [loc1(i,2) loc2(match(i),2)], 'Color', 'c');
        counter = counter + 1;
        pts1(counter,1) = loc1(i,1);
        pts1(counter,2) = loc1(i,2);
        pts2(counter,1) = loc2(match(i),1);
        pts2(counter,2) = loc2(match(i),2);
    end
end
hold off;