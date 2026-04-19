clc;
clear;
close all;

% ============================================
% POLYEDRICKY GLOBUS NA 20-STENU (IKOSAEDRU)
% ============================================

R = 1;

% Geograficka sit
Du = 10 * pi/180;
Dv = 10 * pi/180;
du = 1 * pi/180;
dv = 1 * pi/180;
steps = [Du, Dv, du, dv];

% Globalni rozsah pro generovani site
umin = -90 * pi/180;
umax =  90 * pi/180;
vmin = -180 * pi/180;
vmax =  180 * pi/180;
uv = [umin, umax, vmin, vmax];

% Kontinenty
conts = {'amer.txt', 'anta.txt', 'austr.txt', 'eur.txt'};

% Geometrie 20-stenu
[verticesGeo, facesIdx, facePoles, faceNames] = buildIcosahedron_20();

% ============================================
% PREHLED VSECH 20 STEN
% ============================================

figure('Color', 'w', 'Name', '20-sten - vsechny steny');
tiledlayout(4, 5, 'Padding', 'compact', 'TileSpacing', 'compact');

for i = 1:size(facesIdx,1)
    nexttile;

    idx = facesIdx(i,:);
    ub = verticesGeo(idx, 1)';
    vb = verticesGeo(idx, 2)';
    uk = facePoles(i,1);
    vk = facePoles(i,2);

    createGlobeFace_20(uv, steps, R, uk, vk, conts, ub, vb);
    title(faceNames{i}, 'FontWeight', 'bold', 'FontSize', 9);
end

% ============================================
% JEDNOTLIVE STENY ZVLAST
% ============================================

for i = 1:size(facesIdx,1)
    idx = facesIdx(i,:);
    ub = verticesGeo(idx, 1)';
    vb = verticesGeo(idx, 2)';
    uk = facePoles(i,1);
    vk = facePoles(i,2);

    figure('Color', 'w', 'Name', faceNames{i});
    createGlobeFace_20(uv, steps, R, uk, vk, conts, ub, vb);
    title(['20-sten - ', faceNames{i}], 'FontWeight', 'bold');
end