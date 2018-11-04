import pandas as pd
import matplotlib.pyplot as plt
import sys

plt.style.use('ggplot')

_, data, output = sys.argv

df = pd.read_csv(data)
df.loc[df['Sex'] == 'female', ['Sex']] = 0
df.loc[df['Sex'] == 'male', ['Sex']] = 1
df = df.drop('Survived', 1)
df.hist(figsize=(15, 11))
plt.savefig(output)
