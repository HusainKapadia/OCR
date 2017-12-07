data = prnist(0:9, 1:1000);

%TODO: Try more feature representations
%TODO: Try scaling images
%TODO: Try other filters

rec101(data, 'feat_all')





%prwaitbar off
% show(data);
% 
% 
% 
features = my_rep(data);
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