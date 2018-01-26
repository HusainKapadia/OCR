function [performance, performanceHandwriting] = rec101(train_struct, classifier, feat_func, testHandwriting, handwriteRaw)

    w = train_struct.data * classifier;
    scaledW = train_struct.scale * train_struct.pca * w;   
    %scaledW = train_struct.pca * w;
    %scaledW = train_struct.scale * w;
    
    performance = nist_eval(feat_func, scaledW, 100);
    
    
    performanceHandwriting = 0;
    
    if testHandwriting > 0
        
        f = str2func(feat_func);
        handwriteData = f(handwriteRaw); 
        %TODO: Why is perf so terrible?
        [performanceHandwriting, digitPerf] = testd(handwriteData, scaledW);
    end  
end