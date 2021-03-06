%setup
prwaitbar off    
prtime(600);
    
data = prnist(0:9, 1:1000);
handwriteData = handwrittenPrnist();

%add scaled classifiers to classifiers list
w = [bpxnc([], [30], 15000) *classc svc([], proxm('p')) *classc ];
Cmean = w*meanc;          % mean combiner

classifiers = { bpxnc([], [30], 15000);
                treec([]);
                svc([], proxm('p'));
                parzenc([], 5);
                fisherc;
                ldc([],.5,.5);
                qdc([],.5,.5);
                Cmean
               };
labels = {'Neural Network', 'Decision Tree', 'SVM', 'Parzen', 'Fisher', 'LDC', 'QDC', 'Stacked mean combination'};

global_data_frac_mult = 0.5;
bestPca = 22;
 
%%
%TODO: Auto PCA dim
%PCA values
pcaErrorValues = [];
pcaErrorValuesVar = [];
feat_rep = 'feat_direct';

bestPca = 1;
minPcaError = 10000;

%%
for i = 1:2:40
    errorList = [];
    
    for r=1:4
        train_struct = getProcessedData(data, feat_rep, 0.25 * global_data_frac_mult, i);
        errorList = [errorList rec101(train_struct, classifiers{1}, feat_rep, 0, [])];
    end
    
    error = mean(errorList);
    errorVar = sqrt(var(errorList));
    
    disp(['Pca dim: ', num2str(i), ', error: ', num2str(error), ' var: ', num2str(errorVar)]);
   
    if error < minPcaError
       bestPca = i;
       minPcaError = error; 
    end
        
    pcaErrorValues = [pcaErrorValues error];
    pcaErrorValuesVar = [pcaErrorValuesVar errorVar];
end

%%
errorbar(pcaErrorValues, pcaErrorValuesVar);

%%
% Neural net stuff
% TODO: NN can get stuck, and produce a classifier with error >0.9. Do we
% discard those?
% TODO: Auto plug best neural network
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
            train_struct = getProcessedData(data, 'feat_direct', 0.25 * global_data_frac_mult, bestPca);
            nnErrors(nnSize, i, j) = rec101(train_struct, nets{i}, feat_rep, 0, []);
        end
    end
    
    disp(['NN round ', num2str(nnSize), ' done']); 
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
frac = [0.01, 0.015, 0.03, 0.04, 0.06, 0.08, 0.1, 0.2, 0.4];

learnCurveErr = zeros(length(frac), size(classifiers,1));
learnCurveErrVar = zeros(length(frac), size(classifiers,1));

%%
%TODO: COmbined is not done yet....
for k = 1:length(classifiers)
    for j = 1:length(frac)
        errorList = [];
        
        for i = 1:3
            train_struct = getProcessedData(data, 'feat_direct', frac(j) * global_data_frac_mult, bestPca);
            
            [e, eh] = rec101(train_struct, classifiers{k}, 'feat_direct', 0, []);
            errorList = [errorList e];
        end
        
        learnCurveErr(j,k) = mean(errorList);
        learnCurveErrVar(j,k) = std(errorList); 
        
        disp(['Round done: ', labels{k}, ', ', num2str(frac(j)), ' -> ', num2str(mean(errorList)), ' +- ', num2str(std(errorList))]);
    end
end


%%
figure();
for k = 1:length(classifiers)
    errorbar(frac * 1000, learnCurveErr(:,k), learnCurveErrVar(:,k), 'DisplayName', labels{k})
    hold on;
end
legend('show')


%%
%total results
results = zeros(2, 3, length(classifiers));
resultsVar = zeros(2, 3, length(classifiers));

resultsHandwritten = zeros(2, 3, length(classifiers));
resultsHandwrittenVar = zeros(2, 3, length(classifiers));

%%
for scenario = 1:2
    if scenario == 1
        data_frac = 0.9;
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
                feat_rep = 'feat_direct'; 
        end
        
        for cl = 1:length(classifiers)
            err = [];
            errHandwritten = [];
            
            for r=1:3
                train_struct = getProcessedData(data, feat_rep, data_frac * global_data_frac_mult, bestPca, rep == 3);
                
                [ec, ech] = rec101(train_struct, classifiers{cl}, feat_rep, 1, handwriteData); 
                
                err = [err; ec];
                errHandwritten = [errHandwritten; ech];
            end
            
            results(scenario, rep, cl) = mean(err);
            resultsVar(scenario, rep, cl) = std(err);
            
            resultsHandwritten(scenario, rep, cl) = mean(errHandwritten);
            resultsHandwrittenVar(scenario, rep, cl) = std(errHandwritten);
            
            disp(['Round done (', num2str(scenario), ', ', feat_rep, ', ', labels{cl}, ')']);
            disp(['Performance: ', num2str( mean(err)), ' +- ', num2str(std(err))]);
            disp(['Performance handwritten: ', num2str(mean(errHandwritten)), ' +- ', num2str( std(errHandwritten))]);

        end
    end
end
