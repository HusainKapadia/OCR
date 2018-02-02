prwaitbar off    
prtime(600);
    
data = prnist(0:9, 1:1000);
%handwriteData = handwrittenPrnist();

%add scaled classifiers to classifiers list
w = [bpxnc([], [30], 15000) *classc svc([], proxm('p',3)) *classc ];
Cmax = w*maxc;            % max combiner
Cmin = w*minc;            % min combiner
Cmean = w*meanc;          % mean combiner

classifiers = { knnc([], 5); 
                treec([]);
                bpxnc([], [30], 15000);
                svc([], proxm('p',3));
                parzenc([], 5);
                fisherc;
                ldc([],.5,.5);
                qdc([],.5,.5);
                Cmean;
               };

labels = {'K=NN', 'Decision Tree', 'Neural Network', 'SVM', 'Parzen', 'Fisher', 'LDC', 'QDC', 'Stacked mean combination'};
       
iter = 4;
frac = [0.01, 0.015, 0.03, 0.04, 0.06, 0.08, 0.1, 0.2, 0.4];

err = zeros(length(frac), size(classifiers,1));
%err_var = zeros(length(frac), size(classifiers,1));

for j = 1:length(frac)
    for k = 1:size(classifiers,1)
        disp(labels(k));
        disp(j)
        %errorList = [];
        %for i = 1:iter
            train_struct = getProcessedData(data, 'feat_direct', frac(j), 30, 1);
            %errorList = [errorList rec101(train_struct, classifiers{k}, 'feat_proxm', 0, [])];
        %end
        err(j,k) = rec101(train_struct, classifiers{k}, 'feat_direct', 0, []);%mean(errorList);
        %err_var(j,k) = sqrt(var(errorList));    
    end
end

figure();
for k = 1:size(classifiers,1)
    plot(1000*frac, err(:,k), 'DisplayName', labels{k})
    hold on;
end
xlabel('Training Size per class')
ylabel('Test Error')
title('Trained on Dissimilarities')
legend('show')
 