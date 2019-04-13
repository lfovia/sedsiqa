function [GX, GY] = smoothGradient(I)


[M, N] = size(I);
p = round(min(M, N)/80);
sig = round(p/5);
if (sig == 0)
    sig = 1;
end
filterRange = ceil(p*sig);
x = -filterRange:filterRange;
c = 1/(sqrt(2*pi)*sig);
GaussWindow = c * exp(-(x.^2)/(2*sig^2));
GaussWindow = GaussWindow/sum(GaussWindow);

derivGaussWindow = gradient(GaussWindow);

negVals = derivGaussWindow < 0;
posVals = derivGaussWindow > 0;
derivGaussWindow(posVals) = derivGaussWindow(posVals)/sum(derivGaussWindow(posVals));
derivGaussWindow(negVals) = derivGaussWindow(negVals)/abs(sum(derivGaussWindow(negVals)));

GX = imfilter(I, GaussWindow', 'conv', 'replicate');
GX = imfilter(GX, derivGaussWindow, 'conv', 'replicate');

GY = imfilter(I, GaussWindow, 'conv', 'replicate');
GY = imfilter(GY, derivGaussWindow', 'conv', 'replicate');
