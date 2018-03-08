%% These will be needed later



%% load files
sph1 = imread('sphere1.ppm');
sph2 = imread('sphere2.ppm');

sy1 = imread('synth1.pgm');
sy2 = imread('synth2.pgm');


%%
[Ix,Iy,It] = getDerivates(sph1,sph2);

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
%optical flow vector for sphere. This abreviation is starting to look like
%Hungarian notation. Gah. Just two more characteristics and the
%obsfurcation is complete!!
%ofvsph1 =  

%% helper functions
function [Ix,Iy,It] = getDerivates(image1, image2, isDoPlot)
    %Get gaussian filter
    g = fspecial('gaussian',[5 5],2);
    %First order derivate = gradient
    [gdx, gdy] = gradient(g);

    i1 = rgb2gray(im2double(image1));
    i2 = rgb2gray(im2double(image2));
    Ix = conv2(i1, gdx, 'same');
    Iy = conv2(i2, gdy, 'same');
    It = i2-i1;
    
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
    h= regionHeight;
    w = regionWidth;
    
    imax = floor(size(image,1)/h)-1;
    jmax = floor(size(image,2)/w)-1;
    S=zeros(imax,jmax,w*h);
    for i=0:imax
         for j=0:jmax
            im = image(h*i+1:h*(i+1),w*j+1:w*(j+1));
            S(i+1,j+1,:)= reshape(im,1,[]);
        end
    end
end

function [V] = getSpeeds(ofmx,ofmy,ofmt)
    ox = ofmx;
    oy = ofmy;
    ot = ofmt;
    V=zeros(size(ox,1),size(ox,2),2);
    
    for i=1:size(ox,1)
        for j=1:size(ox,2)
            A = [reshape(ox(i,j,:),[],1),reshape(oy(i,j,:),[],1)];
            b = -reshape(ot(i,j,:),1,[])';
            
            V(i,j,:)=(A'*A)^-1*A'*b;
        end
    end
end