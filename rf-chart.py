import sys
import numpy as np
import matplotlib.pyplot as plt
from sklearn.externals import joblib

_, rf_path, output = sys.argv

rf = joblib.load(rf_path)

std = np.std([rf.feature_importances_ for tree in rf.estimators_], axis=0)
indices = np.argsort(rf.feature_importances_)[::-1]

plt.bar(range(len(rf.feature_importances_)), rf.feature_importances_[indices], color='b', yerr=std[indices], align='center')
plt.xticks(range(len(rf.feature_importances_)), indices)
plt.xlim([-1, len(rf.feature_importances_)])
plt.xlabel('Feature')
plt.ylabel('Importance')
plt.savefig(output)
