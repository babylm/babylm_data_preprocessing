import pandas as pd
import shutil
import os

df = pd.read_csv("metadata/metadata.csv")
df_modern_en = df[(df["language"] == "['en']") & (df["authoryearofbirth"] > 1850)]
modern_en_ids = set(df_modern_en["id"])

os.makedirs("modern_en")
for f in os.listdir("data/text"): 
    if f.split("_")[0] in modern_en_ids:
        shutil.copyfile("data/text/" + f, "modern_en/" + f)


