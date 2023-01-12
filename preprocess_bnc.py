import xml.etree.ElementTree as ET
import argparse
import os
import sys

if __name__=="__main__":
    out = open(sys.argv[2], "w")
    docs = []
    for f in os.listdir(sys.argv[1]):
        if f.endswith(".xml"):
            root = ET.parse(os.path.join(sys.argv[1], f)).getroot()
            out.write("\n".join(["".join([x.text for x in s.iter() if x.tag in ["w", "c"]]) for s in root.iter("s")]) + "\n\n")

    out.close()

