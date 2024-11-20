% the imageOut is computed based on the Table using image1 and image2

% Author: Arun D Panicker, April 2011 

function imageOut = do_stitch(image1, image2, Table)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Table
% 1 - x on image 1
% 2 - y on image 1
% 3 - weight for image 1
% 4 - x on image 2
% 5 - y on image 2
% 6 - weight for image 2
% 7 - mask
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

I1 = double(image1);
I2 = double(image2);

[oh ow od] = size(Table);

imageOut = zeros([oh ow 3]);

for i = 1 : oh
    for j = 1 : ow
        if(Table(i, j, 7) > 0)
            x1 = Table(i, j, 1);
            y1 = Table(i, j, 2);
            if((x1 > 0) && (y1 > 0))
                img1 = I1(y1, x1, :) * Table(i, j, 3);
            else
                img1 = [0 0 0];
            end;
            x2 = Table(i, j, 4);
            y2 = Table(i, j, 5);
            if ((x2 > 0) && (y2 > 0))
                img2 = I2(y2, x2, :) * Table(i, j, 6);
            else
                img2 = [0 0 0];
            end;
            imageOut(i, j, :) = img1(:) + img2(:);
        end;
    end;
end;