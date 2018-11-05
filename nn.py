import sys
import h5py
import numpy as np
from sklearn.neural_network import MLPClassifier
from sklearn.model_selection import GridSearchCV
from sklearn.externals import joblib

_, dataset, output = sys.argv

nn_arch= [(50,50),(50,),(25,),(25,25),(100,25,100)]
nn_reg = [10**-x for x in range(1,5)]

with h5py.File(dataset, 'r') as f:
    x_train = np.array(f['x_train'])
    y_train = np.array(f['y_train'])
    x_test = np.array(f['x_test'])
    y_test = np.array(f['y_test'])

grid = {'alpha': nn_reg, 'hidden_layer_sizes': nn_arch}
mlp = MLPClassifier(max_iter=2000, early_stopping=True, random_state=0)
gs = GridSearchCV(mlp, grid, cv=10)
gs.fit(x_train, y_train)
score = gs.score(x_test, y_test)
joblib.dump(gs.best_estimator_, output)

print(score)
