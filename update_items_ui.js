const fs = require('fs');
const file = 'lib/features/customer/screens/vendor_details_screen.dart';
let text = fs.readFileSync(file, 'utf8');

const target = `                    return InkWell(
                      onTap: () => _showProductDetails(context, ref, item),
                      child: Container(
                        padding: const EdgeInsets.all(16),
                        decoration: const BoxDecoration(
                          border: Border(bottom: BorderSide(color: Color(0xFFEEEEEE))),
                        ),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(item.name, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                                  const SizedBox(height: 6),
                                  Text('₹\${item.price.toStringAsFixed(2)}', style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
                                  const SizedBox(height: 8),
                                  Text(
                                    'Freshly prepared \${item.name}. Tap to view details.',
                                    style: TextStyle(color: Colors.grey.shade600, fontSize: 13),
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
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(16),
                                  child: item.imageUrl.isNotEmpty
                                      ? Image.network(item.imageUrl, width: 130, height: 130, fit: BoxFit.cover, errorBuilder: (c, e, s) => Container(width: 130, height: 130, color: Colors.grey.shade200, child: const Icon(Icons.fastfood, color: Colors.grey)))
                                      : Container(width: 130, height: 130, color: Colors.grey.shade200, child: const Icon(Icons.fastfood, color: Colors.grey)),
                                ),
                                Positioned(
                                  bottom: -15,
                                  child: InkWell(
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
                                    child: Container(
                                      width: 100,
                                      padding: const EdgeInsets.symmetric(vertical: 8),
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: BorderRadius.circular(8),
                                        border: Border.all(color: Colors.grey.shade300),
                                        boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.1), blurRadius: 4, offset: const Offset(0, 2))],
                                      ),
                                      child: Center(
                                        child: Text(
                                          item.isAvailable ? 'ADD' : 'OUT',
                                          style: TextStyle(color: item.isAvailable ? Colors.green.shade700 : Colors.red, fontWeight: FontWeight.bold, fontSize: 16),
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
                    );`;

const replacement = `                    return Container(
                      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(24),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.04),
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
                                      Text('Rs. \${item.price.toStringAsFixed(2)}', style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700, color: Colors.deepOrange)),
                                      const SizedBox(height: 8),
                                      Text(
                                        'Freshly prepared \${item.name} with premium ingredients. Tap to view product details.',
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
                                      tag: 'item_img_\${item.id}',
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
                                                BoxShadow(color: Colors.black.withValues(alpha: 0.1), blurRadius: 10, offset: const Offset(0, 4))
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
                    );`;

if (text.includes("return InkWell(")) {
    // The exact match might fail due to formatting / whitespace differences.
    // So we replace using a simpler logic
    let indexStart = text.indexOf("return InkWell(");
    let indexEnd = text.indexOf(");", indexStart + 4000); // Wait, this is risky
}
