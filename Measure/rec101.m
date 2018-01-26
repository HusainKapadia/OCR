function [performance, performanceHandwriting] = rec101(train_struct, classifier, feat_func, testHandwriting, train_struct_handwritten)

    w = train_struct.data * classifier;
    scaledW = train_struct.scale * train_struct.pca * w;   
    performance = nist_eval(feat_func, scaledW, 100);
    
    
    fprintf("Classifier performance is %f \n", performance);
    performanceHandwriting = 0;
    
    if testHandwriting > 0      
        %TODO: Is this the right performance indicator?
        %TODO: Why is perf so terrible?
        performanceHandwriting = testc(train_struct_handwritten.data, w);
        
        fprintf("Classifier performance (hand written) is %f \n", performanceHandwriting);
    end
    
end