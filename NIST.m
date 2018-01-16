prwaitbar off    
prtime(600);
    
data = prnist(0:9, 1:1000);

classifiers = { perlc([]);
                knnc([], 5); 
                treec([]);
                bpxnc([], [40 30], 15000);
                svc([], proxm('p',3));
                parzenc([], 5);
                fisherc;
                loglc;
                ldc([],.5,.5);
                qdc([],.5,.5);
                nmc;
               };
% 
% results = zeros(2, 3, 5);
% 
% for scenario = 1:2
%     
%     if scenario == 1
%         data_frac = 0.1;
%     else
%         data_frac = 0.01;
%     end
%     
%     for rep = 1:3
%         switch rep
%             case 1 
%                 feat_rep = 'feat_direct';
%             case 2 
%                 feat_rep = 'feat_direct';
%             case 3 
%                 feat_rep = 'feat_direct'; 
%         end
% 
%         train_struct = getProcessedData(data, feat_rep, data_frac);
% 
%         for cl = 1:5
%             results(scenario, rep, cl) = rec101(train_struct, classifiers{cl}, feat_rep); 
%         end
%     end
% end
% 
% disp(results);


%%%%%%%
%Learning size curve runs
test_count = 10;

% 
% nn_perf = zeros(test_count);
% svc_perf = zeros(test_count);
% linear_perf = zeros(test_count);
% tree_perf = zeros(test_count);
% knnc_perf = zeros(test_count);
% 

%for i = 1:test_count
    data_frac = 2 / test_count;
    feat_rep = 'feat_direct';
    train_data = getProcessedData(data, feat_rep, data_frac);
    
%     linear_perf = rec101(train_data, classifiers{1}, feat_rep);
%     knnc_perf = rec101(train_data, classifiers{2}, feat_rep);
%     tree_perf = rec101(train_data, classifiers{3}, feat_rep);
%     nn_perf = rec101(train_data, classifiers{4}, feat_rep);
%     svc_perf = rec101(train_data, classifiers{5}, feat_rep);
%     pz_perf = rec101(train_data, classifiers{6}, feat_rep);
%     fsh_perf = rec101(train_data, classifiers{7}, feat_rep);
%     log_perf = rec101(train_data, classifiers{8}, feat_rep);
%     ldc_perf = rec101(train_data, classifiers{9}, feat_rep);
%     qdc_perf = rec101(train_data, classifiers{10}, feat_rep);
%     nmc_perf = rec101(train_data, classifiers{11}, feat_rep);
%     comb_perf = rec101(train_data, classifiers{4}*classc*classifiers{8}, feat_rep);
    
    %% stacked classifiers
    w1 = train_data.data * classifiers{4} *classc;
    w2 = train_data.data * classifiers{5} *classc;
    w = [w1 w2];
    Cmax = w*maxc;            % max combiner
    Cmin = w*minc;            % min combiner
    Cmean = w*meanc;          % mean combiner
    Cprod = w*prodc;          % product combiner
    scaledCmax = train_data.scale * train_data.pca * Cmax;   
    scaledCmin = train_data.scale * train_data.pca * Cmin;
    scaledCmean = train_data.scale * train_data.pca * Cmean;
    scaledCprod = train_data.scale * train_data.pca * Cprod;
    comb2_perf = nist_eval(feat_rep, scaledCmax, 100)
    comb3_perf = nist_eval(feat_rep, scaledCmin, 100)
    comb4_perf = nist_eval(feat_rep, scaledCmean, 100)
    comb5_perf = nist_eval(feat_rep, scaledCprod, 100)

    %% 
%     disp(["Linear Perceptron performance: ", linear_perf]);
%     disp(["K-NN performance: ", knnc_perf]);
%     disp(["Binary Tree performance: ", tree_perf]);
%     disp(["Neural network performance: ", nn_perf]);
%     disp(["Support vector machine performance: ", svc_perf]);    
%     disp(["Parzen classifier performance: ", pz_perf]);
%     disp(["fisher classifier performance: ", fsh_perf]);
%     disp(["Logistic Linear classifier performance: ", log_perf]);
%     disp(["Linear Bayes classifier performance: ", ldc_perf]);
%     disp(["Quadratic Bayes classifier performance: ", qdc_perf]);
%     disp(["Nearest mean classifier performance: ", nmc_perf]);
%     disp(["NN+SVM Cmax performance: ", comb2_perf]);
%end

%plot([nn_perf, svc_perf]);


%TODO: Cost curve run