function performance = rec101(nist, classifier, feat_func, dataFraction, testObjects)
    prwaitbar off
    
    numTests = 1;
    prtime(600);
    
    [nist_dat, test_data] = gendat(nist, dataFraction);
    f = str2func(feat_func);
    
    %todo: How to vary
    for i = 1:numTests
        disp("Got training data. Size: ");
        disp(size(nist_dat));
        
        train_data = f(nist_dat);       
        scaling = scalem(train_data, 'c-variance');
        train_data = train_data * scaling;
        
        [pca_map, frac] = pcam(train_data, 30);

        % Return the dataset after performing PCA
        train_data = train_data * pca_map;
        
        disp("Generated features");
        disp(size(train_data));
      
        w = train_data * classifier;
       
        disp("Trained classifier");
   
        performance = nist_eval(feat_func, scaling * pca_map * w, testObjects);

        disp("Done");
        disp(performance);
    end
end