 function [s,d] = uvTosd(u, v, uk, vk)
    dv = vk - v;
    sarg = sin(u) * sin(uk) + cos(u) .* cos(dv) * cos(uk);
    s = asin(sarg);
    num = sin(dv) .* cos(u);
    denum = -sin(u) * cos(uk) + cos(u) .* cos(dv) * sin(uk);
    
    d = atan2(num, denum);
 end
