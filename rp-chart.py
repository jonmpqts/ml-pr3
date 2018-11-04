import sys
import h5py
import numpy as np
import matplotlib.pyplot as plt
from itertools import product
from collections import defaultdict
from sklearn.random_projection import SparseRandomProjection
from sklearn.metrics.pairwise import pairwise_distances

def pairwiseDistCorr(X1, X2):
    d1 = pairwise_distances(X1)
    d2 = pairwise_distances(X2)
    return np.corrcoef(d1.ravel(), d2.ravel())[0, 1]

_, dataset, output = sys.argv

with h5py.File(dataset, 'r') as f:
    x_train = np.array(f['x_train'])

results = defaultdict(dict)
results2 = np.zeros((x_train.shape[1], 10))
for i, dim in product(range(10), range(x_train.shape[1])):
    rp = SparseRandomProjection(n_components=dim + 1, random_state=i)
    results[dim][i] = pairwiseDistCorr(rp.fit_transform(x_train), x_train)
    results2[dim][i] = pairwiseDistCorr(rp.fit_transform(x_train), x_train)

plt.xlabel('Number of Dimensions')
plt.ylabel('Distance')
plt.xticks(range(x_train.shape[1]))
plt.xlim(xmin=1)
plt.gca().xaxis.grid(True)
plt.plot(results2.mean(axis=1))
plt.savefig(output)