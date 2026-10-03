const express = require('express');
const router = express.Router();
const fs = require('fs');
const path = require('path');
const { v4: uuidv4 } = require('uuid');

const DATA_FILE = path.join(__dirname, '../banners.json');

// Helper to read banners
function getBanners() {
  if (!fs.existsSync(DATA_FILE)) {
    // Default banners if not exists
    const defaults = [
      {
        id: '1',
        title: 'Cravings\nSorted!',
        subtitle: 'Up to 50% OFF',
        emoji: '🍔',
        color1: '#FFFF9A9E',
        color2: '#FFFECFEF'
      },
      {
        id: '2',
        title: 'Fresh Grocery\nDelivered!',
        subtitle: 'Free Delivery',
        emoji: '🥦',
        color1: '#FFA18CD1',
        color2: '#FFFBC2EB'
      }
    ];
    fs.writeFileSync(DATA_FILE, JSON.stringify(defaults, null, 2));
    return defaults;
  }
  const data = fs.readFileSync(DATA_FILE, 'utf8');
  return JSON.parse(data);
}

function saveBanners(data) {
  fs.writeFileSync(DATA_FILE, JSON.stringify(data, null, 2));
}

// GET all banners
router.get('/', (req, res) => {
  try {
    const banners = getBanners();
    res.json(banners);
  } catch (err) {
    res.status(500).json({ error: err.message });
  }
});

// POST a new banner
router.post('/', (req, res) => {
  try {
    const banners = getBanners();
    const newBanner = {
      id: uuidv4(),
      title: req.body.title || 'New Banner',
      subtitle: req.body.subtitle || 'Special Offer',
      emoji: req.body.emoji || '✨',
      color1: req.body.color1 || '#FFFF9A9E',
      color2: req.body.color2 || '#FFFECFEF'
    };
    banners.push(newBanner);
    saveBanners(banners);
    res.status(201).json(newBanner);
  } catch (err) {
    res.status(500).json({ error: err.message });
  }
});

// PUT update a banner
router.put('/:id', (req, res) => {
  try {
    const banners = getBanners();
    const index = banners.findIndex(b => b.id === req.params.id);
    if (index === -1) return res.status(404).json({ error: 'Banner not found' });
    
    banners[index] = { ...banners[index], ...req.body, id: req.params.id };
    saveBanners(banners);
    res.json(banners[index]);
  } catch (err) {
    res.status(500).json({ error: err.message });
  }
});

// DELETE a banner
router.delete('/:id', (req, res) => {
  try {
    let banners = getBanners();
    banners = banners.filter(b => b.id !== req.params.id);
    saveBanners(banners);
    res.json({ message: 'Banner deleted' });
  } catch (err) {
    res.status(500).json({ error: err.message });
  }
});

module.exports = router;
