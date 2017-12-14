data = prnist(0:9, 1:1000);

%TODO: Try more feature representations
%TODO: Try other filters


%TODO: Make a learning curve
%TODO: Try different PCA sizes / no PCA


test_objects = 100;
data_frac = 0.05;

feat_rep = 'feat_direct';

test_count = 10;

nn_perf = zeros(test_count);
svc_perf = zeros(test_count);
linear_perf = zeros(test_count);
tree_perf = zeros(test_count);
knnc_perf = zeros(test_count);

for i = 1:test_count
    data_frac = i / 100;
    
    nn_perf(i) = rec101(data, bpxnc([], [20 10 5], 15000), feat_rep, data_frac, test_objects);
    svc_perf(i) = rec101(data, svc([], proxm('p',3)), feat_rep, data_frac, test_objects);
    linear_perf(i) = rec101(data, perlc([]), feat_rep, data_frac, test_objects);
    tree_perf(i) = rec101(data, treec([]), feat_rep, data_frac, test_objects);
    knnc_perf(i) = rec101(data, knnc([], 5), feat_rep, data_frac, test_objects);

    disp("Neural network performance: ")
    disp(nn_perf(i));

    disp("Support vector machine performance: ");
    disp(svc_perf(i));

    disp("Linear Perceptron performance: ");
    disp(linear_perf(i));   

    disp("Binary Tree performance: ");
    disp(tree_perf(i));

    disp("K-NN performance: ");
    disp(knnc_perf(i));
end


plot(svc_perf);