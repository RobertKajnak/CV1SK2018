function [scores, matches,f1,f2,d1,d2]= keypoint_matching(image1,image2)
    image1 = tosingle(image1);
    image2 = tosingle(image2);
    
    [f1,d1] = vl_sift(image1);
    [f2,d2] = vl_sift(image2);
    
    [matches,scores] = vl_ubcmatch(d1, d2);
    
    function [converted_image] = tosingle(image)

        if size(image,3)==3
            converted_image = single(rgb2gray(image));
        elseif isa(image(1,1),'uint8')
            converted_image = single(image);
        end
    end
end