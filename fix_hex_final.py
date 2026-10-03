import re

file_path = 'lib/features/auth/screens/admin_home_screen.dart'
with open(file_path, 'r', encoding='utf-8') as f:
    text = f.read()

# Replace toHex function
text = re.sub(
    r'String toHex\(Color c\) \{[\s\S]*?\}',
    "String toHex(Color c) { return '#${c.toARGB32().toRadixString(16).padLeft(8, \"0\").toUpperCase()}'; }",
    text
)

with open(file_path, 'w', encoding='utf-8') as f:
    f.write(text)
