prwaitbar off    
prtime(600);
    
data = prnist(0:9, 1:1000);

classifiers = { perlc([]);
                knnc([], 5); 
                treec([]);
                bpxnc([], [40 60 30], 15000);
                svc([], proxm('p',3))
               };

results = zeros(2, 3, 5);

for scenario = 1:2
    
    if scenario == 1
        data_frac = 0.1;
    else
        data_frac = 0.01;
    end
    
    for rep = 1:3
        switch rep
            case 1 
                feat_rep = 'feat_direct';
            case 2 
                feat_rep = 'feat_direct';
            case 3 
                feat_rep = 'feat_direct'; 
        end

        train_struct = getProcessedData(data, feat_rep, data_frac);

        for cl = 1:5
            results(scenario, rep, cl) = rec101(train_struct, classifiers{cl}, feat_rep); 
        end
    end
end

disp(results);


%%%%%%%
%Learning size curve runs
test_count = 10;


nn_perf = zeros(test_count);
svc_perf = zeros(test_count);
linear_perf = zeros(test_count);
tree_perf = zeros(test_count);
knnc_perf = zeros(test_count);


for i = 1:test_count
    data_frac = i / test_count * 0.1;
    feat_rep = 'feat_direct';
    train_data = getProcessedData(data, feat_rep, data_frac);
    
    linear_perf(i) = rec101(train_data, classifiers(1), feat_rep);
    knnc_perf(i) = rec101(train_data, classifiers(2), feat_rep);
    tree_perf(i) = rec101(train_data, classifiers(3), feat_rep);
    nn_perf(i) = rec101(train_data, classifiers(4), feat_rep);
    svc_perf(i) = rec101(train_data, classifiers(5), feat_rep);
    
    disp(["Neural network performance: ", nn_perf(i)]);
    disp(["Support vector machine performance: ", svc_perf(i)]);
    disp(["Linear Perceptron performance: ", linear_perf(i)]);
    disp(["Binary Tree performance: ", tree_perf(i)]);
    disp(["K-NN performance: ", knnc_perf(i)]);
end

plot([nn_perf, svc_perf]);


%TODO: Cost curve run