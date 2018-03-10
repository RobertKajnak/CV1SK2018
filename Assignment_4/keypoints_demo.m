
    boat1 = imread('boat1.pgm');
    boat2 = imread('boat2.pgm');
    % 
    % if ~exists(vl_version)
    %     run('..\..\vlfeat\toolbox\vl_setup');
    % end
    %%
    close all;

    %done 50 as requested, but looks much better with a lower number such
    %as 10
    %[matches, ~, f1,f2] = getMatches(boat1,boat2,1,50);
    [matches, ~, f1,f2] = getMatches(boat1,boat2);

    n=10;
    p=50;

    fbest = zeros(size(matches,2));
    best = 0;
    for i=1:n
        %select p random points
        perm = randperm(size(matches,2),p);
        x1 = f1(1,matches(1,perm(1)));
        x2 = f2(1,matches(2,perm(1)));
        y1 = f1(2,matches(1,perm(1)));
        y2 = f2(2,matches(2,perm(1)));
        
        %TODO this should be based on all 50, right?
        A = [[x1 y1 0 0;0 0 x1 y1],eye(2)];
        b = [x2;y2];
        x = pinv(A)*b;
        
        m = reshape(x(1:4),2,2);
        t = x(5:6);
        
        f3 = f2;
        ftemp = zeros(size(matches));
        good = 0;
        k=1;
        for j=1:size(matches,2)
            x =  f1(1,matches(1,j));
            y =  f1(2,matches(1,j));
            x2 = f2(1,matches(2,j));
            y2 = f2(2,matches(2,j));
            xy3 = m*[x;y]+t;
            
            %check if transofmation of points by counting inliers

            if sqrt((xy3(1)-x2)^2-(xy3(2)-y2)^2)<10
                good = good +1;
                %save the parameters
                m3 = m;
                t3 = t;
                %save the inliers
                ftemp(:,k) = xy3;
                k=k+1;
            end
        end
        
        if good>best
            fbest = ftemp(1:good);
            best = good;
        end
    end    
    fprintf('The image was rotated with %.2f%% precision\n',best*100.0/size(matches,2));
    
    
    %TODO implement transform
    %compare it to maketform
    %"imtransform is not recommended. Use imwarp instead."
    
    im3 = transform_image(boat1,m3,t3);
    figure;
    subplot(2,1,1);
    imshow(boat1);
    subplot(2,1,2);
    imshow(im3);
%     tform = affine2d([m3(1) m3(2) t3(1);  m3(3) m3(4) t3(2); 0 0 1]);
%     im3 = imwarp(boat1,tform);
%     imshow(boat1), figure, imshow(im3)

%% helper functions
function new_image=transform_image(image,m,t)
    sz = size(image);
    new_image=zeros();
    for i=1:sz(1)
        for j=1:sz(2)
            xy= [m(1) m(2);m(3) m(4)]*[i;j]+[t(1);t(2)];
            xy=floor(xy);
            if xy(1)>0 && xy(1)<sz(1) && xy(2)>0 && xy(2)<sz(2)
                new_image(xy(1),xy(2))=image(i,j);
            end
        end
    end
end
function [matches, scores, f1, f2] = getMatches(im1,im2,isOrdered,nrmatches)
%NRMATCHES - optional. If a positive value is specified, that number of
%mathces will be plotted
%ISORDERED - optional. Defines if the returned matches are ordered or
%random

    if nargin<4
        nrmatches=10;
    end
    if nargin<3
        isOrdered = 0;
    end
    
    [scores,matches,f1,f2] = keypoint_matching(im1,im2);

    % visualize top 10 matches

    % sort scores
    % scores <- L2 metric => lower == better
    if isOrdered
        [scores, indices] = sort(scores);
        matches = matches(:,indices);
    else
        perm = randperm(size(matches,2));
        matches = matches(:,perm);
        scores = scores(perm);
    end
    
    if nargin>=4 && nrmatches>0
        figure;
        stiched = cat(2,im1,im2);
        w = size(im1,2);
        imshow(stiched);
        sel1 = matches(1,1:nrmatches);
        sel2 = matches(2,1:nrmatches);
        h1 = vl_plotframe(f1(:,sel1)) ;
        set(h1,'color','y','linewidth',3) ;
        h2 = vl_plotframe([f2(1,sel2)+w;f2(2:4,sel2)]) ;
        set(h2,'color','y','linewidth',3) ;
        hold on
        for i=1:nrmatches
            x1 = f1(1,matches(1,i));
            x2 = f2(1,matches(2,i))+w;
            y1 = f1(2,matches(1,i));
            y2 = f2(2,matches(2,i));
            plot([x1 x2],[y1 y2],'blue');
        end
%         figure;
%         subplot(1,2,1);
%         imshow(im1);
%         hold on;
%         h2 = vl_plotframe(f1(:,matches(1,1:nrmatches))) ;
%         set(h2,'color','y','linewidth',3) ;
%         hold off;
% 
%         subplot(1,2,2);
%         imshow(im2);
%         hold on;
%         h2 = vl_plotframe(f2(:,matches(2,1:nrmatches))) ;
%         set(h2,'color','y','linewidth',3) ;
%         hold off;
    end
end

function [f,d] = getFeatures(im, visualize, nrfeatures)
%IM: image to parse
%VISUALIZE - 0: do not
%            1: only features
%            2: only descriptors
%            3: both
% NRFEATURES: number of features to visualize
    if (nargin==1)
        vis=0;
    else
        vis = visualize;
    end
    
    if (nargin<=2)
        nrfeatures = 50;
    end
    
    if size(im,3)==3
        im = rgb2gray(im);
    elseif isa(im(1,1),'uint8')
        im = single(im)/255.0;
    end


    % "[f] is a disk of center f(1:2), scale f(3) and orientation f(4)"4
    % d - descriptors
    [f,d] = vl_sift(im) ;

    if vis>0
        imshow(im);
        hold on;
    end

    % Visualize features
    if vis>=1
        perm = randperm(size(f,2)) ;
        sel = perm(1:nrfeatures) ;
    end
    if vis==1 || vis==3
        h1 = vl_plotframe(f(:,sel)) ;
        h2 = vl_plotframe(f(:,sel)) ;
        set(h1,'color','k','linewidth',3) ;
        set(h2,'color','y','linewidth',2) ;
    end

    % Visualize descriptors
    if vis>=2
        h3 = vl_plotsiftdescriptor(d(:,sel),f(:,sel)) ;
        set(h3,'color','g') ;
    end


end