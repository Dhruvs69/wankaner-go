const fs = require('fs');
let text = fs.readFileSync('lib/features/auth/screens/delivery_home_screen.dart', 'utf-8');

const originalBtn = `                ElevatedButton(
                  onPressed: isUploadingImage
                      ? null
                      : () async {
                          Navigator.pop(ctx);
                          setState(() {`;

const newBtn = `                ElevatedButton(
                  onPressed: isUploadingImage
                      ? null
                      : () async {
                          if (otpController.text.length != 4) {
                            ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(content: Text('Please enter the 4-digit PIN to confirm delivery.', style: TextStyle(color: Colors.white)), backgroundColor: Colors.red)
                            );
                            return;
                          }
                          Navigator.pop(ctx);
                          setState(() {`;

text = text.replace(originalBtn, newBtn);
fs.writeFileSync('lib/features/auth/screens/delivery_home_screen.dart', text, 'utf-8');
console.log('Frontend OTP strictness applied');
