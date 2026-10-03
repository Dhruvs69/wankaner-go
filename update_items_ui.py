import re

file_path = 'lib/features/customer/screens/vendor_details_screen.dart'
with open(file_path, 'r', encoding='utf-8') as f:
    text = f.read()

# We want to replace the `return InkWell(...)` inside SliverChildBuilderDelegate.
start_str = "return InkWell("
start_idx = text.find(start_str, text.find('SliverChildBuilderDelegate'))

if start_idx == -1:
    print("Not found")
    exit(0)

# Find matching parenthesis for return InkWell(
brace_count = 0
found_brace = False
end_idx = -1

for i in range(start_idx + len("return InkWell"), len(text)):
    if text[i] == '(':
        brace_count += 1
        found_brace = True
    elif text[i] == ')':
        brace_count -= 1
    
    if found_brace and brace_count == 0:
        end_idx = i + 2 # include );
        break

replacement = """return Container(
                      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(24),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.04),
                            blurRadius: 15,
                            spreadRadius: 0,
                            offset: const Offset(0, 8),
                          ),
                        ],
                      ),
                      child: Material(
                        color: Colors.transparent,
                        borderRadius: BorderRadius.circular(24),
                        child: InkWell(
                          borderRadius: BorderRadius.circular(24),
                          onTap: () => _showProductDetails(context, ref, item),
                          child: Padding(
                            padding: const EdgeInsets.all(16),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        children: [
                                          Icon(Icons.stop_circle_outlined, color: item.categoryId == 'non-veg' ? Colors.red : Colors.green, size: 20),
                                          const SizedBox(width: 6),
                                          Container(
                                            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                            decoration: BoxDecoration(
                                              color: Colors.orange.shade50,
                                              borderRadius: BorderRadius.circular(4),
                                            ),
                                            child: const Text('BESTSELLER', style: TextStyle(color: Colors.orange, fontSize: 10, fontWeight: FontWeight.bold)),
                                          ),
                                        ],
                                      ),
                                      const SizedBox(height: 8),
                                      Text(item.name, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w800, letterSpacing: -0.5)),
                                      const SizedBox(height: 6),
                                      Text('Rs. ${item.price.toStringAsFixed(2)}', style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700, color: Colors.deepOrange)),
                                      const SizedBox(height: 8),
                                      Text(
                                        'Freshly prepared ${item.name} with premium ingredients. Tap to view product details.',
                                        style: TextStyle(color: Colors.grey.shade600, fontSize: 13, height: 1.4),
                                        maxLines: 2,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(width: 16),
                                Stack(
                                  clipBehavior: Clip.none,
                                  alignment: Alignment.bottomCenter,
                                  children: [
                                    Hero(
                                      tag: 'item_img_${item.id}',
                                      child: ClipRRect(
                                        borderRadius: BorderRadius.circular(20),
                                        child: item.imageUrl.isNotEmpty
                                            ? Image.network(item.imageUrl, width: 140, height: 140, fit: BoxFit.cover, errorBuilder: (c, e, s) => Container(width: 140, height: 140, color: Colors.grey.shade100, child: const Icon(Icons.fastfood, color: Colors.grey)))
                                            : Container(width: 140, height: 140, color: Colors.grey.shade100, child: const Icon(Icons.fastfood, color: Colors.grey)),
                                      ),
                                    ),
                                    Positioned(
                                      bottom: -15,
                                      child: GestureDetector(
                                        onTap: item.isAvailable ? () {
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
                                        child: AnimatedContainer(
                                          duration: const Duration(milliseconds: 200),
                                          width: 110,
                                          padding: const EdgeInsets.symmetric(vertical: 10),
                                          decoration: BoxDecoration(
                                            color: item.isAvailable ? Colors.white : Colors.grey.shade200,
                                            borderRadius: BorderRadius.circular(12),
                                            boxShadow: [
                                              if (item.isAvailable)
                                                BoxShadow(color: Colors.black.withOpacity(0.1), blurRadius: 10, offset: const Offset(0, 4))
                                            ],
                                          ),
                                          child: Center(
                                            child: Text(
                                              item.isAvailable ? 'ADD' : 'OUT',
                                              style: TextStyle(color: item.isAvailable ? Colors.green.shade700 : Colors.red, fontWeight: FontWeight.w900, fontSize: 16),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    );"""

text = text[:start_idx] + replacement + text[end_idx:]

with open(file_path, 'w', encoding='utf-8') as f:
    f.write(text)
print("Replaced successfully")
