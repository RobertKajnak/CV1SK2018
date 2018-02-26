function G = gauss2D( sigma , kernel_size )
    %% solution
    G_1D = gauss1D(sigma, kernel_size);
    G = G_1D' * G_1D;
end
