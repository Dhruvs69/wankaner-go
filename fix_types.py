import re

with open('lib/features/auth/screens/vendor_home_screen.dart', 'r', encoding='utf-8') as f:
    text = f.read()

text = text.replace('_uploadedImageUrl = null;', "_uploadedImageUrl = '';")
text = text.replace('if (previewUrl != null && previewUrl.isNotEmpty)', 'if (previewUrl.isNotEmpty)')
text = text.replace('(_uploadedImageUrl ?? \'\')', '(_uploadedImageUrl)')

with open('lib/features/auth/screens/vendor_home_screen.dart', 'w', encoding='utf-8') as f:
    f.write(text)
