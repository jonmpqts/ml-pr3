import sys
import h5py
import numpy as np
import pandas as pd
import matplotlib.pyplot as plt
from sklearn.decomposition import FastICA

_, dataset, output = sys.argv

with h5py.File(dataset, 'r') as f:
    x_train = np.array(f['x_train'])

kurtosis = []
for n in range(x_train.shape[1]):
#    components = n + 1
    ica = FastICA(n_components=n + 1, random_state=0)
    transformed = ica.fit_transform(x_train)
    transformed = pd.DataFrame(transformed)
    kurtosis.append(transformed.kurt(axis=0).abs().mean())

plt.xlabel('Number of Components')
plt.ylabel('Kurtosis')
plt.xticks(range(len(kurtosis)))
plt.xlim(xmin=1)
plt.gca().xaxis.grid(True)
plt.plot(kurtosis)
plt.savefig(output)
