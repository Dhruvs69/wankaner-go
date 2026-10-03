const express = require('express');
const router = express.Router();
const pool = require('../db');
const bcrypt = require('bcryptjs');
const { v4: uuidv4 } = require('uuid');

router.get('/', async (req, res) => {
    const role = req.query.role;
    try {
        let query = 'SELECT id, name, email, phone, role, created_at, current_lat, current_lng, is_online, wallet_balance FROM users';
        let params = [];
        if (role) {
            query += ' WHERE role = ?';
            params.push(role);
        }
        const [rows] = await pool.query(query, params);
        res.json(rows);
    } catch (err) {
        res.status(500).json({ error: err.message });
    }
});

router.get('/:id', async (req, res) => {
    try {
        const [rows] = await pool.query('SELECT id, name, email, phone, role, created_at, current_lat, current_lng, is_online, wallet_balance FROM users WHERE id = ?', [req.params.id]);
        if (rows.length === 0) return res.status(404).json({ error: 'User not found' });
        
        const user = rows[0];
        const [addresses] = await pool.query('SELECT id, title as label, address as fullAddress, city, pincode, IFNULL(lat, 0.0) as lat, IFNULL(lng, 0.0) as lng FROM addresses WHERE user_id = ?', [req.params.id]);
        
        user.savedAddresses = addresses;
        res.json(user);
    } catch (err) {
        res.status(500).json({ error: err.message });
    }
});

router.put('/:id/location', async (req, res) => {
    const { lat, lng, is_online } = req.body;
    try {
        let query = 'UPDATE users SET ';
        let params = [];
        let sets = [];
        if (lat !== undefined) { sets.push('current_lat = ?'); params.push(lat); }
        if (lng !== undefined) { sets.push('current_lng = ?'); params.push(lng); }
        if (is_online !== undefined) { sets.push('is_online = ?'); params.push(is_online); }
        
        if (sets.length === 0) return res.json({ message: 'No changes' });
        
        query += sets.join(', ') + ' WHERE id = ?';
        params.push(req.params.id);
        
        await pool.query(query, params);
        res.json({ success: true });
    } catch (err) {
        res.status(500).json({ error: err.message });
    }
});



router.post('/:id/addresses', async (req, res) => {
    const { id, label, fullAddress, city, pincode, lat, lng } = req.body;
    const addressId = id || uuidv4();
    try {
        await pool.query(
            'INSERT INTO addresses (id, user_id, title, address, city, pincode, lat, lng) VALUES (?, ?, ?, ?, ?, ?, ?, ?)',
            [addressId, req.params.id, label, fullAddress, city || '', pincode || '', lat || 0.0, lng || 0.0]
        );
        res.status(201).json({ message: 'Address created successfully', id: addressId });
    } catch (err) {
        res.status(500).json({ error: err.message });
    }
});

router.delete('/:id/addresses/:addressId', async (req, res) => {
    try {
        await pool.query('DELETE FROM addresses WHERE id = ? AND user_id = ?', [req.params.addressId, req.params.id]);
        res.json({ message: 'Address deleted successfully' });
    } catch (err) {
        res.status(500).json({ error: err.message });
    }
});

module.exports = router;

