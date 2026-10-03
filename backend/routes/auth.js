const express = require('express');
const router = express.Router();
const db = require('../db');
const bcrypt = require('bcryptjs');
const jwt = require('jsonwebtoken');
const { v4: uuidv4 } = require('uuid');

const JWT_SECRET = process.env.JWT_SECRET || 'your-super-secure-random-string';

// Register a new user
router.post('/register', async (req, res) => {
    const { name, phone, email, password, role } = req.body;
    const userRole = role || 'customer';
    
    try {
        const [existing] = await db.query('SELECT * FROM users WHERE email = ?', [email]);
        if (existing.length > 0) {
            return res.status(400).json({ error: 'User already exists with this email' });
        }

        const id = uuidv4();
        const hashedPassword = await bcrypt.hash(password, 10);
        
        await db.query(
            'INSERT INTO users (id, name, email, phone, password, role) VALUES (?, ?, ?, ?, ?, ?)',
            [id, name, email, phone, hashedPassword, userRole]
        );

        const token = jwt.sign({ userId: id, role: userRole }, JWT_SECRET, { expiresIn: '7d' });
        res.status(201).json({ message: 'User registered successfully', userId: id, token });
    } catch (err) {
        res.status(500).json({ error: err.message });
    }
});

// Login
router.post('/login', async (req, res) => {
    const { email, password } = req.body;
    
    try {
        const [users] = await db.query('SELECT * FROM users WHERE email = ?', [email]);
        if (users.length === 0) {
            return res.status(400).json({ error: 'Invalid email or password' });
        }

        const user = users[0];
        const isMatch = await bcrypt.compare(password, user.password);
        
        if (!isMatch) {
            return res.status(400).json({ error: 'Invalid email or password' });
        }

        const token = jwt.sign({ userId: user.id, role: user.role }, JWT_SECRET, { expiresIn: '7d' });
        res.json({ message: 'Login successful', userId: user.id, token, role: user.role });
    } catch (err) {
        res.status(500).json({ error: err.message });
    }
});

module.exports = router;
