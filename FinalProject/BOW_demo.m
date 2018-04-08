function BOW_demo( d_or_s, sift_type, vocab_size, sample_size)
    % demo runs all steps of BOW
    
    % options for parameters:
    % d_or_s = ['sift', 'dsift']
    % sift_type = ['RGB', 'nrgb', 'opponent']
    % vocab_size = # of histogram bins
    % sample_size = # of training images used for classification
    
    % if none/not all parameters are given, use those from the best
    if nargin<4
        sample_size = 250;
    end
    if nargin<3
        vocab_size = 800;
    end
    if nargin<2
        sift_type = 'opponent';
    end
    if nargin<1
        d_or_s = 'dsift';
    end
    
    % create visual vocabulary
    disp('building visual vocabulary');
    [C, A] = bow_build_vocab(d_or_s, sift_type, vocab_size);
    
    % safe visual vocabulary for easier later use
    vocabfile = sprintf('%s%s%s%s%d', d_or_s, '-', sift_type, '-', vocab_size);
    save(vocabfile, 'C', 'A');
    
    % obtain histograms, train liblinear SVM and evaluate on test images
    disp('training and evaluation');
    [MAP] = evaluate(d_or_s, sift_type, vocab_size, sample_size);
    disp(MAP);
    
    % generate a HTML from the results
    disp('generating HTML');
    html_file = sprintf('%s%s%s%s%d%s%d', d_or_s, '-', sift_type, '-', vocab_size, '-', sample_size);
    disp(html_file);
    generate_html(html_file);

        
end