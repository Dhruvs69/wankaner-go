import sys
file_path = 'lib/features/customer/screens/checkout_screen.dart'
with open(file_path, 'r', encoding='utf-8') as f:
    text = f.read()

text = text.replace("const Text('Pay via UPI (GPay, PhonePe, Paytm)', style: TextStyle(fontSize: 16)),", "Expanded(child: const Text('Pay via UPI (GPay, PhonePe, Paytm)', style: TextStyle(fontSize: 16))),")

with open(file_path, 'w', encoding='utf-8') as f:
    f.write(text)
print('Fixed checkout overflow')
