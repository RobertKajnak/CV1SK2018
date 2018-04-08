function [AP] = average_precision(images, label)
    AP = 0;
    pos_count = 0;
    for i = 1:200
        if strcmp(images{i, 2}, label)
            pos_count = pos_count + 1;
            AP = AP + pos_count/i;
        end
    end
    AP = AP/50;
end