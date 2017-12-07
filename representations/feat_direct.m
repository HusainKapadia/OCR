function a = feat_direct(m)
   %TODO: Preprocessing?
   preproc = im_box([], 1, 0);
   
   a = preproc * m;
   a = prdataset(a, getlabels(m));
end
