prwaitbar off    
prtime(600);
    
data = prnist(0:9, 1:1000);
handwriteData = handwrittenPrnist();

%add scaled classifiers to classifiers list
w = [bpxnc([], [40 30], 15000) *classc svc([], proxm('p',3)) *classc ];
Cmax = w*maxc;            % max combiner
Cmin = w*minc;            % min combiner
Cmean = w*meanc;          % mean combiner

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
                Cmax;
                Cmin;
                Cmean;
               };

labels = {'Linear Perceptron', '5-nn', 'Decision Tree', 'Neural Network', 'SVM', 'Parzen', 'Fisher', 'Logistic classifier', 'LDC', 'QDC', 'NMC', 'Stacked max combination', 'Stacked min combination', 'Stacked mean combination'};
       
iter = 4;
frac = [0.01, 0.02, 0.04, 0.05, 0.08, 0.1, 0.2];
%errors = zeros(size(classifiers,1),length(frac),iter);

err = zeros(length(frac), size(classifiers,1));
err_var = zeros(length(frac), size(classifiers,1));

for j = 1:length(frac)
    for k = 1:size(classifiers,1)
        disp(labels(k));
        errorList = [];
        for i = 1:iter
            train_struct = getProcessedData(data, 'feat_direct', frac(j), 24);
            errorList = [errorList rec101(train_struct, classifiers{k}, 'feat_direct', 0, [])];
        end
        err(j,k) = mean(errorList);
        err_var(j,k) = sqrt(var(errorList));    
    end
end

figure();
for k = 1:11
    errorbar(1000*frac, err(:,k), err_var(:,k), 'DisplayName', labels(k))
    hold on;
end
legend('show')
figure();
for k = 11:14
    errorbar(1000*frac, err(:,k), err_var(:,k), 'DisplayName', labels(k))
    hold on;
end

legend('show')

% lin_per_perf = 
% knn_perf =
% tree_perf = 
% nn_perf = 
% svc_perf = 
% pz_perf =
% fsh_perf =
% log_perf = 
% ldc_perf =
% qdc_perf =
% nmc_perf = 
% Cmax_perf = 
% Cmin_perf =
% Cmean_perf = 