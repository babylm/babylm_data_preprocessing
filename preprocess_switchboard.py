import re

with open("tmp/switchboard.txt", "w") as out:
    for line in open("tmp/switchboard_raw.txt"):
        line = re.sub(r"(\w)\|(.*?)\|.*?([\n$])", r"\1:\t\2\3", line)
        out.write(line)
