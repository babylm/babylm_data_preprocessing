# wikipedia
python sample_chunks_and_split.py --input_file ../babylm_data/wikipedia.train --output_dir ../babylm_data_small --p_keep 0.1 --split_at 5000 --seed 10

# gutenberg
python sample_chunks_and_split.py --input_file ../babylm_data/gutenberg.train --output_dir ../babylm_data_small --p_keep 0.1 --split_at 2000 --seed 4

# openSubtitles
python sample_chunks_and_split.py --input_file ../babylm_data/open_subtitles.train --output_dir ../babylm_data_small --p_keep 0.1 --split_at 2000 --seed 3

# simple english wiki
python sample_chunks_and_split.py --input_file ../babylm_data/simple_wikipedia.train --output_dir ../babylm_data_small --p_keep 0.1 --split_at 2000 --seed 0

# QED
python sample_chunks_and_split.py --input_file ../babylm_data/qed.train --output_dir ../babylm_data_small --p_keep 0.1 --split_at 2000 --seed 0

# childes
python sample_chunks_and_split.py --input_file ../babylm_data/aochildes.train --output_dir ../babylm_data_small --p_keep 0.1 --split_at 2000 --seed 3

# bnc
python sample_chunks_and_split.py --input_file ../babylm_data/bnc_spoken.train --output_dir ../babylm_data_small --p_keep 0.1 --split_at 2000 --seed 0

# children_stories
python sample_chunks_and_split.py --input_file ../babylm_data/children_stories.train --output_dir ../babylm_data_small --p_keep 0.1 --split_at 2000 --seed 4

# switchboard
python sample_chunks_and_split.py --input_file ../babylm_data/switchboard.train --output_dir ../babylm_data_small --p_keep 0.1 --split_at 2000 --seed 4

# cbtest
python sample_chunks_and_split.py --input_file ../babylm_data/cbt.train --output_dir ../babylm_data_small --p_keep 0.1 --split_at 2000 --seed 10

