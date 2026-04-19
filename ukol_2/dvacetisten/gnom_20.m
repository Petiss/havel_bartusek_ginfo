function [x, y] = gnom_20(R, s, d)

rho = R * tan(pi/2 - s);
x = rho .* cos(d);
y = rho .* sin(d);

end