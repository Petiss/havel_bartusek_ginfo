function xyz = geoToCart_8(u, v)
% prevod (u,v) -> (x,y,z) na jednotkove sfere

x = cos(u) .* cos(v);
y = cos(u) .* sin(v);
z = sin(u);

xyz = [x, y, z];
end