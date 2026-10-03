const fs = require('fs');
let text = fs.readFileSync('backend/routes/orders.js', 'utf-8');

text = text.replace(
    'const { customer_id, vendor_id, total_amount, delivery_address, items, customer_name, customer_phone } = req.body;',
    'const { customer_id, vendor_id, total_amount, delivery_address, items, customer_name, customer_phone, delivery_lat, delivery_lng } = req.body;'
);

text = text.replace(
    "'INSERT INTO orders (id, customer_id, vendor_id, total_amount, delivery_address, customer_name, customer_phone, delivery_otp, vendor_commission, delivery_fee) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?)',",
    "'INSERT INTO orders (id, customer_id, vendor_id, total_amount, delivery_address, customer_name, customer_phone, delivery_otp, vendor_commission, delivery_fee, delivery_lat, delivery_lng) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)',"
);

text = text.replace(
    "[id, customer_id, vendor_id, total_amount, delivery_address, customer_name || '', customer_phone || '', otp, commission, delivery_fee]",
    "[id, customer_id, vendor_id, total_amount, delivery_address, customer_name || '', customer_phone || '', otp, commission, delivery_fee, delivery_lat || null, delivery_lng || null]"
);

fs.writeFileSync('backend/routes/orders.js', text, 'utf-8');
console.log('orders.js updated');
