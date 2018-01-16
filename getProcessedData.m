function train_struct = getProcessedData(nist, feat_func, data_fraction, pcaDim)
    [nist_dat, ~] = gendat(nist, data_fraction);
    f = str2func(feat_func);
    
<<<<<<< HEAD
    fprintf("Got training data. Size: %d %d \n", size(nist_dat,1), size(nist_dat,2));
    
=======

>>>>>>> b3b0021083c77cc36b06718a838cd2d4ff9780eb
    train_data = f(nist_dat);       
    scaling = scalem(train_data, 'c-variance');
    train_data = train_data * scaling;

    %TODO: Try different PCA sizes / no PCA
<<<<<<< HEAD
    [pca_map, ~] = pcam(train_data, 30); %30 in case of feat_direct
=======
    [pca_map, ~] = pcam(train_data, pcaDim);
>>>>>>> b3b0021083c77cc36b06718a838cd2d4ff9780eb

    fprintf("Got training data. Size: %d %d \n", size(train_data, 1), size(train_data, 2));
    
    
    % Return the dataset after performing PCA
    train_data = train_data * pca_map;
    
    train_struct.data = train_data;
    train_struct.scale = scaling;
    train_struct.pca = pca_map;
<<<<<<< HEAD
    
    disp(train_struct);
    disp('Will start training classifier');
=======
>>>>>>> b3b0021083c77cc36b06718a838cd2d4ff9780eb
end