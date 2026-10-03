import re

file_path = 'lib/features/auth/screens/admin_home_screen.dart'
with open(file_path, 'r', encoding='utf-8') as f:
    text = f.read()

newSettings = """  Widget _buildSettings() {
    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('App Settings', style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold)),
            const SizedBox(height: 24),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Card(
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                    child: Padding(
                      padding: const EdgeInsets.all(24.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Row(
                            children: [
                              Icon(Icons.local_shipping, color: Colors.deepOrange),
                              SizedBox(width: 8),
                              Text('Delivery & Commissions', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                            ],
                          ),
                          const SizedBox(height: 24),
                          const TextField(
                            decoration: InputDecoration(
                              labelText: 'Base Delivery Fee (₹)',
                              prefixIcon: Icon(Icons.currency_rupee),
                              border: OutlineInputBorder(),
                            ),
                          ),
                          const SizedBox(height: 20),
                          const TextField(
                            decoration: InputDecoration(
                              labelText: 'Platform Commission (%)',
                              prefixIcon: Icon(Icons.percent),
                              border: OutlineInputBorder(),
                            ),
                          ),
                          const SizedBox(height: 20),
                          const TextField(
                            decoration: InputDecoration(
                              labelText: 'Minimum Order Value (₹)',
                              prefixIcon: Icon(Icons.shopping_cart_checkout),
                              border: OutlineInputBorder(),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 24),
                Expanded(
                  child: Card(
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                    child: Padding(
                      padding: const EdgeInsets.all(24.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Row(
                            children: [
                              Icon(Icons.admin_panel_settings, color: Colors.deepPurple),
                              SizedBox(width: 8),
                              Text('System Controls', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                            ],
                          ),
                          const SizedBox(height: 24),
                          SwitchListTile(
                            title: const Text('App Maintenance Mode', style: TextStyle(fontWeight: FontWeight.bold)),
                            subtitle: const Text('Temporarily disable ordering for all customers.'),
                            value: false,
                            activeColor: Colors.red,
                            onChanged: (val) {},
                          ),
                          const Divider(),
                          SwitchListTile(
                            title: const Text('Auto-Assign Delivery Partners', style: TextStyle(fontWeight: FontWeight.bold)),
                            subtitle: const Text('Automatically ping nearby riders when order is ready.'),
                            value: true,
                            activeColor: Colors.green,
                            onChanged: (val) {},
                          ),
                          const Divider(),
                          SwitchListTile(
                            title: const Text('Surge Pricing (Peak Hours)', style: TextStyle(fontWeight: FontWeight.bold)),
                            subtitle: const Text('Apply 1.5x delivery fee automatically during high demand.'),
                            value: false,
                            activeColor: Colors.deepOrange,
                            onChanged: (val) {},
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 32),
            Center(
              child: ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(horizontal: 48, vertical: 18),
                  backgroundColor: Colors.deepOrange,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
                icon: const Icon(Icons.save),
                label: const Text('Save All Settings', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Settings Saved Successfully!')));
                },
              ),
            ),
            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }"""

text = re.sub(r'Widget _buildSettings\(\) \{[\s\S]*?child: const Text\(\'Save Settings\'\),\n\s*\),\n\s*\],\n\s*\),\n\s*\),\n\s*\],\n\s*\),\n\s*\);\n\s*\}', newSettings, text)

with open(file_path, 'w', encoding='utf-8') as f:
    f.write(text)
