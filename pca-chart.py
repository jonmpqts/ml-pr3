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
plt.plot(pca.explained_variance_, label='Variance')
plt.plot(np.cumsum(pca.explained_variance_ratio_), label='Cummulative Variance (%)')
plt.xticks(range(x_train.shape[1]))
plt.xlabel('Number of Principal Components')
plt.ylabel('Variance')
plt.gca().yaxis.grid(True)
plt.legend(loc='upper right')
plt.savefig(output)