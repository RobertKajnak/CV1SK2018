%%%%
%% To see a demo just run this script without parameters
%%%%

function [V,X,Y] = Lucas_kanade(image1,image2,regionH,regionW,x,y)
    % DEMO_LUCAS_KANADE Demonstrates the Lucas_Kanade algorithm
    % implementation
    %   REGIONH - OPTIONAL. the heigth of each region. Default value = 15
    %   REGIONH - OPTIONAL. the width of each region. If height speicifed, 
    %       but not width: regionW=regionH. If neither specified: value = 15
    if nargin==0
        % load files
        sph1 = imread('sphere1.ppm');
        sph2 = imread('sphere2.ppm');

        sy1 = imread('synth1.pgm');
        sy2 = imread('synth2.pgm');
        % Calculate and display results

        Lucas_kanade(sph1,sph2);
        Lucas_kanade(sy1,sy2);
        return
    end
    
    if nargin==3
        regionW = regionH;
    end
    if nargin==2
        regionH = 15;
        regionW = 15;
    end
    h=regionH;
    w=regionW;
    
    if nargin >= 6
            im1 = image1;
            %Can't just use min, that would change the window size
            if (y-floor(h/2)<1)
                y=floor(h/2)+1;
            end
            if (x-floor(w/2)<1)
                x=floor(w/2)+1;
            end
            if y+floor(h/2)>=size(image1,1)
                y=size(image1,1)-floor(h/2);
            end
            if x+floor(w/2)>=size(image1,2)
                x = size(image1,2)-floor(w/2);
            end
            image1 = image1(y-floor(h/2):y+floor(h/2),x-floor(w/2):x+floor(w/2));
            image2 = image2(y-floor(h/2):y+floor(h/2),x-floor(w/2):x+floor(w/2));
    end
    
    [Ix,Iy,It] = getDerivatives(image1,image2);
    

    %split optical vectors
    Ix = split_nonoverlap(Ix,h,w);
    Iy = split_nonoverlap(Iy,h,w);
    It = split_nonoverlap(It,h,w);

    
    %get speeds
    [V] = getSpeeds(Ix,Iy,It);
    

    %display images
    if nargin <5
        [X,Y] = speedVectorOverlay(image1,V,2);
    end
end

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
    i1 = im2double(image1);
    i2 = im2double(image2);
    if (size(image1,3) == 3)
        i1=rgb2gray(i1);
    end
    if (size(image2,3) == 3)
        i2=rgb2gray(i2);
    end
    
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
    
    epsilon = 10^-2;
    
    for i=1:size(ox,1)
        for j=1:size(ox,2)
            %reshape from [1,1,length(ox)] to [length(ox),1]
            A = [reshape(ox(i,j,:),[],1),reshape(oy(i,j,:),[],1)];
            b = -reshape(ot(i,j,:),1,[])';
            
            if all(b<epsilon)
                V(i,j,:)= zeros(2,1);
            else
                V(i,j,:)=(A'*A)^-1*A'*b;
            end
        end
    end
end

function [X,Y] = speedVectorOverlay(image, V, displayMode)
% SPEEDVECTOROVERLAY  Calculates the correct position for the vectors to be
% placed on the image
%   DISPLAYMODE - OPTIONAL. Values: 0 or omit: no display.
%                                   1: overlays arrows on currently open
%                                   figure
%                                   2: Creates a figure with IMAGE and
%                                   overays arrows on it
%   X,Y - returns the coordinates calculated for the overlay

    %calculate w/h of both speed matrix and image
    vh = size(V,1);
    vw = size(V,2);
    hr = size(image,1)/vh;
    wr = size(image,2)/vw;

    %scale the points to be in the middle of the regions
    X = 0:vh-1;
    X = floor(X*hr+hr/2);
    Y = 0:vw-1;
    Y = floor(Y*wr+wr/2);

    if nargin>2
       if displayMode == 2 
           figure;
           imshow(image);
       end
       if displayMode == 1 || displayMode == 2
           hold on;
           quiver(X,Y,V(:,:,1),V(:,:,2));
           hold off;
       end
    end

end