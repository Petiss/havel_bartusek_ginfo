function [XC,YC] = drawContinent(file, R, uk, vk, s0, proj)
points = load(file);

u = points(:,1) * pi / 180;
v = points(:,2) * pi / 180;

[s,d] = uvTosd(u, v, uk, vk);

% Filtruj body mimo stenou
idx = s > pi/4;
s(~idx) = NaN;
d(~idx) = NaN;

[XC, YC] = proj(R, s, d, s0);

% Prerus cary kde je prilis velky skok (artefakty na hranici)
threshold = 0.5;
jumps = abs(diff(XC)) > threshold | abs(diff(YC)) > threshold;
XC(find(jumps) + 1) = NaN;
YC(find(jumps) + 1) = NaN;

end