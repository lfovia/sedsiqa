function  [SED_L, SED_R, LeSED_L, LeSED_R] = DepthPerception(Il, Ir, Dmap_l, Dmap_r)
%----------------------------------------------------------------------%
% Input: 
% Il --> Left Pristine Color Image
% Ir --> Right Pristine Color Image
% Dmap_l --> Left disparity map
% Dmap_r --> Right disprity map
% Disparity maps are obtained using Unrec_Dmap
% Output: 
% SED_L --> Left SED map
% SED_R --> Right SED map
% LeSED_L --> Left Log- enhanced SED map
% LeSED_R --> Right Log- enhanced SED map
%-----------------------------------------------------------------------
[M, N] = size(Il(:,:,1));
f = round(min(M,N)/20);
t = round(min(M,N)/480);
r = floor(min(M,N)/200);
p = round(min(M,N)/80);

if (t>1)
il = imresize(Il, 1/t); ir = imresize(Ir, 1/t);
el = edge(rgb2gray(il),'canny'); er = edge(rgb2gray(ir),'canny');
El = imresize(el,t); Er = imresize(er,t);
else
El = edge(double(rgb2gray(Il)),'canny');
Er = edge(double(rgb2gray(Ir)),'canny');
end

Dl1 = disp_diff(Dmap_l, El);
Dr1 = disp_diff(Dmap_r, Er);
Dl2 = disp_diff(Dmap_l', El');
Dr2 = disp_diff(Dmap_r', Er');

Dl = hypot(Dl1,Dl2');
Dr = hypot(Dr1,Dr2');

[Omap_L, Omap_R] = edge_ssim(Il, Ir, Dmap_l, Dmap_r, El, Er, p);
dmap_l = Dmap_l-min(Dmap_l(:));
dmap_r = Dmap_r-min(Dmap_r(:));
SED_L = Dl.*Omap_L.*dmap_l;
SED_R = Dr.*Omap_R.*dmap_r;

win = fspecial('gaussian',2*r+1, r);
Ml = conv2(SED_L,win,'same');
Mr = conv2(SED_R,win,'same');
LeSED_L = log(1+10*Ml/max(Ml(:)));
LeSED_R = log(1+10*Mr/max(Mr(:)));

end
