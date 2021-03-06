function [ height_map ] = construct_surface( p, q, path_type )
%CONSTRUCT_SURFACE construct the surface function represented as height_map
%   p : measures value of df / dx
%   q : measures value of df / dy
%   path_type: type of path to construct height_map, either 'column',
%   'row', or 'average'
%   height_map: the reconstructed surface


if nargin == 2
    path_type = 'column';
end

[h, w] = size(p);
height_map = zeros(h, w);

switch path_type
    case 'column'
        % =================================================================
        % YOUR CODE GOES HERE
        % top left corner of height_map is zero
        % for each pixel in the left column of height_map
        %   height_value = previous_height_value + corresponding_q_value
        
        % for each row
        %   for each element of the row except for leftmost
        %       height_value = previous_height_value + corresponding_p_value
        height_map(1,1) = 0;
        for y = 2:h
            height_map(y, 1) = height_map(y-1, 1) + q(y, 1);
        end
        for y = 1:h
            for x = 2:w
                height_map(y, x) = height_map(y, x-1) + p(y, x);
            end
        end

       
        % =================================================================
               
    case 'row'
        
        % =================================================================
        % YOUR CODE GOES HERE
        height_map(1,1) = 0; % left corner is zero
        prev_height = 0;
        % set values first row
        for x = 2:w
            height_map(1, x) = height_map(1, x-1) + p(1, x);
        end
        for x = 1:w
            for y = 2:h
                height_map(y, x) = height_map(y-1, x) + q(y, x);
            end
        end
        % =================================================================
          
    case 'average'
        
        % =================================================================
        % YOUR CODE GOES HERE
        % compute row and column height maps
        hmap_row = construct_surface( p, q, 'row' );
        hmap_col = construct_surface( p, q, 'column' );
        % concatenate the two solutions
        hmap_cat = cat(3, hmap_row, hmap_col);
        height_map = mean(hmap_cat, 3);
        % =================================================================
end


end

