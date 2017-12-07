function [performance, error] = rec101(nist, feat_func)
    prwaitbar off
    
    numTests = 1;
    numObjects = 40;
    
    for i = 1:numTests
        f = str2func(feat_func);
        
        [nist_dat, test_data] = gendat(nist, 0.8);
        disp("Got training data. Size: ");
        disp(size(nist_dat));
        
        train_data_unscaled = f(nist_dat);
        %test_data_unscaled = f(test_data);
        
        disp("Generated features");
        disp(size(train_data_unscaled));
        
        %TODO: why c-mean?
        
        scaling = scalem(train_data_unscaled, 'c-mean');
        %scaling1 = scalem(test_data_unscaled, 'c-mean');
        
        %TODO: TRy PCA on data and see if it helps
        
        
        train_data_scaled = train_data_unscaled * scaling;
        %test_data_scaled = test_data_scaled*scaling1;
        disp("Scaled features");
        
        %w = bpxnc(train_data_scaled, 30);
        w = svc(train_data_scaled, proxm('p',3));
        disp("Trained classifier");
        
        performance = nist_eval(feat_func, w, numObjects);
        error  = 1; %testc(test_data_scaled, w);
        disp("Done");
    end
end