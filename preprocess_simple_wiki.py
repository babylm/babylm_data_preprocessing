import os
import re

out_file = open(os.path.join("preprocessed_data/simple_wiki.txt"), "w")
wiki_dir = os.path.join("tmp", "text")
for d1 in os.listdir(wiki_dir):
	for f in os.listdir(os.path.join(wiki_dir, d1)):
		with open(os.path.join(wiki_dir, d1, f)) as input:
			title = None
			doc = []
			for line in input:
				if line.startswith("<doc"):
					line = next(input)
					title = line
				elif re.match(r"^\s*$", line):
					continue
				elif "</doc>" in line:
					if len(doc) > 0:
						out_file.write(title)
						out_file.write("".join(doc))
						out_file.write("\n")
						doc = []
				else:
					doc.append(line)


