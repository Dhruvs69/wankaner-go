const fs = require('fs');

let text = fs.readFileSync('lib/features/auth/screens/admin_home_screen.dart', 'utf-8');

const originalRow = `                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Expanded(
                              flex: 2,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                      'Order #\${order.id.length > 8 ? order.id.substring(0, 8) : order.id}',
                                      style: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 16)),
                                  Text(
                                      'Date: \${order.createdAt.toLocal().toString().split('.')[0]}',
                                      style: TextStyle(
                                          color: Colors.grey.shade600)),
                                ],
                              ),
                            ),
                            Expanded(
                              flex: 2,
                              child: Text('₹\${order.totalAmount}',
                                  style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16,
                                      color: Colors.green)),
                            ),
                            Expanded(
                              flex: 2,
                              child: Chip(
                                label: Text(order.status.toUpperCase(),
                                    style: const TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 12)),
                                backgroundColor: _getStatusColor(order.status),
                              ),
                            ),
                            Expanded(
                              flex: 3,
                              child: Wrap(`;

const newLayout = `                        child: LayoutBuilder(
                          builder: (context, constraints) {
                            final isMobile = constraints.maxWidth < 600;
                            
                            final col1 = Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                      'Order #\${order.id.length > 8 ? order.id.substring(0, 8) : order.id}',
                                      style: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 16)),
                                  Text(
                                      'Date: \${order.createdAt.toLocal().toString().split('.')[0]}',
                                      style: TextStyle(
                                          color: Colors.grey.shade600)),
                                ],
                              );
                            final col2 = Text('₹\${order.totalAmount}',
                                  style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16,
                                      color: Colors.green));
                            final col3 = Chip(
                                label: Text(order.status.toUpperCase(),
                                    style: const TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 12)),
                                backgroundColor: _getStatusColor(order.status),
                              );
                              
                            if (isMobile) {
                               return Column(
                                 crossAxisAlignment: CrossAxisAlignment.start,
                                 children: [
                                   col1, const SizedBox(height: 12),
                                   Row(children: [col2, const SizedBox(width: 16), col3]),
                                   const SizedBox(height: 12),
                                   Wrap(`;

if (text.includes(originalRow)) {
  text = text.replace(originalRow, newLayout);
  
  // Also we need to close the LayoutBuilder properly. 
  // We opened LayoutBuilder instead of Row.
  // The original ended with:
  //                               ],
  //                             ),
  //                           ),
  //                         ],
  //                       ),
  
  const endOriginal = `                                ],
                              ),
                            ),
                          ],
                        ),`;
  const endNew = `                                ],
                              );
                            }

                            return Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Expanded(flex: 2, child: col1),
                                Expanded(flex: 2, child: col2),
                                Expanded(flex: 2, child: col3),
                                Expanded(
                                  flex: 3,
                                  child: Wrap(
                                    // REPEAT INNER WRAP SO IT MATCHES ORIGINAL FOR DESKTOP
                                    // Wait, it's easier to just close the wrap that is common!
  `;
}
// This is getting too complex. 
