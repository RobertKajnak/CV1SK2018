function demo()
    boat1 = imread('boat1.pgm');
    boat2 = imread('boat2.pgm');
    % 
    % if ~exists(vl_version)
    %     run('..\..\Computer Vision\vlfeat\toolbox\vl_setup');
    % end
    %%
    close all;

    [f1,d1] = getFeatures(boat1);
    [f2,d2] = getFeatures(boat2);

    %done 50 as requested, but looks much better with a lower number such
    %as 10
    getMatches(boat1,boat2,1,50);

    [matches, scores] = vl_ubcmatch(d1, d2) ;

    n=30;
    p=10;

    for i=1:n
        perm = randperm(size(matches,2),p);

    end    
end


%% helper functions

function [matches]= keyopoint_matching(image1,image2)
    if nargin==0
        demo();
    end
    [~,d1] = getFeatures(image);
    [~,d2] = getFeatures(image);
    
    matches = vl_ubcmatch(d1, d2) ;
    
    
end

function [matches, scores] = getMatches(im1,im2,isOrdered,nrmatches)
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
    
    [f1,d1] = getFeatures(im1);
    [f2,d2] = getFeatures(im2);
    
    [matches, scores] = vl_ubcmatch(d1, d2) ;

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