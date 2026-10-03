const express = require('express');
const cors = require('cors');
const path = require('path');
const multer = require('multer');
const { initializeApp, cert } = require('firebase-admin/app');
require('dotenv').config();

let credentialParams;
if (process.env.FIREBASE_PRIVATE_KEY) {
  credentialParams = {
    projectId: process.env.FIREBASE_PROJECT_ID,
    clientEmail: process.env.FIREBASE_CLIENT_EMAIL,
    privateKey: process.env.FIREBASE_PRIVATE_KEY.replace(/\\n/g, '\n'),
  };
} else {
  try {
    credentialParams = require('./firebase-service-account.json');
  } catch (e) {
    console.error("No Firebase credentials found. Push notifications will fail.");
  }
}

if (credentialParams) {
  initializeApp({
    credential: cert(credentialParams)
  });
}

require('dotenv').config();

const app = express();
const port = process.env.PORT || 3000;

app.use(cors());
app.use(express.json());
app.use('/uploads', express.static(path.join(__dirname, 'uploads')));

// Routes
const authRoutes = require('./routes/auth');
const vendorRoutes = require('./routes/vendors');
const itemRoutes = require('./routes/items');
const orderRoutes = require('./routes/orders');
const userRoutes = require('./routes/users');
const addressRoutes = require('./routes/addresses');
const notificationRoutes = require('./routes/notifications');
const bannerRoutes = require('./routes/banners');
const settingsRoutes = require('./routes/settings');
const payoutsRoutes = require('./routes/payouts');

app.use('/api/auth', authRoutes);   // <‑‑ NEW: authentication endpoints
app.use('/api/vendors', vendorRoutes);
app.use('/api/items', itemRoutes);
app.use('/api/orders', orderRoutes);
app.use('/api/users', userRoutes);
app.use('/api/addresses', addressRoutes);
app.use('/api/notifications', notificationRoutes);
app.use('/api/banners', bannerRoutes);
app.use('/api/settings', settingsRoutes);
app.use('/api/payouts', payoutsRoutes);

// Multer Setup for File Uploads
const storage = multer.diskStorage({
    destination: (req, file, cb) => {
        cb(null, 'uploads/');
    },
    filename: (req, file, cb) => {
        const uniqueSuffix = Date.now() + '-' + Math.round(Math.random() * 1E9);
        cb(null, uniqueSuffix + path.extname(file.originalname));
    }
});
const upload = multer({ storage: storage });

// Database Connection Test Route
app.get('/api/health', (req, res) => {
    res.json({ status: 'ok', message: 'Backend is running!' });
});

// Root Route
app.get('/', (req, res) => {
    res.send('Wankaner Go API is running! 🚀');
});

// Generic Image Upload Route
app.post('/api/upload', upload.single('image'), (req, res) => {
    if (!req.file) {
        return res.status(400).json({ error: 'No image uploaded' });
    }
    const imageUrl = `${req.protocol}://${req.get('host')}/uploads/${req.file.filename}`;
    res.json({ imageUrl });
});

app.listen(port, () => {
    console.log(`Server running on http://localhost:${port}`);
});
