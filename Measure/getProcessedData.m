function train_struct = getProcessedData(nist, feat_func, data_fraction, pcaDim, pcaMap)
    [nist_dat, ~] = gendat(nist, data_fraction);
    f = str2func(feat_func);
     
    train_data = f(nist_dat);       
    scaling = scalem(train_data, 'c-variance');
    train_data = train_data * scaling;

    %TODO: Try different PCA sizes / no PCA
    
    if nargin == 4
        [pcaMap, ~] = pcam(train_data, pcaDim);
    end
    
    % Return the dataset after performing PCA
    train_data = train_data * pcaMap;
    
    train_struct.data = train_data;
    train_struct.scale = scaling;
    train_struct.pca = pcaMap;
end