import re

file_path = 'lib/features/auth/screens/admin_home_screen.dart'
with open(file_path, 'r', encoding='utf-8') as f:
    text = f.read()

bad_block = '''                                  Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      const Text('Promoted',
                                          style: TextStyle(
                                              fontSize: 12,
                                              color: Colors.grey)),
                                      Switch(
                                        value: vendor.isPromoted,
                                        activeTrackColor: Colors.purple.shade200,
                                        activeThumbColor: Colors.purple,
                                        onChanged: (val) async {
                                          try {
                                            final response =
                                                await ApiService.put(
                                                    '/vendors//promote', {
                                              'is_promoted': val,
                                            });
                                            if (response.statusCode != 200) {
                                              throw Exception(
                                                  'Failed to update promotion');
                                            }
                                            ref.invalidate(
                                                nearbyVendorsProvider);
                                            if (context.mounted) {
                                              ScaffoldMessenger.of(context)
                                                  .showSnackBar(const SnackBar(
                                                      content: Text(
                                                          ' is now ')));
                                            }
                                          } catch (e) {
                                            if (context.mounted) {
                                              ScaffoldMessenger.of(context)
                                                  .showSnackBar(const SnackBar(
                                                      content:
                                                          Text('Error: ')));
                                            }
                                          }
                                        },
                                      ),
                                    ],
                                  ),'''

good_block = '''                                  Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      const Text('Promoted',
                                          style: TextStyle(
                                              fontSize: 12,
                                              color: Colors.grey)),
                                      Switch(
                                        value: vendor.isPromoted,
                                        activeTrackColor: Colors.purple.shade200,
                                        activeThumbColor: Colors.purple,
                                        onChanged: (val) async {
                                          try {
                                            final response =
                                                await ApiService.put(
                                                    '/vendors/${vendor.id}/promote', {
                                              'is_promoted': val,
                                            });
                                            if (response.statusCode != 200) {
                                              throw Exception(
                                                  'Failed to update promotion');
                                            }
                                            ref.invalidate(
                                                nearbyVendorsProvider);
                                            if (context.mounted) {
                                              ScaffoldMessenger.of(context)
                                                  .showSnackBar(SnackBar(
                                                      content: Text(
                                                          '${vendor.name} is now ${val ? "Promoted" : "Not Promoted"}')));
                                            }
                                          } catch (e) {
                                            if (context.mounted) {
                                              ScaffoldMessenger.of(context)
                                                  .showSnackBar(SnackBar(
                                                      content:
                                                          Text('Error: $e')));
                                            }
                                          }
                                        },
                                      ),
                                    ],
                                  ),'''

if bad_block in text:
    text = text.replace(bad_block, good_block)
    with open(file_path, 'w', encoding='utf-8') as f:
        f.write(text)
    print("Fixed!")
else:
    print("Could not find bad block!")
