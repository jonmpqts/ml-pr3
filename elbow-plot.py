import sys
import h5py
import numpy as np
import matplotlib.pyplot as plt
from sklearn.externals import joblib

_, dataset, classifiers_path, output = sys.argv

with h5py.File(dataset, 'r') as f:
    x_train = np.array(f['x_train'])

classifiers = joblib.load(classifiers_path)
scores = [classifiers[k].score(x_train) for k in classifiers.keys()]

plt.xlabel('Number of Clusters')
plt.ylabel('Score')
plt.title('Elbow Curve')
plt.plot(classifiers.keys(), scores)
plt.savefig(output)
