const fs = require('fs');
let text = fs.readFileSync('backend/routes/orders.js', 'utf-8');

const original = `                if (delivery_otp && order.delivery_otp !== delivery_otp) {
                    return res.status(400).json({ error: 'Invalid Delivery OTP' });
                }`;
const newText = `                if (!delivery_otp || order.delivery_otp !== delivery_otp) {
                    return res.status(400).json({ error: 'Invalid Delivery OTP' });
                }`;

text = text.replace(original, newText);
fs.writeFileSync('backend/routes/orders.js', text, 'utf-8');
console.log('Backend OTP strictness applied');
