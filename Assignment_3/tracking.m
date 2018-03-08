%% Load all files into an array
close all;
[toys,n] = getAllFileNames('person_toy');
vid = VideoWriter('motionTest','MPEG-4');
open(vid)
%% Perfrom Stuff

[imprev, H, r, c] = harris_corner_detector(char(toys(1)),10^-7,0);
y=r(5);
x=c(5);

for i=2:n
    im = imread(char(toys(i)));
    rold = r;
    cold = c;
    V = zeros(length(r),2);
    for j = 1:length(r)
        v = Lucas_kanade(imprev,im,40,40,c(j),r(j));
        v = squeeze(v);
        c(j)=c(j)+v(1);
        r(j)=r(j)+v(2);
        V(j,:)=v;
    end
    figure;
    imshow(im);
    hold on;
    quiver(c',r',V(:,1),V(:,2));
    hold off;
    
    writeVideo(vid,getframe);
    imprev=im;
end
close(vid);
%'cause there'll be like 101 windows open
close all;

%% Helper functions
function [filenames,n] = getAllFileNames(directory)
    
    filenameList = dir(directory);
    n = size(filenameList,1);
    filenames = strings(1,n-2);
    for i=3:n
        filenames(i-2) = string(strcat(strcat(directory,'/'),filenameList(i).name));
    end
    %removing . and ..
    n=n-2;
end

