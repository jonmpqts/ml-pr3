import sys
import h5py
import numpy as np
from sklearn.base import TransformerMixin, BaseEstimator
from sklearn.externals import joblib

# http://datascience.stackexchange.com/questions/6683/feature-selection-using-feature-importances-in-random-forests-with-scikit-learn
class ImportanceSelect(BaseEstimator, TransformerMixin):
    def __init__(self, model, n=1):
        self.model = model
        self.n = n

    def fit(self, *args, **kwargs):
        self.model.fit(*args, **kwargs)
        return self

    def transform(self, X):
        return X[:, self.model.feature_importances_.argsort()[::-1][:self.n]]

_, rf_path, dataset, output = sys.argv

with h5py.File(dataset, 'r') as f:
    x_train = np.array(f['x_train'])
    y_train = np.array(f['y_train'])
    x_test = np.array(f['x_test'])
    y_test = np.array(f['y_test'])

rf = joblib.load(rf_path)

n = len(rf.feature_importances_[rf.feature_importances_ >= 0.1])
filter = ImportanceSelect(rf, n)
new_x_train = filter.fit_transform(x_train, y_train)
new_x_test = filter.transform(x_test)

with h5py.File(output, 'w') as f:
    f.create_dataset('x_train', data=new_x_train)
    f.create_dataset('x_test', data=new_x_test)
    f.create_dataset('y_train', data=y_train)
    f.create_dataset('y_test', data=y_test)
