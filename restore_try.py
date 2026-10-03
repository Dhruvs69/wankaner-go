import re

file_path = 'lib/features/auth/screens/admin_home_screen.dart'
with open(file_path, 'r', encoding='utf-8') as f:
    text = f.read()

# Let's fix the specific places

# 1. Update Role
text = text.replace("""                      onChanged: (val) async {
                        
                          final response = await ApiService.put(
                              '/users/${user.id}/role', {'role': val});""", """                      onChanged: (val) async {
                        try {
                          final response = await ApiService.put(
                              '/users/${user.id}/role', {'role': val});""")

# 2. Update Vendor Open/Close
text = text.replace("""                                        onChanged: (val) async {
                                          
                                            final response = await ApiService
                                                .put('/vendors/${vendor.id}', {
                                              'is_open': val,
                                            });""", """                                        onChanged: (val) async {
                                          try {
                                            final response = await ApiService
                                                .put('/vendors/${vendor.id}', {
                                              'is_open': val,
                                            });""")

# 3. Update Vendor Active/Inactive
text = text.replace("""                                        onChanged: (val) async {
                                          
                                            final response = await ApiService
                                                .put('/vendors/${vendor.id}', {
                                              'is_active': val,
                                            });""", """                                        onChanged: (val) async {
                                          try {
                                            final response = await ApiService
                                                .put('/vendors/${vendor.id}', {
                                              'is_active': val,
                                            });""")

# 4. Delete Shop
text = text.replace("""                                        onPressed: () async {
                                          
                                            final response = await ApiService
                                                .delete('/vendors/${vendor.id}');""", """                                        onPressed: () async {
                                          try {
                                            final response = await ApiService
                                                .delete('/vendors/${vendor.id}');""")

# 5. Cancel Order
text = text.replace("""                                          onPressed: () async {
                                            
                                              final response =
                                                  await ApiService.put(
                                                      '/orders/${order.id}',
                                                      {'status': 'cancelled'});""", """                                          onPressed: () async {
                                            try {
                                              final response =
                                                  await ApiService.put(
                                                      '/orders/${order.id}',
                                                      {'status': 'cancelled'});""")

# 6. Global Notifications
text = text.replace("""                          return;
                        }
                        
                        
                          await ApiService.post('/notifications', {""", """                          return;
                        }
                        
                        try {
                          await ApiService.post('/notifications', {""")

# 7. Add Shop Dialog - pick image
text = text.replace("""  Future<void> _pickAndUploadImage() async {
    
      final picker = ImagePicker();""", """  Future<void> _pickAndUploadImage() async {
    try {
      final picker = ImagePicker();""")

# 8. Add Shop Dialog - submit
text = text.replace("""                    if (vendorIdController.text.isNotEmpty &&
                        nameController.text.isNotEmpty) {
                      final finalImageUrl =
                          imageUrlController.text.trim().isNotEmpty
                              ? imageUrlController.text.trim()
                              : (_uploadedImageUrl ?? '');
  
                      
                        final response = await ApiService.post('/vendors', {""", """                    if (vendorIdController.text.isNotEmpty &&
                        nameController.text.isNotEmpty) {
                      final finalImageUrl =
                          imageUrlController.text.trim().isNotEmpty
                              ? imageUrlController.text.trim()
                              : (_uploadedImageUrl ?? '');
  
                      try {
                        final response = await ApiService.post('/vendors', {""")

# 9. Edit Shop Dialog - pick image
text = text.replace("""  Future<void> _pickAndUploadImage() async {
    
      final picker = ImagePicker();""", """  Future<void> _pickAndUploadImage() async {
    try {
      final picker = ImagePicker();""")

# 10. Edit Shop Dialog - submit
text = text.replace("""                    if (nameController.text.isNotEmpty) {
                      
                        final response =
                            await ApiService.put('/vendors/${widget.vendor.id}', {""", """                    if (nameController.text.isNotEmpty) {
                      try {
                        final response =
                            await ApiService.put('/vendors/${widget.vendor.id}', {""")

with open(file_path, 'w', encoding='utf-8') as f:
    f.write(text)
