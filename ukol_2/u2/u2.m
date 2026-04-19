clc
clear

%Face 1 - horni stena sestistenu (normalni poloha, pol na severnim polu)
umin = 30 * pi / 180;
umax = 90 * pi / 180;
vmin = -180 * pi / 180;
vmax = 180 * pi / 180;
Du = 10 * pi/180;
Dv = Du;
du = pi/180;
dv = du;
steps = [Du, Dv, du, dv];

R = 1;
uk = 90*pi/180;
vk = 0;
s0 = pi/4;
proj = @gnom;

ub = 35.2644 * pi/180;
vb = [0, pi/2, pi, 3/2*pi];

conts = {'amer.txt', 'anta.txt', 'austr.txt', 'eur.txt'};

uv = [umin, umax, vmin, vmax];

figure;
createGlobeFace(uv, steps, R, uk, vk, s0, proj, conts, ub, vb);
title('Face 1 - top');

%Face 2 - bocni stena (prikladova, transverse aspect)
figure;
umin = -45 * pi / 180;
umax = 45 * pi / 180;
vmin = -180 * pi / 180;
vmax = 180 * pi / 180;
Du = 10 * pi/180;
Dv = Du;
du = pi/180;
dv = du;
steps = [Du, Dv, du, dv];

R = 1;
uk = 0;
vk = pi/2;
s0 = pi/4;
proj = @gnom;

ub = 35.2644 * pi/180;
vb = [0, pi/2, pi, 3/2*pi];

uv = [umin, umax, vmin, vmax];

createGlobeFace(uv, steps, R, uk, vk, s0, proj, conts, ub, vb);
title('Face 2 - side');