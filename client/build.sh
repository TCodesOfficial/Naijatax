#!/bin/bash

# Dynamically write keys to config.prod.json using Node.js to prevent string escaping bugs
node -e '
const fs = require("fs");
const config = {
  SUPABASE_URL: process.env.SUPABASE_URL,
  SUPABASE_ANON_KEY: process.env.SUPABASE_ANON_KEY,
  API_BASE_URL: process.env.API_BASE_URL,
  GOOGLE_WEB_CLIENT_ID: process.env.GOOGLE_WEB_CLIENT_ID,
  GOOGLE_IOS_CLIENT_ID: process.env.GOOGLE_IOS_CLIENT_ID
};
fs.writeFileSync("config.prod.json", JSON.stringify(config, null, 2));
'

# Run your verified Flutter release command
flutter/bin/flutter build web --release --dart-define-from-file=config.prod.json
