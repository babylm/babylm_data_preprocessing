from random import random
import argparse
import re
from random import seed

def find_nlines_nwords():
    with open(args.input_file) as f_in:
        n_lines, n_words = 0, 0
        for line in f_in:
            n_lines += 1
            n_words += len(line.split())
    return n_lines, n_words

def write_chunk(chunk, p_keep, f_train, p_keep_dev=None, f_dev=None, f_test=None):
    if random() < p_keep:
        f_train.writelines(chunk)
    elif p_keep_dev is not None and random() < p_keep_dev / (1- p_keep):
        f_test.writelines(chunk)
    elif p_keep_dev is not None and random() < p_keep_dev / ((1 - p_keep) - p_keep_dev):
        f_dev.writelines(chunk)

def sample_chunks():
    with open(args.input_file) as f_in:
        file_name = args.input_file.split("/")[-1].split(".")[0] if args.output_file is None else args.output_file
        out_prefix = args.output_dir + "/" + file_name
        test_dev = args.p_keep_dev is not None or args.n_keep_dev is not None
        if args.split_at.isdecimal() or args.n_keep:
            n_lines, n_words = find_nlines_nwords()
        if args.split_at.isdecimal():
            chunksize = int(int(args.split_at) * n_lines / n_words)
        p_keep = args.p_keep if args.p_keep else args.n_keep / n_words
        if args.p_keep_dev:
            p_keep_dev = args.p_keep_dev
        elif args.n_keep_dev:
            p_keep_dev = args.n_keep_dev / n_words
        else:
            p_keep_dev = None
        with open(out_prefix + ".train", "w") as f_train, open(out_prefix + ".test", "w") as f_test, open(out_prefix + ".dev", "w") as f_dev:
            print(out_prefix + ".train")
            chunk = []
            counter = 0
            for line in f_in:
                chunk.append(line)
                counter += 1
                if (args.split_at == "newline" and line == "\n") or (args.split_at.isdecimal() and counter == int(args.split_at)):
                    write_chunk(chunk, p_keep, f_train, p_keep_dev, f_dev, f_test)
                    chunk = []
                    counter = 0
            if len(chunk) > 0:
                write_chunk(chunk, p_keep, f_train, p_keep_dev, f_dev, f_test)



if __name__ == "__main__":
    parser = argparse.ArgumentParser(description="Sample n% of a file or a fixed number of lines, and possibly split into train/test/dev")
    parser.add_argument("--input_file", help="The file")
    parser.add_argument("--output_dir", help="The output directory")
    parser.add_argument("--output_file", help="The output file name")
    parser.add_argument("--p_keep", type=float, help="Percent of lines to keep (don't use with n_keep)")
    parser.add_argument("--p_keep_dev", type=float, help="Percent of lines to keep for dev/test (don't use with n_keep_dev)")
    parser.add_argument("--n_keep", type=int, help="Number of lines to keep (don't use with p_keep)")
    parser.add_argument("--n_keep_dev", type=int, help="Number of lines to keep for dev/test (don't use with p_keep_dev)")
    parser.add_argument("--split_at", help="If newline, split at newlines. If integer, it's the number of lines to include in a chunk.")
    parser.add_argument("--seed", type=int, default=1234, help="random seed for random sampling")
    args = parser.parse_args()

    seed(args.seed)
    sample_chunks()

