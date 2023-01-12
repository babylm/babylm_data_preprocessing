# wikipedia
python sample_chunks_and_split.py --input_file preprocessed_data/wikipedia.txt --output_dir babylm_data --n_keep 10000000 --n_keep_dev 1000000 --split_at 5000 --seed 12

# gutenberg
python sample_chunks_and_split.py --input_file preprocessed_data/gutenberg.txt --output_dir babylm_data --n_keep 10000000 --n_keep_dev 1000000 --split_at 5000 --seed 0

# openSubtitles
python sample_chunks_and_split.py --input_file preprocessed_data/open_subtitles.txt --output_dir babylm_data --n_keep 30000000 --n_keep_dev 3000000 --split_at 5000

# simple english wiki
python sample_chunks_and_split.py --input_file preprocessed_data/simple_wikipedia.txt --output_dir babylm_data --n_keep 15000000 --n_keep_dev 1500000 --split_at 5000 --seed 2

# QED
python sample_chunks_and_split.py --input_file preprocessed_data/qed.txt --output_dir babylm_data --n_keep 10000000 --n_keep_dev 1000000 --split_at 5000 --seed 3

# childes
python sample_chunks_and_split.py --input_file preprocessed_data/aochildes.txt --output_dir babylm_data --p_keep 0.833 --p_keep_dev 0.0835 --split_at 10000 --seed 6

# bnc
python sample_chunks_and_split.py --input_file preprocessed_data/bnc_spoken.txt --output_dir babylm_data --p_keep 0.833 --p_keep_dev 0.0835 --split_at 10000 --seed 11

# children_stories
python sample_chunks_and_split.py --input_file preprocessed_data/children_stories.txt --output_dir babylm_data --p_keep 0.833 --p_keep_dev 0.0835 --split_at 2000 --seed 10

# switchboard
python sample_chunks_and_split.py --input_file preprocessed_data/switchboard.txt --output_dir babylm_data --p_keep 0.833 --p_keep_dev 0.0835 --split_at 2000 --seed 11

# cbtest
cp preprocessed_data/cbt_test.txt babylm_data/cbt.test
cp preprocessed_data/cbt_train.txt babylm_data/cbt.train
cp preprocessed_data/cbt_valid.txt babylm_data/cbt.dev

zip -r babylm_data.zip babylm_data

