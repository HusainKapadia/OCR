function performance = rec101(train_struct, classifier, feat_func)
    w = train_struct.data * classifier;
    scaledW = train_struct.scale * train_struct.pca * w;   
    performance = nist_eval(feat_func, scaledW, 100);
    fprintf("Classifier performance is %f \n", performance);
end