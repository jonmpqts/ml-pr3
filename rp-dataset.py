import sys
import h5py
import json
import numpy as np
from sklearn.random_projection import SparseRandomProjection

_, dataset, settings_path, output = sys.argv

with h5py.File(dataset, 'r') as f:
    x_train = np.array(f['x_train'])
    y_train = np.array(f['y_train'])
    x_test = np.array(f['x_test'])
    y_test = np.array(f['y_test'])

with open(settings_path, 'r') as j:
    settings = json.load(j)

rp = SparseRandomProjection(n_components=settings['components'], random_state=0)
new_x_train = rp.fit_transform(x_train, y_train)
new_x_test = rp.transform(x_test)

with h5py.File(output, 'w') as f:
    f.create_dataset('x_train', data=new_x_train)
    f.create_dataset('x_test', data=new_x_test)
    f.create_dataset('y_train', data=y_train)
    f.create_dataset('y_test', data=y_test)
