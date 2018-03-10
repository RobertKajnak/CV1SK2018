function [scores, matches,f1,f2,d1,d2]= keypoint_matching(image1,image2)
    % If I don't return these how am I supposed to plot Question1-2 ??

    [f1,d1] = vl_sift(tosingle(image1));
    [f2,d2] = vl_sift(tosingle(image2));
    
    [matches,scores] = vl_ubcmatch(d1, d2) ;
end

function [converted_image] = tosingle(image)

    if size(image,3)==3
        converted_image = rgb2gray(image);
    elseif isa(image(1,1),'uint8')
        converted_image = single(image)/255.0;
    end
end