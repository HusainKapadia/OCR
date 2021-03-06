function feat = feat_all(m)
    preproc = im_box([], 0, 1)*im_resize([], [24 30],'lanczos2')*im_box([],1,0);
    a = m * preproc;
    feat = im_features(a, a, 'all');
    disp('Done extracting features')
end