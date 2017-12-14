data = prnist(0:9, 1:1000);

%TODO: Try more feature representations
%TODO: Try scaling images
%TODO: Try other filters

%TODO: Make a learning curve


test_objects = 100;
data_frac = 0.1;

nn_perf = rec101(data, bpxnc([], [20 10 5], 15000), 'feat_direct', data_frac, test_objects, true)
svc_perf = rec101(data, svc([], proxm('p',3)), 'feat_direct', data_frac, test_objects, true)

disp("Neural network performance: ")
disp(nn_perf);

disp("Support vector machine performance: ");
disp(svc_perf);



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