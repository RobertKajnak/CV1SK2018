function [Gx, Gy, im_mag,im_dir] = compute_gradient(image)
    image = int16(image);

    Sx = int16([1 0 -1;2 0 -2;1 0 -1]);
    Sy = int16([1 2 1;0 0 0;-1 -2 -1]);

    s = size(image);
    Gx = zeros(s);
    Gy = Gx;
    im_mag = Gx;
    im_dir = Gx;
    
    for i = 2:s(1)-1
        for j= 2:s(2)-1
            x=i-1:i+1;
            y= j-1:j+1;
            
            Gx(i,j) = sum(sum(Sx.*image(x,y)));
            Gy(i,j) = sum(sum(Sy.*image(x,y)));
            
            im_mag(i,j) = sqrt(Gx(i,j)^2 + Gy(i,j)^2);
            im_dir(i,j) = atan(double(Gx(i,j))/double(Gy(i,j)));
        end
    end
    
    im_dir = im_dir*128*2/pi+127;
end

