function [Dmap, Corrmap] = Unrec_Dmap(Il, Ir, maxs)
%----------------------------------------------------------------------%
% Input: 
% Il --> Left Pristine Color Image
% Ir --> Right Pristine Color Image
% maxs --> maximum pixel value
% Output:
% Dmap --> Estimated disparity map
% Corrmap --> Correlation map
%-----------------------------------------------------------------------
[M, N, ~] = size(Il);
window = (1/243)*ones(9,9,3);%fspecial('gaussian', 11, 1.5);	%
K(1) = 0.01;								      % default settings
K(2) = 0.03;								      %
L = 255;
C1 = 10^-4;%(K(1)*L)^2;
C2 = 10^-4;%(K(2)*L)^2;
C3 = C2/2;
Il = double(Il);
Ir = double(Ir);
J = padarray(Ir, [0 maxs]);
Mr = imfilter(J, window);
Sr = abs(imfilter(J.^2, window)-Mr.^2);
ml = imfilter(Il, window);
sl = abs(imfilter(Il.^2, window)-ml.^2);
map = zeros(M, N,maxs+1);
for i = -maxs:maxs
    Irt = Shift_Image(i, J, maxs);
    mr = Shift_Image(i, Mr, maxs);
    sr = Shift_Image(i, Sr, maxs);
    slr = imfilter(Il.*Irt, window)-ml.*mr;
    mlr = ml(:,:,2).*mr(:,:,2);
    num = (2*mlr+C1).*(2*sqrt(sl(:,:,2).*sr(:,:,2))+C2).*(slr(:,:,2)+C3);
    den = (ml(:,:,2).^2+mr(:,:,2).^2+C1).*(sl(:,:,2)+sr(:,:,2)+C2).*(sqrt(sl(:,:,2).*sr(:,:,2))+C3);
%     num = (2*mlr+C1).*(2*slr(:,:,2)+C2);
%     den = (ml(:,:,2).^2+mr(:,:,2).^2+C1).*(sl(:,:,2)+sr(:,:,2)+C2);
    map(:,:,i+maxs+1) = abs(num./den);
    clear Irt mr sr slr mlr num den
end
Dmap = zeros(M, N);
for i = 1:M
    for j=1:N
        mnh = max(j-(N-maxs)+1,1);
        mxh = min(j+maxs,2*maxs+1);
        %mn = min(maxs+1,j);
        [val, pos] = max(map(i,j,mnh:mxh));
        Dmap(i,j) = pos(1)+mnh-maxs-2;
        Corrmap(i,j) = val;
        clear pos val
    end
end
end

function It = Shift_Image(sh, J, maxs)
[x, y, l] = size(J);
K = zeros(x, y,l);
if (sh < 0)
    sh = abs(sh);
    K(:,y-sh+1:y,:) = J(:,1:sh,:);
    K(:,1:y-sh,:) = J(:, sh+1:y, :);
else
    K(:,1:sh,:) = J(:, y-sh+1:y,:);
    K(:,sh+1:y,:) = J(:, 1:y-sh,:);
end
% K(:,1:s,:) = J(:, y-s+1:y,:);
% K(:,s+1:y,:) = J(:, 1:y-s,:);
It = K(:, maxs+1:y-maxs,:);

end
