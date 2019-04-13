function D = disp_diff(Dmap, E)

[m,n] = size(E);
D = zeros(m,n); 

for i = 1:m
    pos = find(E(i,:) ~= 0);
    if (~isempty(pos))
    a = Dmap(i,pos);
    c = 4*del2(a);
    D(i,pos) = abs(c);
    end
end

end