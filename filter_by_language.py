from stanza.models.common.doc import Document
from stanza.pipeline.core import Pipeline
import argparse

if __name__ == "__main__":
    parser = argparse.ArgumentParser(description="Sample n% of a file or a fixed number of lines, and possibly split into train/test/dev")
    parser.add_argument("--input_file", help="The file")
    parser.add_argument("--output_file", help="The output file name")
    args = parser.parse_args()

    nlp = Pipeline(lang="multilingual", processors="langid")
    lines = open(args.input_file).readlines()
    with open(args.output_file, "w") as out_file:
        for l in lines:
            if len(l) > 100:    # we can't reliably detect language if there are <100 characters
                doc = Document([], text=l)
                nlp(doc)
                if doc.lang != "en":
                    continue
            out_file.write(l)
            out_file.flush()
