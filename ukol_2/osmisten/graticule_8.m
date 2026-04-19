function [XM, YM, XP, YP] = graticule_8(umin, umax, vmin, vmax, Du, Dv, du, dv, R, uk, vk, polyX, polyY)

sMin = 5 * pi/180;   % ochrana pred singularitou gnomonicke projekce


% Poledniky
XM = [];
YM = [];

for v = vmin:Dv:vmax
    um = umin:du:umax;
    vm = ones(size(um)) * v;

    [sm, dm] = uvTosd_8(um, vm, uk, vk);
    % body blizko horizontu odstranit
    valid = sm > sMin;

    xm = NaN(size(sm));
    ym = NaN(size(sm));

    if any(valid)
        [xv, yv] = gnom_8(R, sm(valid), dm(valid));
        xm(valid) = xv;
        ym(valid) = yv;
    end

    [xm, ym] = clipLineToPolygon_8(xm, ym, polyX, polyY);

    XM = [XM; xm];
    YM = [YM; ym];
end


% Rovnobezky
XP = [];
YP = [];

for u = umin:Du:umax
    vp = vmin:dv:vmax;
    up = ones(size(vp)) * u;

    [sp, dp] = uvTosd_8(up, vp, uk, vk);

    valid = sp > sMin;

    xp = NaN(size(sp));
    yp = NaN(size(sp));

    if any(valid)
        [xv, yv] = gnom_8(R, sp(valid), dp(valid));
        xp(valid) = xv;
        yp(valid) = yv;
    end

    [xp, yp] = clipLineToPolygon_8(xp, yp, polyX, polyY);

    XP = [XP; xp];
    YP = [YP; yp];
end

end