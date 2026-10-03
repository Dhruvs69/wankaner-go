import sys
import re

file_path = 'lib/features/auth/screens/customer_home_screen.dart'
with open(file_path, 'r', encoding='utf-8') as f:
    text = f.read()

# Add import if missing
if "import '../../customer/screens/checkout_screen.dart';" not in text:
    text = text.replace("import 'package:flutter/material.dart';", "import 'package:flutter/material.dart';\nimport '../../customer/screens/checkout_screen.dart';")

# Regex to find the empty onPressed block inside the cart icon button
pattern = r'(child:\s*const Icon\(Icons\.shopping_cart, color: Colors\.black87\),\s*\),\s*onPressed:\s*\(\)\s*\{)([\s\S]*?)( \},)'
replacement = r'\1\n                      Navigator.push(\n                        context,\n                        MaterialPageRoute(\n                            builder: (context) => const CheckoutScreen()),\n                      );\n                    },'

text = re.sub(pattern, replacement, text)

with open(file_path, 'w', encoding='utf-8') as f:
    f.write(text)
print('Fixed cart navigation')
