function imOut = compute_LoG(image, LOG_type)

switch LOG_type
    case 1
        %method 1
        h1 = fspecial('gaussian',[5 5],0.5);
        h2 = fspecial('laplacian');
        imOut = imfilter(image,h1);
        imOut = imfilter(imOut,h2);

    case 2
        %method 2
        h = fspecial('log',[5 5],0.5);
        imOut = imfilter(image,h);
    case 3
        %method 3
        h1 = fspecial('gaussian',[5 5],2);
        h2 = fspecial('gaussian',[5 5],0.2);
        
        imOut= imfilter(image,h1-h2);

end
end

