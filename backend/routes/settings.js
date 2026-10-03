const express = require('express');
const router = express.Router();
const fs = require('fs');
const path = require('path');

const DATA_FILE = path.join(__dirname, '../settings.json');

// Default settings
const defaultSettings = {
  baseDeliveryFee: '20',
  platformCommission: '10',
  minimumOrderValue: '99',
  maintenanceMode: false,
  autoAssignPartners: true,
  surgePricing: false
};

// Helper to read settings
function getSettings() {
  if (!fs.existsSync(DATA_FILE)) {
    fs.writeFileSync(DATA_FILE, JSON.stringify(defaultSettings, null, 2));
    return defaultSettings;
  }
  const data = fs.readFileSync(DATA_FILE, 'utf8');
  return JSON.parse(data);
}

function saveSettings(data) {
  fs.writeFileSync(DATA_FILE, JSON.stringify(data, null, 2));
}

// GET settings
router.get('/', (req, res) => {
  try {
    const settings = getSettings();
    res.json(settings);
  } catch (err) {
    res.status(500).json({ error: err.message });
  }
});

// POST settings (overwrite all)
router.post('/', (req, res) => {
  try {
    const newSettings = { ...defaultSettings, ...req.body };
    saveSettings(newSettings);
    res.status(200).json(newSettings);
  } catch (err) {
    res.status(500).json({ error: err.message });
  }
});

module.exports = router;
