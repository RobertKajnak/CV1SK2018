function[keypoints, descriptors] = sift(image, d_or_s, sift_type)
% sift_type = gray, RGBsift, rgbsift or opponent
% d_or_s = dsift or sift

keypoints = [];
descriptors = [];
if strcmpi(d_or_s, 'sift')
    switch sift_type
        case 'gray'
            if size(image, 3) == 3
                im = single(rgb2gray(image));
            else
                im = single(image);
            end
            
            [keypoints, descriptors] = vl_sift(im);
        case 'RGB'

            % check if image is not grayscale
            if size(image, 3) < 3
                return
            end
            for i=1:3
                im_i = single(image(:,:,i));
                [keys_i, descs_i] = vl_sift(im_i);
                keypoints = [keypoints, keys_i];
                descriptors = [descriptors, descs_i];
            end
            
        case 'nrgb'
            % check if image is not grayscale
            if size(image, 3) < 3
                return
            end
  
            % convert RGB to rgb
            image = single(image);
            for i= 1:3
                im_i = single(image(:,:,1)./sum(image,3));
                im_i(isnan(im_i))=0;
                [keys_i, descs_i] = vl_sift(im_i);
                keypoints = [keypoints, keys_i];
                descriptors = [descriptors, descs_i];     
            end
            
        case 'opponent'
            % check if image is not grayscale
            if size(image, 3) < 3
                return
            end
            % Code from vl_phow
            mu = 0.3*image(:,:,1) + 0.59*image(:,:,2) + 0.11*image(:,:,3) ;
            alpha = 0.01 ;
            image = cat(3, mu, ...
                 (image(:,:,1) - image(:,:,2))/sqrt(2) + alpha*mu, ...
                 (image(:,:,1) + image(:,:,2) - 2*image(:,:,3))/sqrt(6) + alpha*mu) ;
            
            for i=1:3
                im_i = single(image(:,:,i));
                [keys_i, descs_i] = vl_sift(im_i);
                keypoints = [keypoints, keys_i];
                descriptors = [descriptors, descs_i];
            end        
    end

    % dense sift, use step size of 10
elseif strcmpi(d_or_s, 'dsift')
    switch sift_type
        case 'gray'
            if size(image, 3) == 3
                im = single(rgb2gray(image));
            else
                im = single(image);
            end
            [keypoints, descriptors] = vl_dsift(im, 'step', 20);
        case 'RGB'
            % check if image is not grayscale
            if size(image, 3) < 3
                return
            end
            [keypoints, descriptors] = vl_phow(single(image), 'color', 'rgb', 'step', 20);
            
        case 'nrgb'
            % check if image is not grayscale
            if size(image, 3) < 3
                return
            end
  
            % convert RGB to rgb
            image = single(image);
            for i= 1:3
                im_i = single(image(:,:,1)./sum(image,3));
                im_i(isnan(im_i))=0;
                [keys_i, descs_i] = vl_dsift(im_i, 'step', 20);
                keypoints = [keypoints, keys_i];
                descriptors = [descriptors, descs_i];     
            end
            
        case 'opponent'
            % check if image is not grayscale
            if size(image, 3) < 3
                return
            end
            [keypoints, descriptors] = vl_phow(single(image), 'color', 'opponent', 'step', 20);
    end
else
    disp('Invalid input');
    return
end
end