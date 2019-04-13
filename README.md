## SED-SIQA: Estimating Depth-Salient Edges And Its Application To Stereoscopic Image Quality Assessment

If you are using SED-SIQA code, please cite this paper.

### Citation
    @ARTICLE{8421271,
    author={S. {Khan} and S. S. {Channappayya}},
    journal={IEEE Transactions on Image Processing},
    title={Estimating Depth-Salient Edges and Its Application to Stereoscopic Image Quality Assessment},
    year={2018},
    volume={27},
    number={12},
    pages={5892-5903},
    doi={10.1109/TIP.2018.2860279},
    ISSN={1057-7149},
    month={Dec},}


1)	Download the Steerable pyramid toolbox from the following link:  
        http://www.cns.nyu.edu/pub/eero/matlabPyrTools.tar.gz 

2)	For spyrdecomp addpath to steerable pyramid toolbox folder.

3)	Compute left and right disparity maps using Unrec_Dmap.
	For left disparity map do the following:
	Dmap_l = Unrec_Dmap(IL, IR, maxs);  where IL and IR are color stereopairs
	For right disparity map do the following:
	iL = flip(IL,2);
	iR = flip(IR,2);
	dmapr = Unrec_Dmap(iR, iL, maxs);
	Dmap_r = flip(dmapr,2);

4)	Compute SED maps from DepthPerception.m

5)      Compute stereo quality using SED_SIQA.m
