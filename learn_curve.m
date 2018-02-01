prwaitbar off    
prtime(600);
    
data = prnist(0:9, 1:1000);
%handwriteData = handwrittenPrnist();

%add scaled classifiers to classifiers list
w = [bpxnc([], [30], 15000) *classc svc([], proxm('p',3)) *classc ];
Cmax = w*maxc;            % max combiner
Cmin = w*minc;            % min combiner
Cmean = w*meanc;          % mean combiner

classifiers = { %perlc([]);
                %knnc([], 5); 
                treec([]);
                bpxnc([], [30], 15000);
                svc([], proxm('p',3));
                parzenc([], 5);
                fisherc;
                %loglc;
                ldc([],.5,.5);
                qdc([],.5,.5);
                %nmc;
                %Cmax;
                %Cmin;
                Cmean;
               };

labels = {'Decision Tree', 'Neural Network', 'SVM', 'Parzen', 'Fisher', 'LDC', 'QDC', 'Stacked mean combination'};
       
iter = 4;
frac = [0.01, 0.02, 0.04, 0.05, 0.08, 0.1, 0.2, .4];
%errors = zeros(size(classifiers,1),length(frac),iter);

err = zeros(length(frac), size(classifiers,1));
err_var = zeros(length(frac), size(classifiers,1));

for j = 1:length(frac)
    for k = 1:size(classifiers,1)
        disp(labels(k));
        disp(j)
        errorList = [];
        for i = 1:iter
            train_struct = getProcessedData(data, 'feat_all', frac(j), 15);
            errorList = [errorList rec101(train_struct, classifiers{k}, 'feat_all', 0, [])];
        end
        err(j,k) = mean(errorList);
        err_var(j,k) = sqrt(var(errorList));    
    end
end

figure();
for k = 1:size(classifiers,1)
    errorbar(1000*frac, err(:,k), err_var(:,k), 'DisplayName', labels{k})
    hold on;
end
xlabel('Training Size per class')
ylabel('Test Error')
title('Trained on features')
legend('show')
figure();
legend('show')
 