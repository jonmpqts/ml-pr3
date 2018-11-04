import sys
import h5py
import numpy as np
import matplotlib.pyplot as plt
from sklearn.decomposition import PCA

_, dataset, output = sys.argv

with h5py.File(dataset, 'r') as f:
    x_train = np.array(f['x_train'])

pca = PCA(random_state=0)
pca.fit(x_train)
plt.plot(np.cumsum(pca.explained_variance_ratio_))
plt.xticks(range(x_train.shape[1]))
plt.xlabel('Number of Principal Components')
plt.ylabel('Cummulative Variance (%)')
plt.gca().yaxis.grid(True)
plt.savefig(output)