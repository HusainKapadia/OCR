function a = feat_all(m)
    %feature extraction
    features = im_features(m, {"FilledArea", 
                                    "Perimeter", 
                                    "Eccentricity",
                                    "Solidity" });
                                
    %TODO: Combine in means

    %means = im_mean(data);
    a = features;
end
