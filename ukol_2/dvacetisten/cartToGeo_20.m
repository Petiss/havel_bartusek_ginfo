function [u, v] = cartToGeo_20(x, y, z)

r = sqrt(x.^2 + y.^2 + z.^2);

u = asin(z ./ r);
v = atan2(y, x);

end