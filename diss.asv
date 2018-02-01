prwaitbar off    
prtime(600);

data = prnist(0:9, 1:1000);

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

labels = {'Decision Tree', 'Neural Network', 'SVM', 'Parzen', 'Fisher','LDC', 'QDC', 'Stacked mean combination'};
       
iter = 4;
frac = [0.01, 0.02, 0.04, 0.05, 0.08, 0.1, 0.2, 0.4];
%errors = zeros(size(classifiers,1),length(frac),iter);

errd = zeros(length(frac), size(classifiers,1));
err_vard = zeros(length(frac), size(classifiers,1));

for j = 1:length(frac)
    for k = 1:size(classifiers,1)
        disp(labels(k));
        errorList = [];
        for i = 1:iter
            A = gendat(data, frac(j));
            map = proxm(A,'d',2);

            D = A*map;
            [pca_map, ~] = pcam(D, 30);
            D = D*pca_map;
            Z = D*classifiers{k};
            
            errorList = [errorList nist_eval('feat_direct', map*pca_map*Z, 100)];
        end
        errd(j,k) = mean(errorList);
        err_vard(j,k) = sqrt(var(errorList));    
    end
end

figure();
for k = 1:size(classifiers,1)
    errorbar(1000*frac, errd(:,k), err_vard(:,k), 'DisplayName', labels{k})
    hold on;
end
xlabel('Training Size per Class')
ylabel('Test error')
title('Trained on Dissimilarities')
legend('show')

