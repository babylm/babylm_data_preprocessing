# Make necessary directories
mkdir babylm_data/
mkdir babylm_data/babylm_100M
mkdir babylm_data/babylm_10M
mkdir babylm_data/babylm_dev
mkdir babylm_data/babylm_test


# Make train 100M/test/dev

## bnc
python sample_chunks_and_split.py --input_file preprocessed_data/bnc_spoken.txt --output_dir babylm_data --p_keep 0.833 --p_keep_dev 0.0835 --split_at 10000 --seed 3

## childes
python sample_chunks_and_split.py --input_file preprocessed_data/childes.txt --output_dir babylm_data --p_keep 0.833 --p_keep_dev 0.0835 --split_at 10000 --seed 0

## children's gutenberg
python sample_chunks_and_split.py --input_file preprocessed_data/gutenberg.txt --output_dir babylm_data --p_keep 0.528 --p_keep_dev 0.0528 --split_at 5000 --seed 13

## openSubtitles
python sample_chunks_and_split.py --input_file preprocessed_data/open_subtitles.txt --output_dir babylm_data --p_keep 0.02 --p_keep_dev 0.002 --split_at 5000 --seed 2

## simple english wiki
python sample_chunks_and_split.py --input_file preprocessed_data/simple_wiki.txt --output_dir babylm_data --p_keep 0.475 --p_keep_dev 0.0475 --split_at 5000 --seed 18

## switchboard
python sample_chunks_and_split.py --input_file preprocessed_data/switchboard.txt --output_dir babylm_data --p_keep 0.833 --p_keep_dev 0.0835 --split_at 2000 --seed 11

## Move to appropriate directories
mv babylm_data/*.train babylm_data/babylm_100M
mv babylm_data/*.dev babylm_data/babylm_dev
mv babylm_data/*.test babylm_data/babylm_test


# Make data for 10M

## bnc
python sample_chunks_and_split.py --input_file babylm_data/babylm_100M/bnc_spoken.train --output_dir babylm_data/babylm_10M --p_keep 0.1 --p_keep_dev 0.1 --split_at 10000 --seed 3

## childes
python sample_chunks_and_split.py --input_file babylm_data/babylm_100M/childes.train --output_dir babylm_data/babylm_10M --p_keep 0.1 --p_keep_dev 0.1 --split_at 10000 --seed 31

## childrens gutenberg
python sample_chunks_and_split.py --input_file babylm_data/babylm_100M/gutenberg.train --output_dir babylm_data/babylm_10M --p_keep 0.1 --p_keep_dev 0.1 --split_at 5000 --seed 5

## openSubtitles
python sample_chunks_and_split.py --input_file babylm_data/babylm_100M/open_subtitles.train --output_dir babylm_data/babylm_10M --p_keep 0.1 --p_keep_dev 0.1 --split_at 5000 --seed 3

## simple english wiki
python sample_chunks_and_split.py --input_file babylm_data/babylm_100M/simple_wiki.train --output_dir babylm_data/babylm_10M --p_keep 0.1 --p_keep_dev 0.1 --split_at 5000 --seed 6

## switchboard
python sample_chunks_and_split.py --input_file babylm_data/babylm_100M/switchboard.train --output_dir babylm_data/babylm_10M --p_keep 0.1 --p_keep_dev 0.1 --split_at 2000 --seed 6

rm babylm_data/babylm_10M/*.dev
rm babylm_data/babylm_10M/*.test
wc -w babylm_data/babylm_10M/*.train


# Make data for 50M

## bnc
python sample_chunks_and_split.py --input_file babylm_data/babylm_100M/bnc_spoken.train --output_dir babylm_data/babylm_50M --p_keep 0.5 --p_keep_dev 0.1 --split_at 10000 --seed 2

## childes
python sample_chunks_and_split.py --input_file babylm_data/babylm_100M/childes.train --output_dir babylm_data/babylm_50M --p_keep 0.5 --p_keep_dev 0.1 --split_at 10000 --seed 14

## childrens gutenberg
python sample_chunks_and_split.py --input_file babylm_data/babylm_100M/gutenberg.train --output_dir babylm_data/babylm_50M --p_keep 0.5 --p_keep_dev 0.1 --split_at 5000 --seed 2

## openSubtitles
python sample_chunks_and_split.py --input_file babylm_data/babylm_100M/open_subtitles.train --output_dir babylm_data/babylm_50M --p_keep 0.5 --p_keep_dev 0.1 --split_at 5000 --seed 0

## simple english wiki
python sample_chunks_and_split.py --input_file babylm_data/babylm_100M/simple_wiki.train --output_dir babylm_data/babylm_50M --p_keep 0.5 --p_keep_dev 0.1 --split_at 5000 --seed 2

## switchboard
python sample_chunks_and_split.py --input_file babylm_data/babylm_100M/switchboard.train --output_dir babylm_data/babylm_50M --p_keep 0.5 --p_keep_dev 0.1 --split_at 2000 --seed 1

rm babylm_data/babylm_50M/*.dev
rm babylm_data/babylm_50M/*.test
wc -w babylm_data/babylm_50M/*.train


zip -r babylm_data.zip babylm_data

