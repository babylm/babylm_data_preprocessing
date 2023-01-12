import re
import os
import sys
from langid.langid import LanguageIdentifier, model

if __name__=="__main__":
    identifier = LanguageIdentifier.from_modelstring(model, norm_probs=True)
    os.makedirs(sys.argv[2], exist_ok=True)
    for f in os.listdir(sys.argv[1]):
        if f.endswith(".xml"):
            document = ""
            out = open(os.path.join(sys.argv[2], f[:-4] + ".txt"), "w")
            for line in open(os.path.join(sys.argv[1], f)):
                if re.match(r"\s*<s", line):
                    sentence = ""
                elif not re.match(r"\s*<", line):
                    sentence += line.strip() + " "
                elif re.match(r"\s*</s", line):
                    document += sentence + "\n"
                elif re.match(r"\s*</document", line):
                    if identifier.classify(document)[0] == "en":
                        out.write(document)
                    out.close()

                else:
                    continue
