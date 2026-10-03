const fs = require('fs');

let text = fs.readFileSync('backend/routes/vendors.js', 'utf8');

const newRoute = `
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
`;

text = text.replace("module.exports = router;", newRoute + "\nmodule.exports = router;");

fs.writeFileSync('backend/routes/vendors.js', text);
