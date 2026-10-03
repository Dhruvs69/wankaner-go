const express = require('express');
const router = express.Router();
const db = require('../db');
const { v4: uuidv4 } = require('uuid');

// Get items for a vendor
router.get('/vendor/:vendorId', async (req, res) => {
    try {
        const [items] = await db.query('SELECT * FROM items WHERE vendor_id = ?', [req.params.vendorId]);
        
        // In a real scenario you would join variants and addons, or fetch them here
        for (let item of items) {
            const [variants] = await db.query('SELECT * FROM item_variants WHERE item_id = ?', [item.id]);
            const [addons] = await db.query('SELECT * FROM item_addons WHERE item_id = ?', [item.id]);
            item.variants = variants;
            item.addons = addons;
        }

        res.json(items);
    } catch (err) {
        res.status(500).json({ error: err.message });
    }
});

// Create new item
router.post('/', async (req, res) => {
    const { vendor_id, name, price, category, image_url, is_vegetarian, description, variants, addons } = req.body;
    const id = uuidv4();
    try {
        await db.query(
            'INSERT INTO items (id, vendor_id, name, price, category, image_url, is_vegetarian, description) VALUES (?, ?, ?, ?, ?, ?, ?, ?)',
            [id, vendor_id, name, price, category, image_url, is_vegetarian, description]
        );

        if (variants && variants.length > 0) {
            for (let v of variants) {
                await db.query('INSERT INTO item_variants (item_id, name, price) VALUES (?, ?, ?)', [id, v.name, v.price]);
            }
        }

        if (addons && addons.length > 0) {
            for (let a of addons) {
                await db.query('INSERT INTO item_addons (item_id, name, price) VALUES (?, ?, ?)', [id, a.name, a.price]);
            }
        }

        res.status(201).json({ id, message: 'Item created successfully' });
    } catch (err) {
        res.status(500).json({ error: err.message });
    }
});

// Update item (for stock or general updates)
router.put('/:id', async (req, res) => {
    const data = req.body;
    const itemId = req.params.id;
    try {
        const variants = data.variants;
        const addons = data.addons;
        delete data.variants;
        delete data.addons;

        if (Object.keys(data).length > 0) {
            let query = 'UPDATE items SET ';
            const values = [];
            for (const key in data) {
                // Map camelCase to snake_case for specific fields if needed
                let column = key;
                if (key === 'isAvailable') column = 'is_available';
                if (key === 'imageUrl') column = 'image_url';
                if (key === 'isVegetarian') column = 'is_vegetarian';
                
                query += `${column} = ?, `;
                values.push(data[key]);
            }
            query = query.slice(0, -2);
            query += ' WHERE id = ?';
            values.push(itemId);
            await db.query(query, values);
        }

        if (variants !== undefined) {
            await db.query('DELETE FROM item_variants WHERE item_id = ?', [itemId]);
            for (let v of variants) {
                await db.query('INSERT INTO item_variants (item_id, name, price) VALUES (?, ?, ?)', [itemId, v.name, v.price]);
            }
        }

        if (addons !== undefined) {
            await db.query('DELETE FROM item_addons WHERE item_id = ?', [itemId]);
            for (let a of addons) {
                await db.query('INSERT INTO item_addons (item_id, name, price) VALUES (?, ?, ?)', [itemId, a.name, a.price]);
            }
        }

        res.json({ message: 'Item updated successfully' });
    } catch (err) {
        res.status(500).json({ error: err.message });
    }
});

// Delete item
router.delete('/:id', async (req, res) => {
    try {
        await db.query('DELETE FROM items WHERE id = ?', [req.params.id]);
        res.json({ message: 'Item deleted successfully' });
    } catch (err) {
        res.status(500).json({ error: err.message });
    }
});

module.exports = router;
