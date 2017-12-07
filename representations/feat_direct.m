function a = feat_direct(m)
   % Preprocess the digits
    preproc = im_box([],0,1)*im_resize([], [10 12],'bicubic')*im_box([],1,0);
    a = m*preproc;
    
    a = prdataset(a, getlabels(m));
end
