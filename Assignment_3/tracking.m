%% Load all files into an array
close all;
%[toys,n] = loadAllImages('person_toy');
[toys,n] = getAllFileNames('person_toy');

%% Perfrom Stuff

[im1, H, r, c] = harris_corner_detector(char(toys(10)),10^-7,0);
[im2, H, r2, c2] = harris_corner_detector(char(toys(11)),10^-7,0);
Lucas_kanade(im1,im2,15,15,c(5),r(5));
% for i=1:n
%     [im, H, r, c] = harris_corner_detector(char(toys(i)),10^-7,0);
%     
%     %im = squeeze(toys(i,:,:,:));
%     %figure;
%     %imshow(im,[]);
%     %[H,r,c] = harris_corner_2(toys(i),10^-7);
%     if (i==4)
%         break
%     end
% end

%% Helper functions
function [filenames,n] = getAllFileNames(directory)
    
    filenameList = dir(directory);
    n = size(filenameList,1);
    filenames = strings(1,n-2);
    for i=3:n
        filenames(i-2,:) = string(strcat(strcat(directory,'/'),filenameList(i).name));
    end
    
end

function [images,n] = loadAllImages(directory)
%directory should be a string
    filenames = dir(directory);
    n = size(filenames,1);
    
    %prealocation decreases load time by a factor of ~10
    imsize = size(imread(strcat(strcat(directory,'/'),filenames(3).name)));
    images = zeros([n,imsize]);
    
    %skip '.' and '..'
    for i=3:n
        images(i-2,:,:,:) = imread(strcat(strcat(directory,'/'),filenames(i).name));
        imshow(images(i-2,:,:,:));
    end

end