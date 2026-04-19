function [XM, YM, XP, YP] = graticule(umin, umax, vmin, vmax, Du, Dv, du, dv, R, uk, vk, s0, proj)

XM = []; YM = [];
for v = vmin:Dv:vmax
    um = umin:du:umax;
    n = length(um);
    vm = ones(1, n)*v;
    
    [sm, dm] = uvTosd(um, vm, uk, vk);
    [xm, ym] = proj(R, sm, dm, s0);
    
    % Prerus cary mimo stenou
    outside = sm < pi/4;
    xm(outside) = NaN;
    ym(outside) = NaN;
    
    XM = [XM; xm];
    YM = [YM; ym];
end

XP = []; YP = [];
for u = umin:Du:umax
    vp = vmin:dv:vmax;
    n = length(vp);
    up = ones(1, n)*u;
    
    [sp, dp] = uvTosd(up, vp, uk, vk);
    [xp, yp] = proj(R, sp, dp, s0);
    
    % Prerus cary mimo stenou
    outside = sp < pi/4;
    xp(outside) = NaN;
    yp(outside) = NaN;
    
    XP = [XP; xp];
    YP = [YP; yp];
end

end