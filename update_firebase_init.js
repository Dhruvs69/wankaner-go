const fs = require('fs');
let text = fs.readFileSync('backend/server.js', 'utf-8');

const regex = /const \{ initializeApp, cert \} = require\('firebase-admin\/app'\);\r?\nconst serviceAccount = require\('\.\/firebase-service-account\.json'\);\r?\n\r?\ninitializeApp\(\{\r?\n  credential: cert\(serviceAccount\)\r?\n\}\);/;

const replacement = `const { initializeApp, cert } = require('firebase-admin/app');
require('dotenv').config();

let credentialParams;
if (process.env.FIREBASE_PRIVATE_KEY) {
  credentialParams = {
    projectId: process.env.FIREBASE_PROJECT_ID,
    clientEmail: process.env.FIREBASE_CLIENT_EMAIL,
    privateKey: process.env.FIREBASE_PRIVATE_KEY.replace(/\\\\n/g, '\\n'),
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
}`;

text = text.replace(regex, replacement);
fs.writeFileSync('backend/server.js', text, 'utf-8');
console.log('server.js updated for secure firebase init');
