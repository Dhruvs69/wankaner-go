import re

file_path = 'lib/features/auth/screens/admin_home_screen.dart'
with open(file_path, 'r', encoding='utf-8') as f:
    text = f.read()

# First, remove ALL remaining 'try {' to start clean
text = text.replace('try {', '')

# Now, find all `} catch` occurrences
import re
# We need to find the exact character index of each `} catch`
matches = list(re.finditer(r'\}\s*catch\s*\(', text))

# We must process from right to left so indices don't shift!
for match in reversed(matches):
    catch_idx = match.start() # index of '}'
    
    # Go backwards to find the missing '{'
    balance = -1
    i = catch_idx - 1
    
    while i >= 0:
        if text[i] == '}':
            balance -= 1
        elif text[i] == '{':
            balance += 1
            
        if balance == 0:
            break
        i -= 1
        
    if balance == 0:
        # i is the index of the '{' that contains the try block.
        # We should insert 'try {' right after this '{'
        insert_idx = i + 1
        
        # Insert 'try {'
        text = text[:insert_idx] + '\n                              try {' + text[insert_idx:]
        
with open(file_path, 'w', encoding='utf-8') as f:
    f.write(text)
