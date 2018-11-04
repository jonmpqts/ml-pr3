import pandas as pd
from sklearn.model_selection import train_test_split
from sklearn.preprocessing import Imputer, scale
import sys
import h5py

_, data, output = sys.argv

df = pd.read_csv(data)
x, y = df[['Pclass', 'Fare', 'Embarked', 'Sex', 'Age', 'SibSp', 'Parch']], df['Survived'].to_frame()

imr = Imputer(strategy='most_frequent')
imr.fit(x['Age'].values.reshape(-1, 1))
x['Age'] = imr.transform(x['Age'].values.reshape(-1, 1))

x = pd.get_dummies(x, columns=['Pclass', 'Sex', 'Embarked'])
x = scale(x)

x_train, x_test, y_train, y_test = train_test_split(x, y, test_size=.2, random_state=0)

f = h5py.File(output, 'w')
f.create_dataset('x_train', data=x_train)
f.create_dataset('x_test', data=x_test)
f.create_dataset('y_train', data=y_train)
f.create_dataset('y_test', data=y_test)
f.close()
