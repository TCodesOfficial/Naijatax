#!/bin/bash
# 1. Dynamically write your Vercel keys into a single JSON object
echo "{\"SUPABASE_URL\":\"$SUPABASE_URL\",\"SUPABASE_ANON_KEY\":\"$SUPABASE_ANON_KEY\",\"API_BASE_URL\":\"$API_BASE_URL\",\"GOOGLE_WEB_CLIENT_ID\":\"$GOOGLE_WEB_CLIENT_ID\",\"GOOGLE_IOS_CLIENT_ID\":\"$GOOGLE_IOS_CLIENT_ID\"}" > config.prod.json

# 2. Run your verified Flutter release command
flutter/bin/flutter build web --release --dart-define-from-file=config.prod.json
