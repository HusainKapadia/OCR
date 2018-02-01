function train_struct = getProcessedData(nist, feat_func, data_fraction, pcaDim, doProxm)
    [nist_dat, ~] = gendat(nist, data_fraction);
    f = str2func(feat_func);
     
    train_data = f(nist_dat);       
    
    if nargin == 5 && doProxm
        proxMap = proxm(train_data, 'd', 2);
        train_data = train_data * proxMap;
    end
    
    scaling = scalem(train_data, 'c-variance');
    train_data = train_data * scaling;

    %TODO: Try different PCA sizes / no PCA
    [pcaMap, ~] = pcam(train_data, pcaDim);
    
    % Return the dataset after performing PCA
    train_data = train_data * pcaMap;
    
    train_struct.data = train_data;
    
    if nargin == 5 && doProxm
        train_struct.map = proxMap * scaling * pcaMap;
    else
        train_struct.map = scaling * pcaMap;
    end

end