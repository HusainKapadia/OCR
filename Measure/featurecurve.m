delfigs

classifiers = {nmc,ldc,qdc,knnc};

feat_sizes = [1 5 10];
feat_rep = 'feat_all';
train_size = 0.7;
n_reps = 5;

E = getFeatureCurveErrors(classifiers, feat_rep, feat_sizes, train_size, n_reps);
disp(E);
figure; plote(E); title('Original'); 

showfigs

function feat_struct = getFeatureCurveErrors(classifiers,feat_rep, feat_sizes, train_size, n_reps)
    errors = zeros(length(classifiers), length(feat_sizes));
    data_fraction = 0.1;

    for i = 1: size(classifiers, 2)
        % get data
        [data, ~] = gendat(prnist(0:9, 1:1000), data_fraction);
        % get classifier
        clf = classifiers{i};
        % get features
        f = str2func(feat_rep);
        train_data = f(data);
        
        % for each feature size
        for j = 1: size(feat_sizes, 2)
            % get size
            s = feat_sizes(j);
%            
%             scaledW = train_struct.scale * train_struct.pca * w;   
            % select features
            [mapping, K] = featself(train_data, 'NN', s);
%             disp(K);
            trn_featsel = train_data * mapping;

            % train classifier
            w_nmc = clf(trn_featsel);
            w_nmc_map = mapping*w_nmc;
    
            % store error
            perf = nist_eval('feat_all', w_nmc_map, 100);
            disp(perf);
            errors(i, j) = perf;
        end
    end
    
    disp(errors);
    
    feat_struct.title = 'Feature curve for NIST';
    feat_struct.error = errors;
    feat_struct.xvalues = feat_sizes;
    feat_struct.ylabel = sprintf('Averaged error (%s experiments)', n_reps);
end