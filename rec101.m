function performance = rec101(nist, feat_func, verbose)
    prwaitbar off
    
    numTests = 1;
    numObjects = 100;
    
    prtime(600);
    
    for i = 1:numTests
        f = str2func(feat_func);

        [nist_dat, test_data] = gendat(nist, 0.2);
        
        if verbose
            disp("Got training data. Size: ");
            disp(size(nist_dat));
        end
        
        train_data_unscaled = f(nist_dat);
        
         %test_data_unscaled = f(test_data);
       
        if verbose
            disp("Generated features");
            disp(size(train_data_unscaled));
        end
        
        scaling = scalem(train_data_unscaled, 'c-variance');
        train_data_scaled = train_data_unscaled * scaling;
        
        disp("Scaled features");
        

        
       % for j = 10:10:100
            
             % Perform PCA
            [pca_map, frac] = pcam(train_data_scaled, 40);
            % Return the dataset after performing PCA
            train_pca = train_data_scaled*pca_map;

            disp("Done PCA");
            disp(size(train_pca));
            
            w = bpxnc(train_pca, [20 10 5], 5000);
            %w = svc(train_data_scaled, proxm('p',3));
            
            
            disp("Trained classifier");
            
            w_pca = scaling*pca_map*w;

            performance = nist_eval(feat_func, w_pca, numObjects);
            
            if verbose
                disp("Done");
            end
            
            disp(performance);
        %end
    end
end