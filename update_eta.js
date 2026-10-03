const fs = require('fs');
const file = "lib/features/customer/screens/customer_orders_screen.dart";
let content = fs.readFileSync(file, 'utf8');

content = content.replace("'ETA: \\ mins'", "'ETA: ${ (30 - DateTime.now().difference(order.createdAt).inMinutes).clamp(1, 45) } mins'");

fs.writeFileSync(file, content);
