function [s,d] = uvTosd(u, v, uk, vk)
    %Convert u, v to the oblique aspect
    dv = vk - v;
    %Latitude
    sarg = sin(u) * sin(uk) + cos(u) .* cos(dv)*cos(uk);
    s = asin(sarg);
    
    %Longitude
    num = sin(dv) .* cos(u);
    denom = -sin(u) * cos(uk) + cos(u) .* cos(dv) * sin(uk);
    d = atan2(num, denom);

function [x, y] = gnom(R, s, d, s0)
    %Gnomonic projection in oblique aspect
    x = R * tan(pi/2-s).*cos(d);
    y = R * tan(pi/2-s).*sin(d);
end


function [XM, YM, XP, YP] = graticule(umin, umax, vmin, vmax, Du, Dv, du, dv,...
                                    R, uk, vk, u0, proj)
%Create graticule: list of meridians and parallels

%Create list of meridians
XM = []; YM = [];
for v = vmin:Dv:vmax

    %Create meridian
    um = umin:du:umax;
    n = length(um);
    vm = ones(1, n)*v;
    
    %Convert to oblique aspect
    [sm, dm] = uv_sd(um, vm, uk, vk);

    %Compute xm, ym
    [xm, ym] = proj(R, sm, dm, u0);

    %Add meridian to the list
    XM = [XM; xm];
    YM = [YM; ym];

end

%Create list of parallels
XP = []; YP = [];
for u = umin:Du:umax
    
    %Create parallel
    vp = vmin:dv:vmax;
    n = length(vp);
    up = ones(1, n)*u;
    
    %Convert to oblique aspect
    [sp, dp] = uv_sd(up, vp, uk, vk);

    %Compute xp, yp
    [xp, yp] = proj(R, sp, dp, u0);

    %Add parellel to the list
    XP = [XP; xp];
    YP = [YP; yp];

end

end

function[XB,YB] = boundary(R, uk, vk, s0, proj, ub, vb)
%Draw boundary lines (cutting edges)

%Transform to oblique aspect
[sb, db] = uv_sd(ub, vb, uk, vk);

%Threshold
s_min = 45 * pi/180;

%Project points
[XB, YB] = gnom(R, sb, db, s0);


