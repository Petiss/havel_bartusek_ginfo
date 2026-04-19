function[XB,YB] = boundary(R, uk, vk, s0, proj, ub, vb)
%Draw boundary lines (cutting edges)

%Transform to oblique aspect
[sb, db] = uv_sd(ub, vb, uk, vk);

%Project points
[XB, YB] = proj(R, sb, db, s0);