prwaitbar off    
prtime(600);
delfigs
% A = sonar;   % 60 dimensional dataset
% train_data = A;
data_repr = 'feat_all';
data_fraction = 0.1;
[data, ~] = gendat(prnist(0:9, 1:1000), data_fraction);
%classifiers = { perlc, treec, bpxnc, svc, fisherc, loglc, ldc, qdc, nmc};

% convert to dataset and features
f = str2func(data_repr);
train_data = f(data);  
scaling = scalem(train_data, 'c-variance');
train_data = train_data * scaling;
% compute feature curve for the original feature ranking
% train_data = A;
% classifiers = {nmc,ldc,qdc,knnc};
classifiers = {nmc};
% feat_sizes = [1 5 10 15 20 30 50 100 500 1000 1500 1700];
feat_sizes = [1 5 10];
train_size = 0.7;
n_reps = 5;

% E = clevalf(train_data, classifiers, feat_sizes, train_size, n_reps, []);

% E = 


E = getFeatureCurveErrors(train_data, classifiers, feat_sizes, train_size, n_reps)
disp(E);

figure; plote(E); title('Original'); axis([1 10 0 0.5])
% 
% 
% % Compute feature curve for a randomized feature ranking
% % R = randperm(60);
% % train_data = train_data(:,R)
% % E = clevalf(train_data, classifiers, feat_sizes, train_size, n_reps);
% % figure; plote(E); title('Random'); axis([1 60 0 0.5])
% % 
% % % Compute feature curve for an optimized feature ranking
% % W = train_data * featself('maha-m', 60);
% % train_data = train_data * W;
% % E = clevalf(train_data, classifiers, feat_sizes, train_size, n_reps);
% % figure; plote(E); title('Optimized (Maha)'); axis([1 60 0 0.5])
% 
% showfigs
CHECK_SIZES = false;

[W, K] = featselm

function feat_struct = getFeatureCurveErrors(train_data, classifiers,feat_sizes, train_size, n_reps)
    errors = zeros(length(classifiers), length(feat_sizes));
    
    for i = 1: size(classifiers, 2)
        for j = 1: size(feat_sizes, 2)
            clf = classifiers{i};
            % trian classifier
            s = feat_sizes(j);
            [W, K] = featselm(train_data, 'NN', 'forward', s);
            C = train_data * clf;
            C = W * C;
            perf = nist_eval('feat_all', C, 100);
            errors(i, j) = perf;
        end
    end
    
    feat_struct.title = 'Feature curve for NIST';
    feat_struct.error = errors;
    feat_struct.xvalues = feat_sizes;
    feat_struct.ylabel = sprintf('Averaged error (%s experiments)', n_reps);

end