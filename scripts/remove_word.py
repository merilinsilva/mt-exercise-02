'''
This script is supposed to replace the word 'CHAPTER' and its following numbering
'''

####Imports#####
import sys
import re
################

# Read from stdin
text = sys.stdin.read()

# Replace lines like "CHAPTER I", "CHAPTER IV", etc.
cleaned_text = re.sub(r'\bCHAPTER\s+[IVXLCDM]+\b', '', text, flags=re.IGNORECASE)

# Should write it into the defined file
sys.stdout.write(cleaned_text)