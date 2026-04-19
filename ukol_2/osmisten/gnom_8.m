function [x, y] = gnom_8(R, s, d)
% Gnomonicka projekce

rho = R * tan(pi/2 - s);
x = rho .* cos(d);
y = rho .* sin(d);

end