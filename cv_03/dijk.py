from queue import PriorityQueue
from prevod_na_graph import loadEdges, build_nodes, pointsToIDs, edgesToGraph

def nearest_id(PSE, x, y):
    best_i = None
    best_d = float("inf")
    for i, (px, py) in enumerate(PSE):
        d = (px - x) ** 2 + (py - y) ** 2
        if d < best_d:
            best_d = d
            best_i = i
    return best_i

def dijkstra(G, start, end, n):
    d = [float("inf")] * n
    p = [-1] * n
    Q = PriorityQueue()

    d[start] = 0
    Q.put((0, start))

    while not Q.empty():
        du, u = Q.get()
        if du != d[u]:
            continue
        if u == end:
            break

        for v, wuv in G[u].items():
            nd = d[u] + wuv
            if nd < d[v]:
                d[v] = nd
                p[v] = u
                Q.put((nd, v))

    return d, p

def build_path(p, end):
    path = []
    v = end
    while v != -1:
        path.append(v)
        v = p[v]
    path.reverse()
    return path

if __name__ == "__main__":
    variants = [
        ("graph.txt",              "cesta_vzdalenost.csv", "1. Nejkratší vzdálenost"),
        ("graph_time.txt",         "cesta_cas.csv",        "2. Nejmenší čas (bez krivosti)"),
        ("graph_time_krivost.txt", "cesta_krivost_cas.csv",      "3. Nejmenší čas (s krivostí)"),
    ]

    # Startovní a cílové souřadnice
    #sx, sy = 14.4029042, 50.0891106   # U Hrocha
    #tx, ty = 14.477518, 50.070855   # Kubánské náměstí
    
    sx, sy = 14.5284406, 50.0306594   # Háje
    tx, ty = 14.3672338, 50.0697995   # Kavalíka
    
    print(f"--- SPUŠTĚNÍ VÝPOČTU PRO {len(variants)} VARIANTY ---")

    for input_file, output_csv, label in variants:
        try:
            PS, PE, W = loadEdges(input_file)
        except FileNotFoundError:
            print(f"  Chyba: Soubor {input_file} neexistuje!")
            continue

        PSE = build_nodes(PS, PE)
        D = pointsToIDs(PSE)
        G = edgesToGraph(D, PS, PE, W)
        n = len(PSE)

        start = nearest_id(PSE, sx, sy)
        end   = nearest_id(PSE, tx, ty)

        d, p = dijkstra(G, start, end, n)
        
        if d[end] == float("inf"):
            print("  -> Cesta NENALEZENA (graf není souvislý?)")
        else:
            path = build_path(p, end)
            
            with open(output_csv, "w", encoding="utf-8") as f:
                f.write("order,id,x,y\n")
                for i, node in enumerate(path):
                    x, y = PSE[node]
                    f.write(f"{i},{node},{x},{y}\n")

            print(f"  -> Počet uzlů cesty: {len(path)}")
            print(f"  -> Celková cena (váha): {d[end]:.4f}")
            print(f"  -> Uloženo do: {output_csv}")