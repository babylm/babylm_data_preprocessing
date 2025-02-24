import os
import re

out_file = open("tmp/simple_wiki.txt", "w")
wiki_dir = "tmp/text"
for d1 in os.listdir(wiki_dir):
	for f in os.listdir(os.path.join(wiki_dir, d1)):
		with open(os.path.join(wiki_dir, d1, f)) as input:
			title = None
			doc = []
			for line in input:
				if line.startswith("<doc"):
					line = next(input)
					title = f"= = = {line.strip()} = = =\n"
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
