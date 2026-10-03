import sys
import re

file_path = 'lib/features/auth/screens/customer_home_screen.dart'
with open(file_path, 'r', encoding='utf-8') as f:
    text = f.read()

pattern = r'const CheckoutScreen\(\)'
replacement = r'CheckoutScreen(totalAmount: cart.fold<double>(0, (sum, i) => sum + (i.unitPrice * i.quantity)))'

text = re.sub(pattern, replacement, text)

with open(file_path, 'w', encoding='utf-8') as f:
    f.write(text)
print('Fixed totalAmount')
