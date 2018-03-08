%% These will be needed later



%% load files
sph1 = imread('sphere1.ppm');
sph2 = imread('sphere2.ppm');

sy1 = imread('synth1.pgm');
sy2 = imread('synth2.pgm');


%%
[Ix,Iy,It] = getDerivatives(sph1,sph2);

%split optical vectors
sIx = split_nonoverlap(Ix,15,15);
sIy = split_nonoverlap(Iy,15,15);
sIt = split_nonoverlap(It,15,15);

[V] = getSpeeds(sIx,sIy,sIt);

figure;
X = 0:floor(size(sph1,1)/15)-1;
X = X*15+7;
Y = X;
imshow(sph2);
hold on;
quiver(X,Y,V(:,:,1),V(:,:,2));

%% helper functions
function [Ix,Iy,It] = getDerivatives(image1, image2, isDoPlot)
% GETDERIVATIVES  Calculates the spacial derivatives for image 1 and the
% temporal derivative of the two images.
%   ISDOPLOT - OPTIONAL. Specify a non-zero value to plot the three
%   derivatives
%   See also GETSPEEDS, SPLIT_NONOVERLAP
%

    % Get gaussian filter
    g = fspecial('gaussian',[5 5],2);
    % First order derivate = gradient
    [gdx, gdy] = gradient(g);

    % convert images to grayscale(double)
    i1 = rgb2gray(im2double(image1));
    i2 = rgb2gray(im2double(image2));
    
    % perform Gaussian first derivative
    Ix = conv2(i1, gdx, 'same');
    Iy = conv2(i2, gdy, 'same');
    % dt=t2-t1
    It = i2-i1;
    
    % Plot if requested
    if nargin>2 && isDoPlot~=0
        figure;
        subplot(1,3,1);
        imshow(Ix,[]);
        subplot(1,3,2);
        imshow(Iy,[]);
        subplot(1,3,3);
        imshow(It,[]);
    end
end

function [S]= split_nonoverlap(image, regionHeight, regionWidth)
% SPLIT_NONOVERLAP  Splits the image into regions of dimension
% [regionHeight, regionWidht]. If the image dimensions are not exact
% multiples of the region dimensions, the pixels at the end are ignored
%   IMAGE - original image
%   REGIONHEIGHT - height of the region
%   REGIONWIDTH - width of the region
%   S - 3D array of shape
%   [imageheight/regionHeight,imageWidth/regionwidth,regionheigth*regionwidth]
%   See also GETDERIVATIVES, GETSPEEDS
%
    h= regionHeight;
    w = regionWidth;
    
    %Calculate number of regions
    imax = floor(size(image,1)/h)-1;
    jmax = floor(size(image,2)/w)-1;
    S=zeros(imax,jmax,w*h);
    
    %flatten each region
    for i=0:imax
         for j=0:jmax
            im = image(h*i+1:h*(i+1),w*j+1:w*(j+1));
            S(i+1,j+1,:)= reshape(im,1,[]);
        end
    end
end

function [V] = getSpeeds(ofmx,ofmy,ofmt)
% GETSPEEDS  Calculates the speeds for each of the regions based on the
% optical flow vector matrixes of x,y and t components
%   OFMX - optical flow matrix for x dimension
%   OFMY - optical flow matrix for y dimension
%   OFMT - optical flow matrix for t dimension
%   V - 3D array of size[imageHeight,imageWidth,2]. [:,:,1]=Vx; [:,:,2]=Vy
%   See also GETDERIVATIVES, SPLIT_NONOVERLAP
%
    ox = ofmx;
    oy = ofmy;
    ot = ofmt;
    V=zeros(size(ox,1),size(ox,2),2);
    
    for i=1:size(ox,1)
        for j=1:size(ox,2)
            %reshape from [1,1,length(ox)] to [length(ox),1]
            A = [reshape(ox(i,j,:),[],1),reshape(oy(i,j,:),[],1)];
            b = -reshape(ot(i,j,:),1,[])';
            
            V(i,j,:)=(A'*A)^-1*A'*b;
        end
    end
end