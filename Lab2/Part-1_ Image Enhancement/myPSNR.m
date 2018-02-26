function [ PSNR ] = myPSNR( orig_image, approx_image )
    % convert to double first
    orig_image = double(orig_image);
    approx_image = double(approx_image);
    
    mse = immse(orig_image,approx_image);
    I_max = max(orig_image(:));
    PSNR = 20 * log10(I_max/sqrt(mse)); 
end

