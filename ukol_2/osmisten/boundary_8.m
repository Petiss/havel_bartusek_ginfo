function [XB, YB, polyX, polyY] = boundary_8(R, uk, vk, ub, vb)

% Uzavreni polygonu
ubc = [ub, ub(1)];
vbc = [vb, vb(1)];

% Transformace do sikme polohy
[sb, db] = uvTosd_8(ubc, vbc, uk, vk);

% Projekce vrcholu
[XB, YB] = gnom_8(R, sb, db);

% Polygon bez duplicitniho posledniho bodu
polyX = XB(1:end-1);
polyY = YB(1:end-1);

end