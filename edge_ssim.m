function [Lmap, Rmap] = edge_ssim(Il, Ir, Dmap_l, Dmap_r, El, Er, p)


[m, n, ~] = size(Il);

Lmap = zeros(m,n);
Rmap = zeros(m,n);
f = p;%round(m/20);
il = padarray(Il, [f f]);
ir = padarray(Ir, [f f]);
for i = 1 : m
    x = i + f;
    for j = 1 : n
        y = j + f;
        if (El(i,j)~=0)
            k = max(1, min(n,j-Dmap_l(i,j)));
            z = k + f;
            p1 = p;%Dmap_l(i,j);
            if (p1 ~= 0)
                temp_ll = (il(x-p1:x+p1, y-p1:y-1,:));
                temp_rl = (ir(x-p1:x+p1, z-p1:z-1,:));
                temp_lr = (il(x-p1:x+p1, y+1:y+p1,:));
                temp_rr = (ir(x-p1:x+p1, z+1:z+p1,:));                
                ssm_l = abs(ssmcomp(temp_ll,temp_rl,1,0));
                ssm_r = abs(ssmcomp(temp_lr,temp_rr,1,0));
                mn = min(ssm_l, ssm_r);
                mx = max(ssm_l, ssm_r);
                if (mx == 0)
                    Lmap(i,j) = 0;
                else
                    Lmap(i,j) = abs(sqrt(1-(mn/mx)^2));
                end
            else 
                Lmap(i,j) = 0;
            end
        end
        if (Er(i,j) ~= 0)
            k = min(n, max(1,j+Dmap_r(i,j)));
            z = k + f;
            p2 = p;%Dmap_r(i,j);
            if (p2 ~= 0)
                temp_ll = (il(x-p2:x+p2, z-p2:z-1,:));
                temp_rl = (ir(x-p2:x+p2, y-p2:y-1,:));
                temp_lr = (il(x-p2:x+p2, z+1:z+p2,:));
                temp_rr = (ir(x-p2:x+p2, y+1:y+p2,:));
                ssm_l = abs(ssmcomp(temp_ll,temp_rl,1,0));
                ssm_r = abs(ssmcomp(temp_lr,temp_rr,1,0));
                mn = min(ssm_l, ssm_r);
                mx = max(ssm_l, ssm_r);
                if (mx == 0)
                    Rmap(i,j) = 0;
                else
                    Rmap(i,j) = abs(sqrt(1-(mn/mx)^2));
                end
            else
                Rmap(i,j) = 0;
            end
        end
    end
end

end
            