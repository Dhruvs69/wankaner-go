const express = require('express');
const router = express.Router();
const db = require('../db');
const { v4: uuidv4 } = require('uuid');

// Get all addresses for a user
router.get('/user/:userId', async (req, res) => {
    try {
        const [rows] = await db.query('SELECT id, user_id, title as label, address as fullAddress, city, pincode, IFNULL(lat, 0.0) as lat, IFNULL(lng, 0.0) as lng FROM addresses WHERE user_id = ?', [req.params.userId]);
        res.json(rows);
    } catch (err) {
        res.status(500).json({ error: err.message });
    }
});

// Create new address
router.post('/', async (req, res) => {
    const { user_id, title, address, lat, lng } = req.body;
    const id = uuidv4();
    try {
        await db.query(
            'INSERT INTO addresses (id, user_id, title, address, lat, lng) VALUES (?, ?, ?, ?, ?, ?)',
            [id, user_id, title, address, lat || 0.0, lng || 0.0]
        );
        res.status(201).json({ id, message: 'Address created successfully' });
    } catch (err) {
        res.status(500).json({ error: err.message });
    }
});

// Delete an address
router.delete('/:id', async (req, res) => {
    try {
        await db.query('DELETE FROM addresses WHERE id = ?', [req.params.id]);
        res.json({ message: 'Address deleted successfully' });
    } catch (err) {
        res.status(500).json({ error: err.message });
    }
});

module.exports = router;
