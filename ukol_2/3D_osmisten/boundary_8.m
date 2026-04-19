function [XB, YB, polyX, polyY] = boundary_8(R, uk, vk, ub, vb)

ubc = [ub, ub(1)];
vbc = [vb, vb(1)];

[sb, db] = uvTosd_8(ubc, vbc, uk, vk);
[XB, YB] = gnom_8(R, sb, db);

polyX = XB(1:end-1);
polyY = YB(1:end-1);

end