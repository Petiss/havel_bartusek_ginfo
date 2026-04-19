function drawFaceContinents3D_8(face, V, conts)
% Vykresli kontinenty primo na jedne 3D stene osmistenu

R = 1;
sMin = 5 * pi/180;

% 2D hranice steny v gnomonicke projekci
[~, ~, polyX, polyY] = boundary_8(R, face.uk, face.vk, face.ub, face.vb);

% 3D vrcholy steny
tri3D = V(face.vertexIdx, :);

% outward normal pro jemny offset proti z-fightingu
n = cross(tri3D(2,:) - tri3D(1,:), tri3D(3,:) - tri3D(1,:));
n = n / norm(n);

c = mean(tri3D, 1);
if dot(n, c) < 0
    n = -n;
end

offset = 0.01;

for k = 1:length(conts)
    pts = load(conts{k});

    u = pts(:,1)' * pi/180;
    v = pts(:,2)' * pi/180;

    [s, d] = uvTosd_8(u, v, face.uk, face.vk);

    valid = s > sMin;

    x = NaN(size(s));
    y = NaN(size(s));

    if any(valid)
        [xv, yv] = gnom_8(R, s(valid), d(valid));
        x(valid) = xv;
        y(valid) = yv;
    end

    [x, y] = clipLineToPolygon_8(x, y, polyX, polyY);

    % rozdelit po NaN segmentech
    isn = isnan(x) | isnan(y);
    idx = [0, find(isn), length(x)+1];

    for seg = 1:length(idx)-1
        a = idx(seg) + 1;
        b = idx(seg+1) - 1;

        if b - a + 1 < 2
            continue;
        end

        xs = x(a:b);
        ys = y(a:b);

        P3 = zeros(length(xs), 3);

        for i = 1:length(xs)
            P3(i,:) = map2DTo3DTriangle_8(xs(i), ys(i), polyX, polyY, tri3D);
        end

        % jemne nad stenou
        P3 = P3 + offset * n;

        plot3(P3(:,1), P3(:,2), P3(:,3), 'b', 'LineWidth', 1.25);
    end
end

end