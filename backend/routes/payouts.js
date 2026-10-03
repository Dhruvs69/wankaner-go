const express = require('express');
const router = express.Router();
const pool = require('../db');

// Get all payouts (Admin)
router.get('/', async (req, res) => {
    try {
        const [rows] = await pool.query('SELECT p.*, u.name as user_name FROM payouts p JOIN users u ON p.user_id = u.id ORDER BY p.created_at DESC');
        res.json(rows);
    } catch (error) {
        res.status(500).json({ error: error.message });
    }
});

// Create a payout (Admin)
router.post('/', async (req, res) => {
    const { id, user_id, amount, type } = req.body;
    try {
        // Deduct from wallet
        if (type === 'vendor') {
            await pool.query('UPDATE vendors SET wallet_balance = wallet_balance - ? WHERE owner_id = ?', [amount, user_id]);
        } else {
            await pool.query('UPDATE users SET wallet_balance = wallet_balance - ? WHERE id = ?', [amount, user_id]);
        }
        
        await pool.query(
            'INSERT INTO payouts (id, user_id, amount, type, status) VALUES (?, ?, ?, ?, ?)',
            [id, user_id, amount, type, 'completed']
        );
        res.json({ success: true });
    } catch (error) {
        res.status(500).json({ error: error.message });
    }
});

// Get payouts by user (Vendor / Delivery)
router.get('/user/:user_id', async (req, res) => {
    try {
        const [rows] = await pool.query('SELECT * FROM payouts WHERE user_id = ? ORDER BY created_at DESC', [req.params.user_id]);
        res.json(rows);
    } catch (error) {
        res.status(500).json({ error: error.message });
    }
});

module.exports = router;
