# Initialize stuff
Start out in the `data_preprocessing` directory which contains this `README.md`.
```shell
conda create --name babylm_preprocessing
conda activate babylm_preprocessing
PROJECT_DIR=<YOUR_PATH_TO>/babylm_data_preprocessing
mkdir ${PROJECT_DIR}/tmp
mkdir ${PROJECT_DIR}/preprocessed_data
```

# Initial Preprocessing
Some datasets require substantial custom preprocessing.

### CHILDES
I manually downloaded [CHILDES](https://childes.talkbank.org/access/) from here,
and placed all files in the following file structure:
```
├── <PROJECT_DIR>
│   ├── childes
│   │   ├── CHILDES_AAE
│   │   │   ├── <CORPUS_NAME>
│   │   │   ├── ...
│   │   ├── CHILDES_NA
│   │   │   ├── ...
│   │   ├── CHILDES_UK
│   │   │   ├── ...

```
It is a bit tedious but it really only takes about 15 minutes to download manually, 
and I could not find a downloader or API that worked out-of-the-box. 
CHILDES comes with a browsable database, but I don't know if you can just download all the transcripts,
and anyway we do substantial custom preprocessing.

I downloaded all the English corpora, 
specifically North American, UK, and African American English.
Some of the corpora include dialogues with non-neurotypical children, including
children with autism or brain lesions.
I don't consider this a problem because child utterances in CHILDES are extremely diverse
and cover a wide range of ages and stages of development. 
However, I excluded all corpora from the PhonBank collection, 
as much of this data is not dialogue, but individual words elicited in a lab setting.

The raw texts contain a lot of metadata and annotations that need to be removed or edited.
The following script takes care of this:
```shell
# Run from ${PROJECT_DIR}
python preprocess_childes.py
```

This will write a new file to `${PROJECT_DIR}/preprocessed_data/childes.txt`



### BNC
(Note: All these steps can also be run from `extract_spoken_bnc.sh`.)

Initialize stuff & download data
```shell
BNC_TMP=${PROJECT_DIR}/tmp/bnc_spoken
mkdir $BNC_TMP
cd $BNC_TMP
curl https://llds.ling-phil.ox.ac.uk/llds/xmlui/bitstream/handle/20.500.14106/2554/2554.zip > bnc.zip
unzip -q bnc.zip
rm bnc.zip
```

Now it's time to select only `.xml` files that came from the spoken domain
```shell
(
for z in download/Texts/*; 
do for y in $z/*; 
do for x in $y/*; 
do sed '2q;d' $x | grep "^<stext" -q && cp $x ${BNC_TMP}; 
done; 
done; 
done
)
rm -rf download
```

Finally, run this python script to extract the text from the `.xml` files
```shell
cd ${PROJECT_DIR}
python preprocess_bnc.py tmp/bnc_spoken/ tmp/bnc_spoken.txt
rm -rf tmp/bnc_spoken
```


### Switchboard
```shell
cd ${PROJECT_DIR}/tmp
curl https://raw.githubusercontent.com/NathanDuran/Switchboard-Corpus/master/swda_data/full_set.txt > switchboard_raw.txt
cd ${PROJECT_DIR}
python preprocess_switchboard.py
rm tmp/switchboard_raw.txt
```



### Children's Books (Gutenberg)
Here we just follow the README in the gutenberg repo. Any issues should be directed to the authors of gutenberg
```shell
cd ${PROJECT_DIR}
git clone https://github.com/pgcorpus/gutenberg.git
cd gutenberg

#To install any missing dependencies, just run
pip install -r requirements.txt

## Getting & processing the data
python get_data.py
#This will download a copy of all UTF-8 books in PG and will create a csv file with metadata (e.g. author, title, year, ...).
#Notice that if you already have some of the data, the program will only download those you are missing (we use `rsync` for this). It is hence easy to update the dataset periodically to keep it up-to-date by just running `get_data.py`.

python process_data.py

```
Now we grab sample the top 1000 most downloaded modern English texts for children.
(This should be about 47M words. More data like this is available if needed.)
```shell
cd ${PROJECT_DIR}
python preprocess_gutenberg_child.py
```



### Simple Wiki
```shell
cd ${PROJECT_DIR}/tmp
curl https://dumps.wikimedia.org/simplewiki/20240401/simplewiki-20240401-pages-articles.xml.bz2 > wiki.bz2
bzip2 -d wiki.bz2
python -m wikiextractor.WikiExtractor wiki
cd $PROJECT_DIR
python preprocess_simple_wiki.py
rm tmp/wiki
rm -rf tmp/text
```



### OpenSubtitles
This data was previously preprocessed by Haau-Sing Li for a different project and shared directly with Alex Warstadt.
Preprocessing for OpenSubtitles included removing duplicate or near-duplicate documents.
We do not have easy access to the preprocessing pipeline, so we share the preprocessed files directly on google drive:

Download and unzip the preprocessed data into `${PROJECT_DIR}/tmp` 
from [this link](https://drive.google.com/file/d/1CK_cMVB2M5bD5b-M6y0JDgK8XttbGeBR/view?usp=sharing).




# Removing non-English text and characters
For every data source, we remove non-Latin character and non-English lines.
```shell
cd $PROJECT_DIR
(
for file in bnc_spoken childes gutenberg open_subtitles simple_wiki switchboard;
do python keep_latin_letters_only/main.py --input_file tmp/${file}.txt --output_file tmp/${file}_keep_latin.txt;
python filter_by_language.py --input_file tmp/${file}_keep_latin.txt --output_file preprocessed_data/${file}.txt;
rm tmp/${file}_keep_latin.txt;
done
)
```

```shell
for file in bnc_spoken childes gutenberg open_subtitles simple_wiki switchboard; do
    python keep_latin_letters_only/main.py --input_file "tmp/${file}.txt" --output_file "tmp/${file}_keep_latin.txt"
    python filter_by_language.py --input_file "tmp/${file}_keep_latin.txt" --output_file "preprocessed_data/${file}.txt"
    rm "tmp/${file}_keep_latin.txt"
done
```

```shell
for file in simple_wiki switchboard; do
    python keep_latin_letters_only/main.py --input_file "tmp/${file}.txt" --output_file "preprocessed_data/${file}.txt"
done
```


# Sampling and splitting data

First we need to determine how many lines to sample from each source:

```shell
wc -wl preprocessed_data/*
```

| lines | words | lines/word | max words wanted | lines wanted | source
|---:|---:|---|---|---|---|
|   1038961 | 9945650    | | 8.5M/850k | 0.83/0.0835 | preprocessed_data/bnc_spoken.txt
|   6850153 | 34320007   | | 30/3M | 0.83/0.0835 | preprocessed_data/childes.txt
|   1196014 | 47332850   | | 25M/2.5M | 0.528/0.0528 | preprocessed_data/gutenberg.txt
| 176116495 | 1003945661 | | 20M/2M | 0.0199/0.00199 | preprocessed_data/open_subtitles.txt
|   1391969 | 31544245   | | 15M/1M | 0.475/0.0475 | preprocessed_data/simple_wiki.txt
|    199740 | 1657502    | | 1.5M/150k | 0.83/0.0835 | preprocessed_data/switchboard.txt
| 186793332 | 1128745915 | | 100M/10M | | total


Now we run the sampling script, 
where random seeds are chosen manually to fit the desired quantities relatively closely.
```shell
cd ${PROJECT_DIR}
. sample_chunks_and_split.sh
```
