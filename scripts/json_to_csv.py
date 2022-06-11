import pandas as pd

df = pd.read_json('test.json')
df.to_csv('test.csv', index=False)
