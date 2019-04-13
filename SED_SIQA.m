function Qscore = SED_SIQA(Il, Ir, il, ir, SED_L, SED_R)
% ========================================================================
% SED_SIQA for salient region detection from a given image.
% Copyright(c) 2018 Sumohana Channappayya, Lab For Video and Image Analysis, 
% Department of Electrical Engineering, IIT Hyderabad
% All Rights Reserved.
%----------------------------------------------------------------------
% Please cite the following work if you intend to use this code:
%
% Sameeulla Khan, and Sumohana S. Channappayya. "Estimating Depth-Salient Edges and Its 
% Application to Stereoscopic Image Quality Assessment.
% " IEEE Transactions on Image Processing 27.12 (2018): 5892-5903.
%----------------------------------------------------------------------%
% Input: 
% Il --> Left Pristine Color Image
% Ir --> Right Pristine Color Image
% il --> Left Test Color Image
% ir --> Right Test Color Image
% SED_L --> Left SED map
% SED_R --> Right SED map
% SED maps are obtained from DepthPerception.m

% Output: 
% Qscore --> Objective quality score of stereopair (il,ir) w.r.t (Il, Ir)    
%-----------------------------------------------------------------------
Ill = double(rgb2gray(Il));
Irr = double(rgb2gray(Ir));
    [M, N] = size(Il(:,:,1));
    f = round(M/20);
    t = round(M/256);
    r = round(min(M,N)/200);
    sig1 = round(min(M,N)/120);
    sig2 = round(min(M,N)/80);
    K(1) = ((0.01)^2);										% default settings
    K(2) = ((0.03)^2); K(3) = K(2)/2;
    Sal_L = SDSP(Il);
    Sal_R = SDSP(Ir);
    [GLx, GLy] = smoothGradient(Ill);
    [GRx, GRy] = smoothGradient(Irr);
    Sal_L = Sal_L/max(abs(Sal_L(:)));
    Sal_R = Sal_R/max(abs(Sal_R(:)));
    GLm = max(max(abs(GLx(:))), max(abs(GLy(:))));
    GRm = max(max(abs(GRx(:))), max(abs(GRy(:))));
    GLx = (GLx)/GLm; GLy = (GLy)/GLm;
    GRx = (GRx)/GRm; GRy = (GRy)/GRm;
    GL = hypot(GLx,GLy);
    GR = hypot(GRx,GRy);
      
    SD_L = SED_L/sum(SED_L(:));
    SD_R = SED_R/sum(SED_R(:));
    [indxl] = find(SED_L ~= 0);
    [indxr] = find(SED_R ~= 0);
    
        ill = double(rgb2gray(il));
        irr = double(rgb2gray(ir));
        sal_l = SDSP(il);
        sal_r = SDSP(ir);
        [glx, gly] = smoothGradient(ill);
        [grx, gry] = smoothGradient(irr);
        sal_l = sal_l/max(abs(sal_l(:)));
        sal_r = sal_r/max(abs(sal_r(:)));
        glm = max(max(abs(glx(:))), max(abs(gly(:))));
        grm = max(max(abs(grx(:))), max(abs(gry(:))));
        glx = (glx)/glm; gly = (gly)/glm;
        grx = (grx)/grm; gry = (gry)/grm;
        gl = hypot(glx, gly);
        gr = hypot(grx, gry);
        Gl = abs(GLx.*glx)+abs(GLy.*gly);
        Gr = abs(GRx.*grx)+abs(GRy.*gry);
        wl = bnd(ill); wr = bnd(irr);
        En = [(wl/(wl+wr)) (wr/(wl+wr))];
        Map_l = (2*Sal_L.*sal_l+K(1)).*(2*GL.*gl+K(2)).*(Gl+K(3))./((Sal_L.^2+sal_l.^2+K(1)).*(GL.^2+gl.^2+K(2)).*(GL.*gl+K(3)));
        Map_r = (2*Sal_R.*sal_r+K(1)).*(2*GR.*gr+K(2)).*(Gr+K(3))./((Sal_R.^2+sal_r.^2+K(1)).*(GR.^2+gr.^2+K(2)).*(GR.*gr+K(3)));
        Sl = mean(Map_l(:)); Sr = mean(Map_r(:));
        Sdl = sum(Map_l(indxl).*SD_L(indxl));
        Sdr = sum(Map_r(indxr).*SD_R(indxr));
         
        SLum = (Sl.^En(1)).*(Sr.^En(2));
        SDis = (Sdl.^En(1)).*(Sdr.^En(2));
        Qscore = SLum.*SDis;
end
