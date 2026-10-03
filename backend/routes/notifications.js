const express = require('express');
const router = express.Router();
const db = require('../db');
const { getMessaging } = require('firebase-admin/messaging');

router.post('/', async (req, res) => {
  try {
    const { title, message } = req.body;
    const [result] = await db.query('INSERT INTO global_notifications (title, message) VALUES (?, ?)', [title, message]);
    
    // Fetch all active FCM tokens
    const [users] = await db.query('SELECT fcm_token FROM users WHERE fcm_token IS NOT NULL');
    const tokens = users.map(u => u.fcm_token).filter(t => t.trim() !== '');

    if (tokens.length > 0) {
      // Use both notification and data payloads. 
      // 'notification' forces Google Play Services to display it even if the app is force-killed on Vivo.
      const payload = {
        notification: {
          title: title,
          body: message
        },
        data: {
          title: title,
          message: message
        }
      };
      
      // Multicast supports up to 500 tokens at once
      const response = await getMessaging().sendEachForMulticast({
        tokens: tokens,
        notification: payload.notification,
        data: payload.data,
        android: {
          priority: 'high',
          notification: {
            channelId: 'wankaner_go_channel_id',
            sound: 'default',
            defaultSound: true,
            defaultVibrateTimings: true,
            clickAction: 'FLUTTER_NOTIFICATION_CLICK'
          }
        },
        apns: {
          payload: {
            aps: {
              sound: 'default'
            }
          }
        }
      });
      console.log(response.successCount + ' messages were sent successfully');
    }

    res.json({ id: result.insertId, title, message });
  } catch (e) {
    console.error('Error sending push:', e);
    res.status(500).json({ error: e.message });
  }
});

router.get('/', async (req, res) => {
  try {
    const [rows] = await db.query('SELECT * FROM global_notifications ORDER BY created_at DESC LIMIT 10');
    res.json(rows);
  } catch (e) {
    res.status(500).json({ error: e.message });
  }
});

module.exports = router;