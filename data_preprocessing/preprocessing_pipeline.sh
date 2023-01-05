## Initialize stuff
conda activate shared_task
DATA_DIR=/scratch/asw462/shared_task/data_preprocessing
mkdir ${DATA_DIR}/tmp
mkdir ${DATA_DIR}/preprocessed_data

## Simple Wiki
cd tmp
curl https://dumps.wikimedia.org/simplewiki/20221201/simplewiki-20221201-pages-articles.xml.bz2 > wiki.bz2
bzip2 -d wiki.bz2
python -m wikiextractor.WikiExtractor wiki
cd $DATA_DIR 
preprocess_simple_wiki.py

## CHILDES
cd ${DATA_DIR}/preprocessed_data
curl https://raw.githubusercontent.com/phueb/BabyBERTa/master/data/corpora/aochildes.txt > aochildes.txt

## Children stories
# Curl doesn't work here, so we're just gonna download it manually from the following link. No preprocessing needed!
https://www.kaggle.com/datasets/edenbd/children-stories-text-corpus/download?datasetVersionNumber=1
unzip children_stories.zip

## Children's Book Test
curl http://www.thespermwhale.com/jaseweston/babi/CBTest.tgz > CBTest.tgz
tar -xvzf CBTest.tgz
mv CBTest/data/cbt_* ../preprocessed_data/

## QED
curl https://opus.nlpl.eu/download.php?f=QED/v2.0a/mono/en.txt.gz > QED.txt.gz
gzip -d QED.txt.gz

## Switchboard
curl https://raw.githubusercontent.com/NathanDuran/Switchboard-Corpus/master/swda_data/full_set.txt > switchboard.txt

## Spoken BNC
. extract_spoken_bnc.sh 

## Wikipedia
# The Wikipedia dataset we used was a preprocessed dataset from a previous project. That preprocesed data can be downloaded here:
# TODO

## Gutenberg
# Here we just follow the README in the gutenberg repo. Any issues should be directed to the authors of gutenberg
cd gutenberg
pip install -r requirements.txt
python get_data.py
python process_data.py

## OpenSubtitles
# The OpenSubtitles dataset we used was a preprocessed dataset from a previous project. Preprocessing included removing duplicate or near-duplicate documents. That preprocesed data can be downloaded here:
# TODO

. sample_chunks_and_split.sh

