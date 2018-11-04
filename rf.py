import sys
import h5py
import numpy as np
from sklearn.ensemble import RandomForestClassifier
from sklearn.externals import joblib

_, dataset, output = sys.argv

with h5py.File(dataset, 'r') as f:
    x_train = np.array(f['x_train'])
    y_train = np.array(f['y_train'])

rf = RandomForestClassifier(n_estimators=100, class_weight='balanced', random_state=0, n_jobs=-1)
rf.fit(x_train, y_train)

joblib.dump(rf, output)
