from collections import defaultdict

def loadEdges(file_name):
    PS, PE, W = [], [], []
    with open(file_name, encoding="utf-8") as f:
        for line in f:
            x1, y1, x2, y2, w = line.split()
            PS.append((float(x1), float(y1)))
            PE.append((float(x2), float(y2)))
            W.append(float(w))
    return PS, PE, W

def build_nodes(PS, PE):
    PSE = list(set(PS + PE))
    PSE.sort()
    return PSE
def pointsToIDs(PSE):
    return {pt: i for i, pt in enumerate(PSE)}

def edgesToGraph(D, PS, PE, W):
    G = defaultdict(dict)

    for i in range(len(PS)):
        a = D[PS[i]]
        b = D[PE[i]]
        w = W[i]
        if b not in G[a] or w < G[a][b]:
            G[a][b] = w
            G[b][a] = w

    return G
if __name__ == "__main__":
    # Výstup!!
    file = "graph.txt"

    PS, PE, W = loadEdges(file)
    PSE = build_nodes(PS, PE)
    D = pointsToIDs(PSE)
    G = edgesToGraph(D, PS, PE, W)

    print("Number of nodes:", len(PSE))
    print("Number of edges (directed entries u->v):", sum(len(G[u]) for u in G))