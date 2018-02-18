function visualize(input_image,plot_title,subtitles)
%3 dimensions means image + components
    
    s = size(input_image);
    if nargin>1
        figure('name',plot_title);
    end
    
    subplot(2,2,1)
    if (s(3)==4)
        imshow(input_image(:,:,4))
        if nargin>2
            title(subtitles(4));
        end
    else
        imshow(input_image)
        if nargin>2
            title('Image with all channels');
        end
    end

    for i=1:3
        subplot(2,2,i+1)
        imshow(input_image(:,:,i))
        if nargin>2
            title(subtitles(i))
        end
    end
    
end

