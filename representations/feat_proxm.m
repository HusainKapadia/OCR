function a = feat_proxm(m)
    % Preprocess the digits
    preproc = im_box([], 0, 1)*im_resize([], [8 10],'lanczos3')*im_box([],1,0);
    a = m * preproc;
    a = prdataset(a, getlabels(m)); 
    
    map = proxm(a, 'd', 2);
    a = a * map;
    
    a = prdataset(a, getlabels(m));
end