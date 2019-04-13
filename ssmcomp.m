function S = ssmcomp(I1, I2, L, val)

I1 = double(I1);
I2 = double(I2);

k1 = 0.01; k2 = 0.03; %L = 1;
c1 = (k1*L)^2; c2 = (k2*L)^2; c3 = c2/2;
% c1 = 10^-4; c2 = 10^-4; c3 = c2/2;

mu1 = mean(I1(:));
mu2 = mean(I2(:));

std1 = std(I1(:),1);
std2 = std(I2(:),1);
CV = cov(I1(:),I2(:),1);
cv = CV(1,2);
% cv = mean((I1(:)-mu1).*(I2(:)-mu2));
Lum = (2*mu1*mu2+c1)/(mu1^2+mu2^2+c1);
Con = (2*std1*std2+c2)/(std1^2+std2^2+c2);
Str = (cv+c3)/(std1*std2+c3);
if (val)
    S = Str;
else
    S = Lum*Con*Str;%
end
% S = ((2*mu1*mu2+c1)/(mu1^2+mu2^2+c1)) * ((2*cv+c2)/(std1^2+std2^2+c2));
end
