prwaitbar off    
prtime(600);
    
data = prnist(0:9, 1:1000);

classifiers = { perlc([]);
                knnc([], 5); 
                treec([]);
                bpxnc([], [60], 50000);
                svc([], proxm('p',3))
               };

if 1
    pcaErrorValues1 = [];
    data_frac = 0.01;
    
    feat_rep = 'feat_direct';

    inc = 10;
    
    for pcaDim = 10:1:30
        train_struct = getProcessedData(data, feat_rep, data_frac, pcaDim);
        error1 = rec101(train_struct, classifiers{4}, feat_rep);
        pcaErrorValues1 = [pcaErrorValues1 error1];
    end

    plot(pcaErrorValues1);
end

% gest best NN dimension
if 0
    pcaErrorValues1 = [];
    pcaErrorValues2 = [];
    pcaErrorValues3 = [];
    pcaErrorValues4 = [];
    
    data_frac = 0.01;
    
    feat_rep = 'feat_direct';
    train_struct = getProcessedData(data, feat_rep, data_frac, 32);
        
    inc = 10;
    
    for pcaDim = 10:5:120
        mult = pcaDim / 40;
        
        %cl1 = bpxnc([], round([20 10 20] * mult), 25000);
        cl2 = bpxnc([], round([20] * mult), 25000);
        %cl3 = bpxnc([], round([10 20 10] * mult), 25000);
        cl4 = bpxnc([], round([20 20] * mult), 25000);
        
        %error1 = rec101(train_struct, cl1, feat_rep);
        error2 = rec101(train_struct, cl2, feat_rep);
        %error3 = rec101(train_struct, cl3, feat_rep);
        error4 = rec101(train_struct, cl4, feat_rep);
        
        %pcaErrorValues1 = [pcaErrorValues1 error1];
        pcaErrorValues2 = [pcaErrorValues2 error2];
        %pcaErrorValues3 = [pcaErrorValues3 error3];
        pcaErrorValues4 = [pcaErrorValues4 error4];

    end

    plot(pcaErrorValues1, 'Displayname', '1');
    hold on;
    
    plot(pcaErrorValues2, 'Displayname', '2');
    hold on;
    
    plot(pcaErrorValues3, 'Displayname', '3');
    hold on;
    
    plot(pcaErrorValues4, 'Displayname', '4');
    legend('show');
    
end


%scenario 1 & 2 full run.
if 0
    results = zeros(2, 3, 5);

    for scenario = 1:2

        if scenario == 1
            data_frac = 0.2;
        else
            data_frac = 0.01;
        end

        for rep = 1:3
            switch rep
                case 1 
                    feat_rep = 'feat_direct';
                case 2 
                    feat_rep = 'feat_filter';
                case 3 
                    feat_rep = 'feat_all'; 
            end

            train_struct = getProcessedData(data, feat_rep, data_frac, 20);

            for cl = 1:5
                results(scenario, rep, cl) = rec101(train_struct, classifiers{cl}, feat_rep); 
            end
        end
    end

    disp(results);
end




%%%%%%%
%Learning size curve runs
if 0 
    test_count = 10;

    nn_perf = zeros(test_count);
    svc_perf = zeros(test_count);
    linear_perf = zeros(test_count);
    tree_perf = zeros(test_count);
    knnc_perf = zeros(test_count);

    for i = 1:test_count
        data_frac = i / test_count * 0.1;
        feat_rep = 'feat_direct';
        train_data = getProcessedData(data, feat_rep, data_frac, 30);

        linear_perf(i) = rec101(train_data, classifiers{1}, feat_rep);
        knnc_perf(i) = rec101(train_data, classifiers{2}, feat_rep);
        tree_perf(i) = rec101(train_data, classifiers{3}, feat_rep);
        nn_perf(i) = rec101(train_data, classifiers{4}, feat_rep);
        svc_perf(i) = rec101(train_data, classifiers{5}, feat_rep);

        disp(["Neural network performance: ", nn_perf(i)]);
        disp(["Support vector machine performance: ", svc_perf(i)]);
        disp(["Linear Perceptron performance: ", linear_perf(i)]);
        disp(["Binary Tree performance: ", tree_perf(i)]);
        disp(["K-NN performance: ", knnc_perf(i)]);
    end

    plot([nn_perf, svc_perf]);
end

%TODO: Cost curve run