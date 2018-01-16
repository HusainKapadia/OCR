function a = feat_filter(m)
    %feature extraction
    features = im_features(m, {"FilledArea", 
                                    "Perimeter", 
                                    "Eccentricity",
                                    "Solidity"});

   %TODO: Try measure
                                
    %TODO: Combine in means

    %means = im_mean(data);
    a = features;
end
