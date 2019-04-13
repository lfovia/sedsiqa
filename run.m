% The ground truth disparity maps are non-integers. Becuase of that some
% NaNs are appearing. So use round() function over ground truth disparity map 
[SED_l, SED_r, LeSED_l, LeSED_r] = DepthPerception(Il, Ir, round(Dmap_l), round(Dmap_r));