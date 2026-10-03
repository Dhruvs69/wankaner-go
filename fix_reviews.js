const fs = require('fs');
let text = fs.readFileSync('backend/routes/vendors.js', 'utf-8');

const brokenSection = `        // Insert review
        await db.query(
            'INSERT INTO reviews (id, vendor_id, customer_id, order_id, rating, comment) VALUES (?, ?, ?, ?, ?, ?)',
            [id, vendorId, customer_id || 'anonymous', order_id || 'unknown', rating, comment]
        );

        
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

// Update vendor rating`;

const fixedSection = `        // Insert review
        await db.query(
            'INSERT INTO reviews (id, vendor_id, customer_id, order_id, rating, comment) VALUES (?, ?, ?, ?, ?, ?)',
            [id, vendorId, customer_id || 'anonymous', order_id || 'unknown', rating, comment]
        );

        // Update vendor rating`;

const promoteRoute = `
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
`;

if (text.includes(brokenSection)) {
    text = text.replace(brokenSection, fixedSection);
    text += promoteRoute; // Add promote route at the end safely
    fs.writeFileSync('backend/routes/vendors.js', text, 'utf-8');
    console.log('Fixed nested route error!');
} else {
    console.log('Broken section not found! Trying regex...');
}
