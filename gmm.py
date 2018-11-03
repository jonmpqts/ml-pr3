import sys
import h5py
import json
import numpy as np
from sklearn.mixture import GaussianMixture
from sklearn.externals import joblib

_, dataset, settings_path, output = sys.argv

with h5py.File(dataset, 'r') as f:
    x_train = np.array(f['x_train'])

with open(settings_path, 'r') as j:
    settings = json.load(j)

classifiers = {}

for k in settings['components']:
    gmm = GaussianMixture(n_components=k, random_state=0)
    gmm.fit(x_train)
    classifiers[k] = gmm

joblib.dump(classifiers, output)
