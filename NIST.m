data = prnist(0:9, 1:1000);

%TODO: Try more feature representations
%TODO: Try other filters


%TODO: Make a learning curve
%TODO: Try different PCA sizes / no PCA

for i = 1:10

test_objects = 100;
data_frac = 0.5;

feat_rep = 'feat_direct';

nn_perf = rec101(data, bpxnc([], [20 10 5], 15000), feat_rep, data_frac, test_objects)
svc_perf = rec101(data, svc([], proxm('p',3)), feat_rep, data_frac, test_objects)
linear_perf = rec101(data, perlc([]), feat_rep, data_frac, test_objects)
tree_perf = rec101(data, treec([]), feat_rep, data_frac, test_objects)
knnc_perf = rec101(data, knnc([], 5), feat_rep, data_frac, test_objects)

disp("Neural network performance: ")
disp(nn_perf);

disp("Support vector machine performance: ");
disp(svc_perf);

disp("Linear Perceptron performance: ");
disp(linear_perf);

disp("Binary Tree performance: ");
disp(tree_perf);

disp("K-NN performance: ");
disp(knnc_perf);

end


%prwaitbar off
% show(data);
% 
% 
% 
%features = my_rep(data);
% 
% 
% %bbox = 

% 
% %normalize
% %normalized = ...; 
% 
% net = bpxnc(features, 12);
% 
% %TODO: Get 2D features
% scatterd(features, 'legend');
% 
% plotc(net);


%for i = 1:100
%     untrainedNet =  bpxnc([], [10 10]);
%     eval = nist_eval('my_rep', untrainedNet, 100);
%     testc(my_rep(data), eval.data(1))
%end