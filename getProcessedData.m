function train_struct = getProcessedData(nist, feat_func, data_fraction)
    [nist_dat, ~] = gendat(nist, data_fraction);
    f = str2func(feat_func);
    
    disp(["Got training data. Size: ", size(nist_dat)]);
    
    train_data = f(nist_dat);       
    scaling = scalem(train_data, 'c-variance');
    train_data = train_data * scaling;

    %TODO: Try different PCA sizes / no PCA
    [pca_map, ~] = pcam(train_data, 30);

    % Return the dataset after performing PCA
    train_data = train_data * pca_map;
    
    train_struct.data = train_data;
    train_struct.scale = scaling;
    train_struct.pca = pca_map;
    
    disp(train_struct);
end