function [ subband ] = spyrdecomp( img ,  scl_num, ort_num  )
% ========================================================================
% Download the Steerable pyramid toolbox from the following link:  
% http://www.cns.nyu.edu/pub/eero/matlabPyrTools.tar.gz 
%----------------------------------------------------------------------
img = double(img);
if (min(img(:)) < 0)
    img = img-min(img(:));
end
I = log(1+img);
filts = 'sp5Filters';
[lo0filt,hi0filt,lofilt,bfilts,steermtx,harmonics] = eval(filts);
fsz = round(sqrt(size(bfilts,1))); fsz =  [fsz fsz];
nfilts = size(bfilts,2);
nrows = floor(sqrt(nfilts));

%%
[pyr,pind] = buildSpyr(I, 'auto', filts);

for i=1:scl_num
    for j=1:ort_num
        [lev, lind] = spyrLev(pyr,pind,i);
        lev2 = reshape(lev,prod(lind(1,:)),size(bfilts,2));
        k = steer(lev2,(j-1)*pi/6, harmonics, steermtx);
        subband{i,j}=reshape(k,lind(1,1),lind(1,2));
        clear k lev lev2
    end
end     
% f = round(size(img,1)/90);
% subband = PerformDivisiveNormalization(subband, scl_num, ort_num, f, 0.0001);