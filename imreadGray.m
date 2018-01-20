function im = imreadGray(fileName)
    im = rgb2gray(imread(fileName));
    im = reshape(im, size(im, 1), size(im, 2));
    im = im2bw(im, 0.5);
end