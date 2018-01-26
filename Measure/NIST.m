%setup
prwaitbar off    
prtime(600);
    
data = prnist(0:9, 1:1000);
handwriteData = handwrittenPrnist();

%add scaled classifiers to classifiers list
w = [bpxnc([], [30], 15000) *classc svc([], proxm('p',3)) *classc ];
Cmax = w*maxc;            % max combiner
Cmin = w*minc;            % min combiner
Cmean = w*meanc;          % mean combiner

classifiers = { bpxnc([], [30], 15000);
                treec([]);
                svc([], proxm('p',3));
                parzenc([], 5);
                fisherc;
                loglc;
                ldc([],.5,.5);
                qdc([],.5,.5);
                nmc;
                Cmax;
                Cmin;
                Cmean
               };

global_data_frac_mult = 0.05;

 
%%
%TODO: Auto PCA dim
%PCA values
pcaErrorValues = [];
pcaErrorValuesVar = [];
feat_rep = 'feat_direct';

for i = 1:2:50
    errorList = [];
    
    for i=1:4
        train_struct = getProcessedData(data, feat_rep, 0.25 * global_data_frac_mult, i);
        errorList = [errorList rec101(train_struct, classifiers{4}, feat_rep, 0, [])];
    end
    
    error = mean(errorList);
    errorVar = sqrt(var(errorList));
    
    disp(['Pca dim: ', num2str(i), ', error: ', num2str(error), 'var: ', num2str(errorVar)]);
    
    pcaErrorValues = [pcaErrorValues error];
    pcaErrorValuesVar = [pcaErrorValuesVar errorVar];
end

%%
errorbar(pcaErrorValues, pcaErrorValuesVar);

%%
%Neural net stuff
%TODO: NN can get stuck, and produce a classifier with error >0.9. Do we
%discard those?
%TODO: Auto plug best neural network
% gest best NN dimension
nnError1 = [];
nnError2 = [];
nnError3 = [];
nnError4 = [];



sizes = 20;
trials = 5;
nnErrors = zeros(sizes, 4, 5);

for nnSize = 1:sizes
    mult = nnSize / (sizes - 1) * 3.75 + 0.25;

    nets = [
            bpxnc([], round([10 5 10] * mult), 15000);
            bpxnc([], round([10] * mult), 15000);
            bpxnc([], round([5 10 5] * mult), 15000);
            bpxnc([], round([10 10] * mult), 15000)
            
            ];
    
    for i=1:4
        for j=1:trials
            train_struct = getProcessedData(data, 'feat_direct', 0.25 * global_data_frac_mult, 22);
             nnErrors(nnSize, i, j) = rec101(train_struct, nets{i}, feat_rep, 0, []);
        end
    end
end

%%
errorMean = zeros(4, sizes);
errorDev = zeros(4, sizes);

for nnSize = 1:sizes
    for i=1:4
        errorMean(i, nnSize) = mean(nnErrors(nnSize, i, :));
        errorDev(i, nnSize) = std(nnErrors(nnSize, i, :));
    end
end


errorbar(errorMean(1, :), errorDev(1, :), 'Displayname', '10-5-10');
hold on;

errorbar(errorMean(2, :), errorDev(2, :), 'Displayname', '10');
hold on;

errorbar(errorMean(3, :), errorDev(3, :), 'Displayname', '5-10-5');
hold on;

errorbar(errorMean(4, :), errorDev(4, :), 'Displayname', '10 10');
hold on;

legend('show');

%plot(nnError1, );
%hold on;

%plot(nnError2, 'Displayname', '2');
%hold on;

%plot(nnError3, 'Displayname', '3');
%hold on;

%plot(nnError4, 'Displayname', '4');

%%
labels = {'Neural Network', 'Decision Tree', 'SVM', 'Parzen', 'Fisher', 'Logistic classifier', 'LDC', 'QDC', 'NMC', 'Stacked max combination', 'Stacked min combination', 'Stacked mean combination'};


%%

iter = 4;
frac = [0.01, 0.02, 0.04, 0.05, 0.08, 0.1, 0.2, 0.4];

err = zeros(length(frac), size(classifiers,1));
err_var = zeros(length(frac), size(classifiers,1));

for j = 1:length(frac)
   
    for k = 1:size(classifiers,1)
        disp(labels(k));
        errorList = [];
        
        for i = 1:iter
            train_struct = getProcessedData(data, 'feat_direct', frac(j) * global_data_frac_mult, 24);
            errorList = [errorList rec101(train_struct, classifiers{k}, 'feat_direct', 0, [])];
        end
        
        err(j,k) = mean(errorList);
        err_var(j,k) = sqrt(var(errorList));    
    end
end


%%
figure();
for k = 1:9
    errorbar(frac * 1000 * global_data_frac_mult, err(:,k), err_var(:,k), 'DisplayName', labels{k})
    hold on;
end
legend('show')

figure;
for k = 10:12
    errorbar(frac * 1000 * global_data_frac_mult, err(:,k), err_var(:,k), 'DisplayName', labels{k})
    hold on;
end

legend('show')

%%
%total results
results = zeros(2, 3, length(classifiers));
resultsHandwritten = zeros(2, 3, length(classifiers));

for scenario = 1:2
    if scenario == 1
        data_frac = 0.5;
    else
        data_frac = 0.01 / global_data_frac_mult;
    end

    for rep = 1:3
        switch rep
            case 1 
                feat_rep = 'feat_direct';
            case 2 
                feat_rep = 'feat_all';
            case 3 
                feat_rep = 'f'; 
        end

        %TODO: We need to run this a few times to get an average. 
        for cl = 1:length(classifiers)
             train_struct = getProcessedData(data, feat_rep, data_frac * global_data_frac_mult, 22);
            [results(scenario, rep, cl), resultsHandwritten(scenario, rep, cl)] = rec101(train_struct, classifiers{cl}, feat_rep, 1, handwriteData); 
        end
    end
end