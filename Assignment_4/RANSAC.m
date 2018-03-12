function [best_transformation]= RANSAC(image1,image2,matches, f1, f2, N, P, show_image)
    best_num_inliers = -inf;
    best_inliers = [];
    best_m = [];
    best_t = [];
    for n = 1:N
        P_matches = datasample(matches, P, 2, 'Replace', false);
        % Construct matrices A and b
        A = [];
        b = [];
        for i = 1:P
            x1 = f1(1,P_matches(1,i)) ;
            x2 = f2(1,P_matches(2,i)) ;
            y1 = f1(2,P_matches(1,i)) ;
            y2 = f2(2,P_matches(2,i)) ;
            A_i = [x1 y1 0 0 1 0; 0 0 x1 y1 0 1];
            b_i = [x2;y2];
            A = [A; A_i];
            b = [b; b_i];
        end
        % calculate transformation parameters
        x = pinv(A)*b;
        m = [x(1) x(2); x(3) x(4)];
        t = [x(5);x(6)];
        % Transform, plot & count inliers
        inliers = [];
        if show_image
            figure();
            imshow(cat(2, image1, image2));
            hold on;
        end
        for j = 1:length(matches)
            x1 = f1(1,matches(1,j)) ;
            y1 = f1(2,matches(1,j)) ;
            transformed = m*[x1;y1]+t;
            x_trans = transformed(1);
            y_trans = transformed(2);
            if show_image
                line([x1; x_trans + size(image1, 2)], [y1;y_trans], 'Color', 'r', 'LineWidth', 1);
            end
            x2 = f2(1,matches(2,j)) ;
            y2 = f2(2,matches(2,j)) ;
            if abs(x2-x_trans) < 10 && abs(y2-y_trans) < 10
                inliers = [inliers [x_trans; y_trans]];
            end
        end
        if show_image
            hold off;
        end
        % Get best transformation parameters
        if length(inliers) > best_num_inliers
            best_num_inliers = length(inliers);
            best_inliers = inliers;
            best_m = m;
            best_t = t;        
        end
        
        % close figure after displaying
         
    end
    fprintf('The image was rotated with %.2f%% precision\n',best_num_inliers*100.0/size(matches,2));
    % transform image and show next to transformation with matlab
    [new_image, nc] = transform_image(image1, best_m, best_t);
    % matlab recommends: use affine2d instead of maketform and
    % imwarp instead of imtransform
    tform = affine2d([best_m'; best_t']);
    matlab_transformed = imwarp(image1, tform, 'OutputView', imref2d(size(image1)));
    figure();
    new_image = imresize(new_image,0.6);
    imshow(new_image);
    figure();
    matlab_transformed = imresize(matlab_transformed,0.6);
    imshow(matlab_transformed);
    figure()
    image2 = imresize(image2, 0.6);
    imshow(image2);
    
    best_transformation = nc;%= [best_m best_t];
end

% helper function to transform image
function [new_image,nc]=transform_image(image,m,t)
    %nc is for debugging -- it contains the transformed coordinates of the
    %image's corners
    
    image = double(image);
    sz = size(image);
        
    nc = floor([m*[1;1]+t,m*[sz(1);1]+t,m*[1;sz(2)]+t,m*[sz(1);sz(2)]+t]);
    % TODO correct padding
    new_image=uint8(zeros(sz));
    for i=1:sz(1)
        for j=1:sz(2)
            xy=m*[i;j]+t;
            xy=round(xy);
            if xy(1)>0 && xy(1)<sz(1) && xy(2)>0 && xy(2)<sz(2)
               %new_image(xy(1),xy(2))=uint8(255.0*image(i,j));
               %[xy,[i;j]]
               new_image(i, j)=uint8(image(xy(1),xy(2)));
            end
            %new_image(i,j)=uint8(255.0*image(i,j));
        end
    end
    
end

    
