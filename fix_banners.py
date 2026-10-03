import sys
file_path = 'lib/features/auth/screens/admin_home_screen.dart'
with open(file_path, 'r', encoding='utf-8') as f:
    text = f.read()

text = text.replace("await ApiService.delete('/banners/{banner.id}');", "await ApiService.delete('/banners/${banner.id}');")

with open(file_path, 'w', encoding='utf-8') as f:
    f.write(text)
print('Fixed banner delete')
