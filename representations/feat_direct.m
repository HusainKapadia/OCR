function a = feat_direct(m)
   % Preprocess the digits
    preproc = im_box([], 0, 1)*im_resize([], [8 10],'lanczos2')*im_box([],1,0);
    a = m * preproc;
    a = prdataset(a, getlabels(m)); 
end