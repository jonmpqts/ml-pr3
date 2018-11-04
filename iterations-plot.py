import sys
import matplotlib.pyplot as plt
from sklearn.externals import joblib

_, km_path, gmm_path, output = sys.argv

km = joblib.load(km_path)
gmm = joblib.load(gmm_path)

plt.xlabel('Number of Clusters')
plt.ylabel('Iterations')
plt.gca().yaxis.grid(True)
plt.xticks(list(km.keys()))
plt.xlim(xmin=1)
plt.plot(km.keys(), [km[k].n_iter_ for k in km.keys()])
plt.plot(gmm.keys(), [gmm[k].n_iter_ for k in gmm.keys()])
plt.savefig(output)
