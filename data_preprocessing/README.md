# Initialize stuff
Start out in the `data_preprocessing` directory which contains this `README.md`.
```shell
conda create --name babylm_preprocessing
conda activate babylm_preprocessing
DATA_DIR=/scratch/asw462/shared_task/data_preprocessing
mkdir ${DATA_DIR}/tmp
mkdir ${DATA_DIR}/preprocessed_data
```


# Direct downloads of preprocessed data
Some data is already downloadable in a nice preprocessed form. Let's download those first.

These first three sources were preprocessed by others:

### CHILDES
```shell
cd ${DATA_DIR}/preprocessed_data
curl https://raw.githubusercontent.com/phueb/BabyBERTa/master/data/corpora/aochildes.txt > aochildes.txt
```

### Switchboard
```shell
cd ${DATA_DIR}/preprocessed_data
curl https://raw.githubusercontent.com/NathanDuran/Switchboard-Corpus/master/swda_data/full_set.txt > switchboard.txt
```

### Children's Book Test
```shell
cd ${DATA_DIR}/tmp
curl http://www.thespermwhale.com/jaseweston/babi/CBTest.tgz > CBTest.tgz
tar -xvzf CBTest.tgz
mv CBTest/data/cbt_* ${DATA_DIR}/preprocessed_data/
```

The next two are available in preprocessed form, but for some reason the original download links don't work with `curl`.
So I've uploaded these files to google drive, where they can be downloaded easily from command line:


### QED
The original link which doesn't work with `curl`: `https://opus.nlpl.eu/download.php?f=QED/v2.0a/xml/en.zip`
```shell
cd ${DATA_DIR}/tmp
gdown 1R2xWtNeVX48RiFA7vErL1pNtws3XEsYP
unzip qed.zip
cd ${DATA_DIR}
python preprocess_qed.py tmp/en tmp/qed
cat tmp/qed/* >> preprocessed_data/qed.txt
```

## Children stories
The original link which doesn't work with `curl`: `https://www.kaggle.com/datasets/edenbd/children-stories-text-corpus/download?datasetVersionNumber=1`
```shell
cd ${DATA_DIR}/preprocessed_data
gdown 1nbUCWCAvtqI1-WQxzmyqQmddgsZtzdpR
unzip children_stories.txt.zip
rm children_stories.txt.zip
```


The next two files were preprocessed by Haau-Sing Li for a previous project and shared directly with Alex Warstadt.
We do not have easy access to the preprocessing pipeline, so we share the preprocessed files directly on google drive:

### OpenSubtitles
Preprocessing for OpenSubtitles included removing duplicate or near-duplicate documents.
```shell
cd ${DATA_DIR}/tmp
gdown 1vW0o7K6Gj_IYTzriWEjmCnrylCWb8DbY
unzip open_subtitles.txt.zip
mv open_subtitles.txt ../preprocessed_data
```

### Wikipedia
```shell
cd ${DATA_DIR}/preprocessed_data
gdown 19GipY95MW3LrfO_kArmIC0KYy7mfCb1l
unzip wikipedia.txt.zip
rm wikipedia.txt.zip
```

# Datasets that require substantial preprocessing

### Simple Wiki
```shell
cd ${DATA_DIR}/tmp
curl https://dumps.wikimedia.org/simplewiki/20221201/simplewiki-20221201-pages-articles.xml.bz2 > wiki.bz2
bzip2 -d wiki.bz2
python -m wikiextractor.WikiExtractor wiki
cd $DATA_DIR
python preprocess_simple_wiki.py
```


### Spoken BNC
Initialize stuff & downlaod data
```shell
BNC_TMP=${DATA_DIR}/tmp/bnc_spoken
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

Finally, run this nice python script to extract the text from the `.xml` files
```shell
python preprocess_bnc.py tmp/bnc_spoken/ bnc_spoken.txt
rm -rf tmp/bnc_spoken
```

### Gutenberg
Here we just follow the README in the gutenberg repo. Any issues should be directed to the authors of gutenberg
```shell
cd ${DATA_DIR}
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
Now we grab the English portion and put it all together in one file
```shell
cd ${DATA_DIR}
python get_gutenberg_modern_en.py
cat tmp/gutenberg_modern_en/* >> preprocessed_data/gutenberg.txt
```


# Sampling and splitting data
```shell
cd ${DATA_DIR}
. sample_chunks_and_split.sh
```
