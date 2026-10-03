import re

file_path = 'lib/features/customer/screens/vendor_details_screen.dart'
with open(file_path, 'r', encoding='utf-8') as f:
    text = f.read()

start_str = "void _showProductDetails(BuildContext context, WidgetRef ref, Item item) {"
start_idx = text.find(start_str)

if start_idx == -1:
    print("Not found")
    exit(0)

brace_count = 0
found_brace = False
end_idx = -1

for i in range(start_idx + len(start_str) - 1, len(text)):
    if text[i] == '{':
        brace_count += 1
        found_brace = True
    elif text[i] == '}':
        brace_count -= 1
    
    if found_brace and brace_count == 0:
        end_idx = i + 1
        break

replacement = """void _showProductDetails(BuildContext context, WidgetRef ref, Item item) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        height: MediaQuery.of(context).size.height * 0.9,
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(32)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Stack(
              children: [
                Hero(
                  tag: 'item_img_${item.id}',
                  child: ClipRRect(
                    borderRadius: const BorderRadius.vertical(top: Radius.circular(32)),
                    child: item.imageUrl.isNotEmpty
                        ? Image.network(item.imageUrl, height: 350, width: double.infinity, fit: BoxFit.cover, errorBuilder: (c, e, s) => Container(height: 350, color: Colors.grey.shade200, child: const Icon(Icons.fastfood, size: 80)))
                        : Container(height: 350, color: Colors.grey.shade200, child: const Icon(Icons.fastfood, size: 80, color: Colors.grey)),
                  ),
                ),
                Positioned(
                  top: 0, left: 0, right: 0,
                  height: 120,
                  child: Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [Colors.black.withValues(alpha: 0.6), Colors.transparent],
                      ),
                      borderRadius: const BorderRadius.vertical(top: Radius.circular(32)),
                    ),
                  ),
                ),
                Positioned(
                  top: 24,
                  right: 24,
                  child: GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.2),
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.white.withValues(alpha: 0.5)),
                      ),
                      child: const Icon(Icons.close, color: Colors.white, size: 24),
                    ),
                  ),
                ),
              ],
            ),
            Expanded(
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                child: Padding(
                  padding: const EdgeInsets.all(24.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Icon(Icons.stop_circle_outlined, color: item.categoryId == 'non-veg' ? Colors.red : Colors.green, size: 24),
                                    const SizedBox(width: 8),
                                    Container(
                                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                      decoration: BoxDecoration(
                                        color: Colors.orange.shade50,
                                        borderRadius: BorderRadius.circular(6),
                                      ),
                                      child: const Text('BESTSELLER', style: TextStyle(color: Colors.orange, fontSize: 12, fontWeight: FontWeight.bold)),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 12),
                                Text(item.name, style: const TextStyle(fontSize: 32, fontWeight: FontWeight.w900, letterSpacing: -1, height: 1.1)),
                              ],
                            ),
                          ),
                          const SizedBox(width: 16),
                          Text('Rs. ${item.price.toStringAsFixed(2)}', style: const TextStyle(fontSize: 26, fontWeight: FontWeight.w800, color: Colors.deepOrange)),
                        ],
                      ),
                      const SizedBox(height: 24),
                      Row(
                        children: [
                          _buildDetailChip(Icons.local_fire_department, '450 kcal', Colors.orange),
                          const SizedBox(width: 12),
                          _buildDetailChip(Icons.timer, '15-20 min', Colors.blue),
                          const SizedBox(width: 12),
                          _buildDetailChip(Icons.star, '4.8 rating', Colors.amber),
                        ],
                      ),
                      const SizedBox(height: 24),
                      const Divider(height: 1, color: Color(0xFFEEEEEE)),
                      const SizedBox(height: 24),
                      const Text('About this item', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                      const SizedBox(height: 12),
                      Text(
                        'Delicious ${item.name} freshly prepared with premium ingredients. A perfect choice to satisfy your cravings! Our chefs take special care to ensure the authentic taste and quality you expect.',
                        style: const TextStyle(fontSize: 16, color: Colors.black54, height: 1.6),
                      ),
                      const SizedBox(height: 32),
                    ],
                  ),
                ),
              ),
            ),
            Container(
              padding: const EdgeInsets.fromLTRB(24, 16, 24, 32),
              decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.05), offset: const Offset(0, -10), blurRadius: 20)],
              ),
              child: ElevatedButton(
                onPressed: item.isAvailable ? () {
                  Navigator.pop(context); // Close details sheet
                  if (item.variants.isNotEmpty || item.addons.isNotEmpty) {
                    showModalBottomSheet(
                      context: context,
                      isScrollControlled: true,
                      backgroundColor: Colors.transparent,
                      builder: (context) => ItemOptionsBottomSheet(item: item, onAdd: (v, a) => _handleAdd(context, ref, item, v, a)),
                    );
                  } else {
                    _handleAdd(context, ref, item, null, []);
                  }
                } : null,
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 18),
                  backgroundColor: Colors.deepOrange,
                  foregroundColor: Colors.white,
                  elevation: 0,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(item.isAvailable ? Icons.shopping_bag_outlined : Icons.block, size: 24),
                    const SizedBox(width: 12),
                    Text(item.isAvailable ? 'ADD TO CART' : 'OUT OF STOCK', style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, letterSpacing: 1)),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailChip(IconData icon, String label, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withValues(alpha: 0.2)),
      ),
      child: Row(
        children: [
          Icon(icon, size: 16, color: color),
          const SizedBox(width: 6),
          Text(label, style: TextStyle(color: color.withValues(alpha: 0.8), fontSize: 13, fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }
"""

text = text[:start_idx] + replacement + text[end_idx:]

with open(file_path, 'w', encoding='utf-8') as f:
    f.write(text)
print("Replaced successfully")
