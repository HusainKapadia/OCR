function performance = rec101(train_struct, classifier, feat_func, testHandwrite, train_struct_handwritten)

    if testHandwrite <= 0
        w = train_struct.data * classifier;
        scaledW = train_struct.scale * train_struct.pca * w;   
    
        performance = nist_eval(feat_func, scaledW, 100);
    else    
        
        w = train_struct.data * classifier;  
        performance = testc(train_struct_handwritten.data, w);
    end
    
    fprintf("Classifier performance is %f \n", performance);
end