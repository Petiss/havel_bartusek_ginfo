import numpy as np
import time
import matplotlib.pyplot as plt
from collections import defaultdict

# Load data
def loadPoints(file):
    X, Y, Z = [], [], []
    with open(file) as f:
        for line in f:
            x, y, z = line.split('\t')
            X.append(float(x))
            Y.append(float(y))
            Z.append(float(z))
    return np.array(X), np.array(Y), np.array(Z)

path = r"C:\\Users\\Honza\\Documents\\Škola\\geoinfo\\geoinf_2025-main\\cv4\\tree_18.txt"

X, Y, Z = loadPoints(path)
points = np.column_stack((X, Y, Z))
N = len(points) 
K = 30

# Def distance
def dist(a, b):
    return np.linalg.norm(a - b)

# Def curvature
def curvature(neigh):
    C = np.cov(neigh.T)
    l = np.linalg.eigvalsh(C)
    return l[0] / np.sum(l)

# Def density
def density(avg_d):
    return 1.0 / (avg_d ** 3 + 1e-12)

# Naive search
def knn_naive(i):
    d = []
    for j in range(len(points)):
        if i != j:
            d.append((dist(points[i], points[j]), j))
    d.sort()
    idx = [j for _, j in d[:K]]
    return idx

# Voxel search
def build_voxels(h):
    vox = defaultdict(list)
    for i, p in enumerate(points):
        key = tuple((p / h).astype(int))
        vox[key].append(i)
    return vox

def knn_voxel(i, vox, h):
    p = points[i]
    key = tuple((p / h).astype(int))
    cand = []
    for dx in [-1,0,1]:
        for dy in [-1,0,1]:
            for dz in [-1,0,1]:
                k = (key[0]+dx, key[1]+dy, key[2]+dz)
                cand += vox.get(k, [])
    d = [(dist(p, points[j]), j) for j in cand if j!=i]
    d.sort()
    return [j for _, j in d[:K]]

# KD tree
class KDNode:
    def __init__(self, idxs, axis):
        self.axis = axis
        self.idxs = idxs
        self.left = None
        self.right = None

class SimpleKDTree:
    def __init__(self, idxs, depth=0):
        if len(idxs)==0:
            self.node=None; return
        axis = depth % 3
        idxs = sorted(idxs, key=lambda i: points[i][axis])
        m = len(idxs)//2
        self.node = KDNode([idxs[m]], axis)
        self.node.left = SimpleKDTree(idxs[:m], depth+1)
        self.node.right = SimpleKDTree(idxs[m+1:], depth+1)

    def query(self, p, best):
        if self.node is None: return
        for i in self.node.idxs:
            d = dist(p, points[i])
            best.append((d, i))
        axis = self.node.axis
        diff = p[axis] - points[self.node.idxs[0]][axis]
        first, second = (self.node.left, self.node.right) if diff<0 else (self.node.right, self.node.left)
        if first: first.query(p, best)
        if second: second.query(p, best)

# OCTree
class Octree:
    def __init__(self, idxs, center, size, depth=0):
        self.idxs = idxs
        self.children = []
        if len(idxs)>20 and depth<5:
            for dx in [-1,1]:
                for dy in [-1,1]:
                    for dz in [-1,1]:
                        c = center + size/4*np.array([dx,dy,dz])
                        sub = [i for i in idxs if np.all(np.abs(points[i]-c)<=size/2)]
                        self.children.append(Octree(sub, c, size/2, depth+1))

    def query(self, p, out):
        out += self.idxs
        for ch in self.children:
            ch.query(p, out)

# RTree
class RTree:
    def __init__(self, idxs):
        self.idxs = idxs
    def query(self, p):
        return self.idxs

# Calculations
def compute(method):
    dens = []
    curv = []
    t0 = time.time()

    if method=="naive":
        for i in range(N):
            nn = knn_naive(i)
            d = np.mean([dist(points[i], points[j]) for j in nn])
            dens.append(density(d))

    if method=="voxel":
        h = 0.1
        vox = build_voxels(h)
        for i in range(N):
            nn = knn_voxel(i, vox, h)
            d = np.mean([dist(points[i], points[j]) for j in nn])
            dens.append(density(d))
            curv.append(curvature(points[nn]))

    if method=="kd":
        tree = SimpleKDTree(list(range(N)))
        for i in range(N):
            best=[]
            tree.query(points[i], best)
            best.sort()
            nn=[j for _,j in best[1:K+1]]
            d=np.mean([dist(points[i],points[j]) for j in nn])
            dens.append(density(d))
            curv.append(curvature(points[nn]))

    t = time.time()-t0
    return dens, curv, t

d_naive, _, t1 = compute("naive")
d_vox, c_vox, t2 = compute("voxel")
d_kd, c_kd, t3 = compute("kd")

print("Časy:")
print("Naivní:", t1)
print("Voxel:", t2)
print("KD:", t3)

# Visualisation
plt.figure()
plt.scatter(points[:,0], points[:,1], c=c_vox, cmap='jet')
plt.colorbar(label="křivost")
plt.title("Křivost – voxel")
plt.show()
