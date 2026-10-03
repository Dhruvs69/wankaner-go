import re

file_path = 'lib/features/auth/screens/admin_home_screen.dart'
with open(file_path, 'r', encoding='utf-8') as f:
    text = f.read()

# Replace activeColor with activeThumbColor in SwitchListTile
text = text.replace('activeColor: Colors.red,', 'activeThumbColor: Colors.red,')
text = text.replace('activeColor: Colors.green,', 'activeThumbColor: Colors.green,')
text = text.replace('activeColor: Colors.deepOrange,', 'activeThumbColor: Colors.deepOrange,')

# Find the specific Card block and add const
bad_card = """Expanded(
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
                              labelText: 'Base Delivery Fee (Rs.)',
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
                              labelText: 'Minimum Order Value (Rs.)',
                              prefixIcon: Icon(Icons.shopping_cart_checkout),
                              border: OutlineInputBorder(),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),"""

good_card = """Expanded(
                  child: const Card(
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(16))),
                    child: Padding(
                      padding: EdgeInsets.all(24.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Icon(Icons.local_shipping, color: Colors.deepOrange),
                              SizedBox(width: 8),
                              Text('Delivery & Commissions', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                            ],
                          ),
                          SizedBox(height: 24),
                          TextField(
                            decoration: InputDecoration(
                              labelText: 'Base Delivery Fee (Rs.)',
                              prefixIcon: Icon(Icons.currency_rupee),
                              border: OutlineInputBorder(),
                            ),
                          ),
                          SizedBox(height: 20),
                          TextField(
                            decoration: InputDecoration(
                              labelText: 'Platform Commission (%)',
                              prefixIcon: Icon(Icons.percent),
                              border: OutlineInputBorder(),
                            ),
                          ),
                          SizedBox(height: 20),
                          TextField(
                            decoration: InputDecoration(
                              labelText: 'Minimum Order Value (Rs.)',
                              prefixIcon: Icon(Icons.shopping_cart_checkout),
                              border: OutlineInputBorder(),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),"""

text = text.replace(bad_card, good_card)

with open(file_path, 'w', encoding='utf-8') as f:
    f.write(text)
