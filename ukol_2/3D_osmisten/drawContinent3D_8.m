function drawContinent3D_8(file, r)
% vykresli kontinent jako 3D krivku na sfere o polomeru r

points = load(file);

u = points(:,1)' * pi/180;   % zemepisna sirka
v = points(:,2)' * pi/180;   % zemepisna delka

% prevod na 3D
x = r * cos(u) .* cos(v);
y = r * cos(u) .* sin(v);
z = r * sin(u);

% rozdelit prilis dlouhe skoky, aby se nespojovaly nesmyslne casti
jumpThreshold = 0.25 * r;

for i = 1:length(x)-1
    d = hypot(hypot(x(i+1)-x(i), y(i+1)-y(i)), z(i+1)-z(i));
    if d > jumpThreshold
        x(i+1) = NaN;
        y(i+1) = NaN;
        z(i+1) = NaN;
    end
end

plot3(x, y, z, 'b', 'LineWidth', 1.4);

end