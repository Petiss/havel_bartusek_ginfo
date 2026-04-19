function exportOBJ_8(filename, V, F, lineSet)

fid = fopen(filename, 'w');
if fid == -1
    error('Nepodarilo se otevrit soubor pro zapis: %s', filename);
end

fprintf(fid, '# Osmisten + lines exported from MATLAB\n');

% ============================================
% MESH VERTICES
% ============================================
for i = 1:size(V,1)
    fprintf(fid, 'v %.8f %.8f %.8f\n', V(i,1), V(i,2), V(i,3));
end

% ============================================
% FACE OBJECT
% ============================================
fprintf(fid, '\no base_octahedron\n');
for i = 1:size(F,1)
    fprintf(fid, 'f %d %d %d\n', F(i,1), F(i,2), F(i,3));
end

% ============================================
% LINES AS POLYLINE OBJECTS
% ============================================
vertexOffset = size(V,1);

for k = 1:numel(lineSet)
    P = lineSet{k};

    fprintf(fid, '\no line_%04d\n', k);

    for i = 1:size(P,1)
        fprintf(fid, 'v %.8f %.8f %.8f\n', P(i,1), P(i,2), P(i,3));
    end

    fprintf(fid, 'l');
    for i = 1:size(P,1)
        fprintf(fid, ' %d', vertexOffset + i);
    end
    fprintf(fid, '\n');

    vertexOffset = vertexOffset + size(P,1);
end

fclose(fid);
end