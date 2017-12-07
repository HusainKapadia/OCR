function [performance, error] = rec101(nist, feat_func, verbose)
    prwaitbar off
    
    numTests = 1;
    numObjects = 100;
    
    prtime(60);
    
    for i = 1:numTests
        f = str2func(feat_func);

        [nist_dat, test_data] = gendat(nist, 0.4);
        

        disp("Got training data. Size: ");
        disp(size(nist_dat));
        
        train_data_unscaled = f(nist_dat);

        
         %test_data_unscaled = f(test_data);
       
         disp("Generated features");
         disp(size(train_data_unscaled));
        
        %TODO: why c-mean?
        scaling = scalem(train_data_unscaled, 'c-variance');
     

        %test_data_scaled = test_data_unscaled * scaling;
        
        disp("Scaled features");
     
        for j = 5:30
            w = bpxnc(train_data_scaled, [60 30 15], 5000);
            %w = svc(train_data_scaled, proxm('p',3));
            
            
            disp("Trained classifier");

            performance = nist_eval(feat_func, w, numObjects);
            %error  = testc(test_data_scaled, w);

            disp("Done");

            disp(performance);
        end
    end
end