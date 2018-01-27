data = prnist(0:9, 1:1000);

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
            A = gendat(data, frac(j));
            pix = feat_direct(A);
            map = proxm(pix,'d',2);

            D = pix*map;
            [pca_map, ~] = pcam(D, 24);
            D = D*pca_map;
            Z = D*classifiers{k};
            
            errorList = [errorList nist_eval('feat_direct', map*pca_map*Z, 100)];
        end
        err(j,k) = mean(errorList);
        err_var(j,k) = sqrt(var(errorList));    
    end
end

figure();
for k = 1:11
    errorbar(10000*frac, err(:,k), err_var(:,k), 'DisplayName', labels{k})
    hold on;
end

legend('show')

figure();
for k = 12:14
    errorbar(10000*frac, err(:,k), err_var(:,k), 'DisplayName', labels{k})
    hold on;
end

legend('show')


