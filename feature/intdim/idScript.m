stddev_pre = 3;
gSz_pre    = round(2.65*2.355*stddev_pre);
%
stddev     = 5;
fwhm       = 2.355*stddev;
gSz        = round(2.65*fwhm);


[t,c]  = tensor(double(img),[gSz,stddev],[gSz_pre,stddev_pre]);

[i2d, i1d, i0d] = tc2id(t,c);

[res(:,:,1), res(:,:,2), res(:,:,3)] = deal(i2d,i1d,i0d);

imwrite(res,'id.bmp');