import pandas as pd
from collections import Counter
from numpy import isnan
import re

# read in the metadata
df = pd.read_csv("gutenberg/metadata/metadata.csv")

# Filter non-English and old texts
df = df[(df["language"] == "['en']")]
df["is_modern"] = df.apply(lambda row: row["authoryearofbirth"] >= 1800 or isnan(row["authoryearofbirth"]), axis=1)

# Figure out children's subjects
df["subjects"] = df["subjects"].apply(eval)
subjects = list(df["subjects"])
subjects = Counter([s for l in subjects for s in l])
# print(Counter({k: v for k, v in dict(subjects).items() if "Juvenile" in k}).most_common(100))

### Based on above, I've settled on this list
children_subjects = [
    "Juvenile fiction",
    "Juvenile literature",
    "Juvenile poetry",
    "Children's stories",
    "Children's poetry",
    "Children's literature",
    "Children's plays",
    "Fairy tales",
    "Folklore",
    "Fables"
]

### Filter by the list above
def is_children_subject(book_subjects):
    return any([any([cs.lower() in bs.lower() for bs in book_subjects]) for cs in children_subjects])
df["child_subject"] = df.subjects.apply(lambda x: is_children_subject(x))

# Add all books from the Children's Book Test (https://arxiv.org/abs/1511.02301)
# and Children's Stories (https://www.kaggle.com/datasets/edenbd/children-stories-text-corpus) datasets
df_cbt = pd.read_csv("childrens_books_metadata/cbt_titles.csv", index_col=0)
df_cs = pd.read_csv("childrens_books_metadata/childrens_stories_titles.csv")
cbt_titles = set(df_cbt["title"])
cs_titles = set(df_cs["title"])
children_titles = set(df[df["child_subject"]]["title"])
en_titles = set(df["title"])
df["in_cbt"] = df.title.apply(lambda x: x in cbt_titles)
df["in_cs"] = df.title.apply(lambda x: x in cs_titles)
def is_usable(row):
    return row.is_modern and (row.child_subject or row.in_cbt or row.in_cs)
df = df[df.apply(lambda x: is_usable(x), axis=1)]
df = df.sort_values(by="downloads", ascending=False)

# remove duplicates
df = df.sort_values(by=["title", "downloads"]).drop_duplicates(subset=["title", "author"], keep="last")
## TODO: manually remove duplicates by id


N_MOST_COMMON = 1000
ids = list(df.iloc[:N_MOST_COMMON]["id"])

out = open("tmp/gutenberg.txt", "w")
docs = []
fail = 0
for id in ids:
    try:
        doc = ("".join(open(f"gutenberg/data/raw/{id}_raw.txt").readlines()))
        doc = re.sub(r"\n[ \t]+(\S)", r"\n\1", doc)
        doc = re.sub(r"([^\n])\n(\S)", r"\1 \2", doc)
        doc = re.sub(r"\n\s", r"\n", doc)
        doc = re.sub(r"\n\n+", "\n", doc)
        doc = re.sub(r"^.*?\*\*\* ?START OF (THE|THIS) PROJECT GUTENBERG EBOOK (.*?) ?\*\*\*", r"\2", doc, flags=re.S)
        doc = re.sub(r"\*\*\* ?END OF (THE|THIS) PROJECT GUTENBERG .*$", r"", doc, flags=re.S)
        doc = f"= = = {id} = = =\n{doc.strip()}\n\n"
        out.write(doc)
        docs.append(doc)
    except FileNotFoundError:
        fail += 1
    except UnicodeDecodeError:
        fail += 1
        print(id)

print(f"Failed to process: {fail} our of {N_MOST_COMMON}")
n_words = len(" ".join(docs).split())
print(f"Number of words {n_words}")
