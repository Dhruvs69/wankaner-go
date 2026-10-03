import os
import re

def balance_parens(text, start_index):
    count = 0
    for i in range(start_index, len(text)):
        if text[i] == '(':
            count += 1
        elif text[i] == ')':
            count -= 1
            if count == 0:
                return i
    return -1

def process_file(path):
    with open(path, 'r', encoding='utf-8') as f:
        text = f.read()
    
    modified = False
    idx = 0
    while True:
        # Search for ListTile( or RadioListTile<...>( or SwitchListTile(
        match = re.search(r'\b(ListTile|RadioListTile(?:<[^>]+>)?|SwitchListTile)\(', text[idx:])
        if not match:
            break
            
        start_pos = idx + match.start()
        open_paren_pos = idx + match.end() - 1
        
        # Ensure we are not already inside a Material
        before = text[max(0, start_pos-40):start_pos]
        if 'Material(type: MaterialType.transparency, child:' in before or 'Material(color: Colors.transparent, child:' in before:
            idx = open_paren_pos + 1
            continue
            
        end_pos = balance_parens(text, open_paren_pos)
        if end_pos != -1:
            # Wrap in Material
            replacement = 'Material(type: MaterialType.transparency, child: ' + text[start_pos:end_pos+1] + ')'
            text = text[:start_pos] + replacement + text[end_pos+1:]
            modified = True
            idx = start_pos + len(replacement)
        else:
            idx = open_paren_pos + 1

    if modified:
        with open(path, 'w', encoding='utf-8') as f:
            f.write(text)

for root, _, files in os.walk('lib'):
    for f in files:
        if f.endswith('.dart'):
            process_file(os.path.join(root, f))
