import pandas as pd
import matplotlib.pyplot as plt
import sys

plt.style.use('ggplot')

_, data, output = sys.argv

df = pd.read_csv(data, sep=';')
df = df.drop('quality', 1)
df.hist(figsize=(15, 11))
plt.savefig(output)