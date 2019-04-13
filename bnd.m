function [  e] = bnd(I)

[M, N] = size(I);
t = round(min(M,N)/256);
scl = 1;%round(log((min(M,N)/64))/log(2)+1);
% I = uint8(I);
if (t>1)
    J = imresize(I, 1/t); 
else
    J  = I;
end
Band = spyrdecomp(J, scl, 6);
% B = PerformDivisiveNormalization(Band, 1, 6, 4, 0.001);
% Q = zeros(size(I));

for i = 1:scl
    for j = 1:6
    q(i,j) = mean(Band{i,j}(:).^2);
%     Q = Q+B{i}.^2;
    end
end
e = mean(q(:));