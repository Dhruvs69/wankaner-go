const fs = require('fs');
const file = "lib/features/customer/screens/customer_orders_screen.dart";
let content = fs.readFileSync(file, 'utf8');

content = content.replace(/Order #'/g, "Order #${order.id}'");

fs.writeFileSync(file, content);
