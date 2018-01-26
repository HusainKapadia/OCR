%setup
prwaitbar off    
prtime(600);
    
data = prnist(0:9, 1:1000);
handwriteData = handwrittenPrnist();

%add scaled classifiers to classifiers list
w = [bpxnc([], [40 30], 15000) *classc svc([], proxm('p',3)) *classc ];
Cmax = w*maxc;            % max combiner
Cmin = w*minc;            % min combiner

classifiers = { perlc([]);
                knnc([], 5); 
                treec([]);
                bpxnc([], [30], 15000);
                svc([], proxm('p',3));
                parzenc([], 5);
                fisherc;
                loglc;
                ldc([],.5,.5);
                qdc([],.5,.5);
                nmc;
                Cmax;
                Cmin;
               };
           
global_data_frac_mult = 0.05;

 
%%
%PCA values
pcaErrorValues = [];
pcaErrorValuesVar = [];
feat_rep = 'feat_direct';

for nn = 1:2:50
    train_struct = getProcessedData(data, feat_rep, 0.25 * global_data_frac_mult, nn);

    errorList = [];
    for i=1:4
        errorList = [errorList rec101(train_struct, classifiers{4}, feat_rep, 0, [])];
    end
    
    error = mean(errorList);
    errorVar = sqrt(var(errorList));
    
    disp(['Pca dim: ', num2str(nn), ', error: ', num2str(error), 'var: ', num2str(errorVar)]);
    
    pcaErrorValues = [pcaErrorValues error];
    pcaErrorValuesVar = [pcaErrorValuesVar errorVar];
end

%%
errorbar(pcaErrorValues, pcaErrorValuesVar);

%%
%Neural net stuff
% gest best NN dimension
nnError1 = [];
nnError2 = [];
nnError3 = [];
nnError4 = [];

train_struct = getProcessedData(data, 'feat_direct', 0.25 * global_data_frac_mult, 24);


sizes = 20;
trials = 7;
nnErrors = zeros(sizes, 4, 5);

for nnSize = 1:sizes
    mult = nnSize / sizes * 3.75 + 0.25;

    nets = [
            bpxnc([], round([20 10 20] * mult), 15000);
            bpxnc([], round([20] * mult), 15000);
            bpxnc([], round([10 20 10] * mult), 15000);
            bpxnc([], round([20 20] * mult), 15000)
            
            ];
    
    for i=1:4
        for j=1:trials
             nnErrors(nnSize, i, j) = rec101(train_struct, nets{i}, feat_rep, 0, []);
        end
    end
end

%%
errorMean = zeros(4, sizes);
errorDev = zeros(4, sizes);

for nnSize = 1:sizes
    mult = nnSize / sizes * 3.75 + 0.25;


    for i=1:4
        errorMean(i, nnSize) = mean(nnErrors(nnSize, i, :));
        errorDev(i, nnSize) = std(nnErrors(nnSize, i, :));
    end
end

%%
errorbar(errorMean(1, :), errorDev(1, :));
hold on;

errorbar(errorMean(2, :), errorDev(2, :));
hold on;

errorbar(errorMean(3, :), errorDev(3, :));
hold on;

errorbar(errorMean(4, :), errorDev(4, :));
hold on;


%plot(nnError1, 'Displayname', '1');
%hold on;

%plot(nnError2, 'Displayname', '2');
%hold on;

%plot(nnError3, 'Displayname', '3');
%hold on;

%plot(nnError4, 'Displayname', '4');
%legend('show');
  
%%
%total results
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

        for cl = 1:length(classifiers)
            results(scenario, rep, cl) = rec101(train_struct, classifiers{cl}, feat_rep); 
        end
    end
end

disp(results);

%%
%Live test


    %train_struct_handwritten = getProcessedData(handwriteData, feat_rep, 0.99999, pcaDim);


