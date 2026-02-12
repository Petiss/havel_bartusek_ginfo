import osmnx as ox
import math

PLACE = "Praha, Czechia"
# Stažení dat a příprava
G = ox.graph_from_place(PLACE, network_type="drive", simplify=True, retain_all=True)
G = ox.routing.add_edge_speeds(G)
G = ox.routing.add_edge_travel_times(G)

xs = {n: float(G.nodes[n]["x"]) for n in G.nodes}
ys = {n: float(G.nodes[n]["y"]) for n in G.nodes}

def s_uv(u, v):
    return ox.distance.great_circle(ys[u], xs[u], ys[v], xs[v])

# Příprava struktur pro ukládání výsledků
best_length = {}   # pro graph.txt
best_time = {}     # pro graph_time.txt
best_krivost = {}  # pro graph_time_krivost.txt

for u, v, k, data in G.edges(keys=True, data=True):
    l = data.get("length")
    t = data.get("travel_time")
    
    if l is None or t is None:
        continue
    
    a, b = (u, v) if u <= v else (v, u)
    key = (a, b)
    
    w_len = float(l)
    if key not in best_length or w_len < best_length[key]:
        best_length[key] = w_len

    w_time = float(t)
    if key not in best_time or w_time < best_time[key]:
        best_time[key] = w_time

    s = s_uv(u, v)
    if s <= 0:
        kappa = 1.0
    else:
        kappa = float(l) / float(s)
    
    if kappa < 1.0:
        kappa = 1.0
        
    w_kriv = w_time * kappa
    if key not in best_krivost or w_kriv < best_krivost[key]:
        best_krivost[key] = w_kriv

# Export graph.txt
with open("graph.txt", "w", encoding="utf-8") as f:
    for (a, b), w in best_length.items():
        f.write(f"{xs[a]} {ys[a]} {xs[b]} {ys[b]} {w}\n")
print(f"Saved graph.txt | edges: {len(best_length)}")

# Export graph_time.txt
with open("graph_time.txt", "w", encoding="utf-8") as f:
    for (a, b), w in best_time.items():
        f.write(f"{xs[a]} {ys[a]} {xs[b]} {ys[b]} {w}\n")
print(f"Saved graph_time.txt | edges: {len(best_time)}")

# Export graph_time_krivost.txt
with open("graph_time_krivost.txt", "w", encoding="utf-8") as f:
    for (a, b), w in best_krivost.items():
        f.write(f"{xs[a]} {ys[a]} {xs[b]} {ys[b]} {w}\n")
print(f"Saved graph_time_krivost.txt | edges: {len(best_krivost)}")