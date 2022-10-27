import re

text = "bug 1: first bug\nbug 2: duplicate of bug 1\nbug 999: the last bug"
for m in re.finditer("bug (\d+):", text):
    print("bug number: " + m.group(1))
