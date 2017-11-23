prwaitbar off



data = prnist([0:9], [1:40:1000]);
% show(data);
% 
% 
% features = my_rep(data);
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
    untrainedNet =  bpxnc([], 40);
    eval = nist_eval('my_rep', untrainedNet)
    testc(my_rep(data), eval.data(1))
%end