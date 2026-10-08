const express = require('express');
const router = express.Router();
const db = require('../db');
const { v4: uuidv4 } = require('uuid');
const { getMessaging } = require('firebase-admin/messaging');

async function fetchOrderItems(orders) {
    for (let order of orders) {
        const [items] = await db.query('SELECT * FROM order_items WHERE order_id = ?', [order.id]);
        order.items = items;
    }
    return orders;
}


async function sendOrderPushNotification(orderId, newStatus) {
    try {
        const [rows] = await db.query(
            'SELECT o.id, u.fcm_token FROM orders o JOIN users u ON o.customer_id = u.id WHERE o.id = ?', 
            [orderId]
        );
        if (rows.length > 0 && rows[0].fcm_token) {
            let title = 'Order Update';
            let message = `Your order ${orderId} has been updated to ${newStatus}.`;
            
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

            try {
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
            } catch (fcmErr) {
                console.log('FCM Error (ignored):', fcmErr.message);
            }
            console.log('Sent push notification to customer for order', orderId);
        }
    } catch (err) {
        console.error('Failed to send order push notification:', err.message);
    }
}

// Get active orders (admin/vendor view)
router.get('/', async (req, res) => {
    try {
        const [orders] = await db.query('SELECT * FROM orders ORDER BY created_at DESC');
        res.json(await fetchOrderItems(orders));
    } catch (err) {
        res.status(500).json({ error: err.message });
    }
});

// Create new order
router.post('/', async (req, res) => {
    const { customer_id, vendor_id, total_amount, delivery_address, items, customer_name, customer_phone, delivery_lat, delivery_lng } = req.body;
    const crypto = require('crypto');
    const id = 'WK-' + crypto.randomBytes(3).toString('hex').toUpperCase();
    const otp = Math.floor(1000 + Math.random() * 9000).toString(); // 4 digit OTP
    const commission = total_amount * 0.15; // 15% platform fee
    const delivery_fee = req.body.delivery_fee !== undefined ? req.body.delivery_fee : 40.0; // Dynamic delivery fee

    try {
        await db.query(
            'INSERT INTO orders (id, customer_id, vendor_id, total_amount, delivery_address, customer_name, customer_phone, delivery_otp, vendor_commission, delivery_fee, delivery_lat, delivery_lng) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)',
            [id, customer_id, vendor_id, total_amount, delivery_address, customer_name || '', customer_phone || '', otp, commission, delivery_fee, delivery_lat || null, delivery_lng || null]
        );

        for (let item of items) {
            await db.query(
                'INSERT INTO order_items (order_id, item_id, name, price, quantity) VALUES (?, ?, ?, ?, ?)',
                [id, item.item_id, item.name, item.price, item.quantity]
            );
        }

        res.status(201).json({ id, otp, message: 'Order placed successfully' });
    } catch (err) {
        res.status(500).json({ error: err.message });
    }
});

router.get('/customer/:customerId', async (req, res) => {
    try {
        const [orders] = await db.query('SELECT * FROM orders WHERE customer_id = ? ORDER BY created_at DESC', [req.params.customerId]);
        res.json(await fetchOrderItems(orders));
    } catch (err) {
        res.status(500).json({ error: err.message });
    }
});

router.get('/vendor/:vendorId', async (req, res) => {
    try {
        const [orders] = await db.query('SELECT * FROM orders WHERE vendor_id = ? ORDER BY created_at DESC', [req.params.vendorId]);
        res.json(await fetchOrderItems(orders));
    } catch (err) {
        res.status(500).json({ error: err.message });
    }
});

router.get('/active', async (req, res) => {
    try {
        const [orders] = await db.query("SELECT * FROM orders WHERE status IN ('pending', 'processing', 'ready', 'out for delivery') ORDER BY created_at DESC");
        res.json(await fetchOrderItems(orders));
    } catch (err) {
        res.status(500).json({ error: err.message });
    }
});

router.get('/delivery/:partnerId', async (req, res) => {
    try {
        const [orders] = await db.query('SELECT * FROM orders WHERE delivery_partner_id = ? ORDER BY created_at DESC', [req.params.partnerId]);
        res.json(await fetchOrderItems(orders));
    } catch (err) {
        res.status(500).json({ error: err.message });
    }
});

router.put('/:id', async (req, res) => {
    const { status, deliveryPartnerId, proof_image_url, delivery_otp } = req.body;
    try {
        // Verify OTP if marking as delivered and OTP is provided
        if (status === 'delivered') {
            const [rows] = await db.query('SELECT delivery_otp, total_amount, vendor_commission, delivery_fee, vendor_id, delivery_partner_id FROM orders WHERE id = ?', [req.params.id]);
            if (rows.length > 0) {
                const order = rows[0];
                if (!delivery_otp || order.delivery_otp !== delivery_otp) {
                    return res.status(400).json({ error: 'Invalid Delivery OTP' });
                }
                
                // If successfully delivered, update wallet balances
                // Vendor earns total_amount - commission
                const vendorEarns = order.total_amount - order.vendor_commission;
                await db.query('UPDATE vendors SET wallet_balance = wallet_balance + ? WHERE id = ?', [vendorEarns, order.vendor_id]);
                
                // Delivery partner earns delivery_fee
                if (order.delivery_partner_id) {
                     await db.query('UPDATE users SET wallet_balance = wallet_balance + ? WHERE id = ?', [order.delivery_fee, order.delivery_partner_id]);
                }
            }
        }

        if (proof_image_url) {
            await db.query('UPDATE orders SET status = ?, proof_image_url = ? WHERE id = ?', [status || 'delivered', proof_image_url, req.params.id]);
        } else if (deliveryPartnerId) {
            // Ignore status from old frontend apps when assigning a partner
            await db.query('UPDATE orders SET delivery_partner_id = ? WHERE id = ?', [deliveryPartnerId, req.params.id]);
        } else if (status) {
            await db.query('UPDATE orders SET status = ? WHERE id = ?', [status, req.params.id]);
        }
        if (status) await sendOrderPushNotification(req.params.id, status);
        res.json({ message: 'Order updated successfully' });
    } catch (err) {
        console.error(`[PUT /orders/${req.params.id}] Error:`, err);
        res.status(500).json({ error: err.message });
    }
});

module.exports = router;
