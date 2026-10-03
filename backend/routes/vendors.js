const express = require('express');
const router = express.Router();
const db = require('../db');
const { v4: uuidv4 } = require('uuid');

// Get all vendors
router.get('/', async (req, res) => {
    try {
        let query = 'SELECT * FROM vendors';
        let params = [];
        if (req.query.owner_id) {
            query += ' WHERE owner_id = ?';
            params.push(req.query.owner_id);
        }
        const [rows] = await db.query(query, params);
        
        // Attach items so the frontend can search inside restaurants
        for (let v of rows) {
            const [items] = await db.query('SELECT name, is_available FROM items WHERE vendor_id = ?', [v.id]);
            v.items = items;
        }

        res.json(rows);
    } catch (err) {
        res.status(500).json({ error: err.message });
    }
});

// Get vendor by ID
router.get('/:id', async (req, res) => {
    try {
        const [rows] = await db.query('SELECT * FROM vendors WHERE id = ?', [req.params.id]);
        if (rows.length === 0) return res.status(404).json({ error: 'Vendor not found' });
        res.json(rows[0]);
    } catch (err) {
        res.status(500).json({ error: err.message });
    }
});

// Create new vendor
router.post('/', async (req, res) => {
    const { owner_id, name, category, rating, is_open, is_active, image_url, distance, lat, lng } = req.body;
    const id = uuidv4();
    try {
        await db.query(
            'INSERT INTO vendors (id, owner_id, name, category, rating, is_open, is_active, image_url, distance, lat, lng) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)',
            [id, owner_id, name, category, rating, is_open, is_active, image_url, distance, lat || 0.0, lng || 0.0]
        );
        res.status(201).json({ id, message: 'Vendor created successfully' });
    } catch (err) {
        res.status(500).json({ error: err.message });
    }
});

// Update vendor
router.put('/:id', async (req, res) => {
    const { name, category, is_open, is_active, image_url, lat, lng } = req.body;
    try {
        await db.query(
            'UPDATE vendors SET name=?, category=?, is_open=?, is_active=?, image_url=?, lat=?, lng=? WHERE id=?',
            [name, category, is_open, is_active, image_url, lat || 0.0, lng || 0.0, req.params.id]
        );
        res.json({ message: 'Vendor updated successfully' });
    } catch (err) {
        res.status(500).json({ error: err.message });
    }
});

// Submit a review
router.post('/:id/reviews', async (req, res) => {
    const { rating, comment, customer_id, order_id } = req.body;
    const vendorId = req.params.id;
    const id = uuidv4();
    try {
        // Start transaction
        await db.query('START TRANSACTION');
        
        // Insert review
        await db.query(
            'INSERT INTO reviews (id, vendor_id, customer_id, order_id, rating, comment) VALUES (?, ?, ?, ?, ?, ?)',
            [id, vendorId, customer_id || 'anonymous', order_id || 'unknown', rating, comment]
        );

        // Update vendor rating
        const [rows] = await db.query('SELECT review_count, total_rating_score FROM vendors WHERE id = ? FOR UPDATE', [vendorId]);
        if (rows.length > 0) {
            let { review_count, total_rating_score } = rows[0];
            review_count += 1;
            total_rating_score += rating;
            const new_rating = total_rating_score / review_count;

            await db.query(
                'UPDATE vendors SET review_count = ?, total_rating_score = ?, rating = ? WHERE id = ?',
                [review_count, total_rating_score, new_rating, vendorId]
            );
        }

        await db.query('COMMIT');
        res.status(201).json({ id, message: 'Review submitted successfully' });
    } catch (err) {
        await db.query('ROLLBACK');
        res.status(500).json({ error: err.message });
    }
});

// Update shop timings
router.put('/:id/timings', async (req, res) => {
    const { opening_time, closing_time } = req.body;
    try {
        await db.query(
            'UPDATE vendors SET opening_time=?, closing_time=? WHERE id=?',
            [opening_time, closing_time, req.params.id]
        );
        res.json({ message: 'Shop timings updated' });
    } catch (err) {
        res.status(500).json({ error: err.message });
    }
});

// Promote vendor (Admin)
router.put('/:id/promote', async (req, res) => {
    const { is_promoted } = req.body;
    try {
        await db.query('UPDATE vendors SET is_promoted=? WHERE id=?', [is_promoted, req.params.id]);
        res.json({ message: 'Vendor promotion status updated' });
    } catch (err) {
        res.status(500).json({ error: err.message });
    }
});

module.exports = router;