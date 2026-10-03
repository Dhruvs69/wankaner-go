const fs = require('fs');
let text = fs.readFileSync('backend/routes/orders.js', 'utf-8');

// Ensure firebase messaging is required at the top
if (!text.includes("const { getMessaging } = require('firebase-admin/messaging');")) {
    text = text.replace(
        "const { v4: uuidv4 } = require('uuid');", 
        "const { v4: uuidv4 } = require('uuid');\nconst { getMessaging } = require('firebase-admin/messaging');"
    );
}

// Write a helper function for sending order push notifications
const helperFunc = `
async function sendOrderPushNotification(orderId, newStatus) {
    try {
        const [rows] = await db.query(
            'SELECT o.id, u.fcm_token FROM orders o JOIN users u ON o.customer_id = u.id WHERE o.id = ?', 
            [orderId]
        );
        if (rows.length > 0 && rows[0].fcm_token) {
            let title = 'Order Update';
            let message = \`Your order \${orderId} has been updated to \${newStatus}.\`;
            
            if (newStatus === 'processing') {
                title = 'Order Accepted!';
                message = 'The restaurant has accepted your order and is preparing it.';
            } else if (newStatus === 'out for delivery') {
                title = 'Order Out for Delivery!';
                message = 'Your delivery partner is on the way.';
            } else if (newStatus === 'delivered') {
                title = 'Order Delivered! 🎉';
                message = 'Enjoy your food!';
            }

            const payload = {
                notification: { title, body: message },
                data: { title, message, order_id: orderId }
            };

            await getMessaging().send({
                token: rows[0].fcm_token,
                notification: payload.notification,
                data: payload.data,
                android: {
                    priority: 'high',
                    notification: {
                        channelId: 'wankaner_go_channel_id',
                        sound: 'default',
                        defaultSound: true,
                        defaultVibrateTimings: true,
                        clickAction: 'FLUTTER_NOTIFICATION_CLICK'
                    }
                }
            });
            console.log('Sent push notification to customer for order', orderId);
        }
    } catch (err) {
        console.error('Failed to send order push notification:', err.message);
    }
}
`;

if (!text.includes('sendOrderPushNotification')) {
    text = text.replace('// Get active orders (admin/vendor view)', helperFunc + '\n// Get active orders (admin/vendor view)');
}

// Inject it into the PUT route
// At the end of the PUT route, before res.json({ message: 'Order updated successfully' });
text = text.replace(
    "res.json({ message: 'Order updated successfully' });",
    "if (status) await sendOrderPushNotification(req.params.id, status);\n        res.json({ message: 'Order updated successfully' });"
);

fs.writeFileSync('backend/routes/orders.js', text, 'utf-8');
console.log('orders.js push notifications updated');
