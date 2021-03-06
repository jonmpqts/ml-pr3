import sys
import h5py
import json
import numpy as np
from time import clock
from sklearn.cluster import KMeans
from sklearn.externals import joblib

_, dataset, settings_path, output = sys.argv

with h5py.File(dataset, 'r') as f:
    x_train = np.array(f['x_train'])

with open(settings_path, 'r') as j:
    settings = json.load(j)

classifiers = {}

for k in settings['clusters']:
    km = KMeans(n_clusters=k, random_state=0)
    st = clock()
    km.fit(x_train)
    km.time = clock() - st
    classifiers[k] = km

joblib.dump(classifiers, output)
