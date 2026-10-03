const fs = require('fs');
let text = fs.readFileSync('lib/features/auth/screens/vendor_home_screen.dart', 'utf-8');

const start = text.indexOf('...order.items.map');
const end = text.indexOf('}).toList(),', text.indexOf('}).toList(),', start) + 12) + 12;

const newBlock = `...order.items.map<Widget>((item) {
                        final mapItem = item as dynamic;
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 4),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text("\${mapItem['quantity']}x \${mapItem['name']}"),
                              Text("₹\${mapItem['price'] * mapItem['quantity']}"),
                            ],
                          ),
                        );
                      }).toList(),`;
                      
text = text.substring(0, start) + newBlock + text.substring(end);
fs.writeFileSync('lib/features/auth/screens/vendor_home_screen.dart', text, 'utf-8');
console.log('Fixed block cleanly');
