from math import inf
from prevod_na_graph import loadEdges, build_nodes, pointsToIDs

def make_set(u, p, r):
    p[u] = u
    r[u] = 0

def find(u, p):
    while p[u] != u:
        p[u] = p[p[u]]
        u = p[u]
    return u

def union(u, v, p, r):
    root_u = find(u, p) 
    root_v = find(v, p)

    if root_u != root_v:
        if r[root_u] > r[root_v]:
            p[root_v] = root_u
        elif r[root_v] > r[root_u]:
            p[root_u] = root_v
        else:
            p[root_u] = root_v
            r[root_v] = r[root_v] + 1

# Kruskal
def mstk(V, E):
    T = []
    wt = 0
    p = [inf] * (len(V) + 1) 
    r = [inf] * (len(V) + 1)
    for v in V:
        make_set(v, p, r)
    ES = sorted(E, key=lambda x: x[2])
    for e in ES:
        u = e[0]
        v = e[1]
        w = e[2]
        koren_u = find(u, p)
        koren_v = find(v, p)
        
        if koren_u != koren_v:
            union(u, v, p, r)     
            T.append([u, v, w])
            wt = wt + w
    return wt, T

# Sposteni
start_points, end_points, weights = loadEdges("graph.txt")
body = build_nodes(start_points, end_points)
body_to_id = pointsToIDs(body)

# Priprava dat pro algoritmus
V = []
for i in range(len(body)):
    V.append(i)

E = []
for i in range(len(start_points)):
    u_souradnice = start_points[i]
    v_souradnice = end_points[i]
    
    id_u = body_to_id[u_souradnice]
    id_v = body_to_id[v_souradnice]
    w = weights[i]
    
    E.append([id_u, id_v, w])

vaha, kostra = mstk(V, E)

print("Pocet hran v kostre:", len(kostra))
print("Celkova cena:", vaha)

# Exprt do CSV
soubor = "kostra.csv"
f = open(soubor, "w")
f.write("x1,y1,x2,y2,weight\n")

for hrana in kostra:
    u = hrana[0]
    v = hrana[1]
    w = hrana[2]
    
    coord_u = body[u]
    coord_v = body[v]
    
    line = str(coord_u[0]) + "," + str(coord_u[1]) + "," + str(coord_v[0]) + "," + str(coord_v[1]) + "," + str(w) + "\n"
    f.write(line)

f.close()
print("Ulozeno do", soubor)