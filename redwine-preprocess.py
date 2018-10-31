import pandas as pd
from sklearn.model_selection import train_test_split
from sklearn.preprocessing import scale
import sys
import h5py

_, data, output = sys.argv

df = pd.read_csv(data, sep=';')

x, y = df.drop('quality', axis=1), df['quality'].to_frame()
y.loc[(y['quality'] >= 0) & (y['quality'] <= 5), 'quality'] = 0
y.loc[(y['quality'] >= 6), 'quality'] = 100
x = scale(x)
x_train, x_test, y_train, y_test = train_test_split(x, y, test_size=.2, random_state=0)

f = h5py.File(output, 'w')
f.create_dataset('x_train', data=x_train)
f.create_dataset('x_test', data=x_test)
f.create_dataset('y_train', data=y_train)
f.create_dataset('y_test', data=y_test)
f.close()
