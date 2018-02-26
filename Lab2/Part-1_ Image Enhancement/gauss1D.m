function G = gauss1D( sigma , kernel_size )
    G = zeros(1, kernel_size);
    if mod(kernel_size, 2) == 0
        error('kernel_size must be odd, otherwise the filter will not have a center to convolve on')
    end
    %% solution
    floor_kernel = floor(kernel_size/2);
    x = linspace(-floor_kernel, floor_kernel, kernel_size);
    
    g = 1/(sigma*sqrt(2*pi))*exp(-x.^2/(2*sigma^2));
    % normalize
    G = g./sum(g);
end
