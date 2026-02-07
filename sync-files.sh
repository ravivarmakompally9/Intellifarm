#!/bin/bash
# Script to sync frontend and backend files to app directory

echo "Syncing files to app directory..."

# Remove old files
rm -rf app/*

# Remove any symlinks from source directories first
find frontend/app -type l -delete 2>/dev/null

# Copy frontend pages
cp -r frontend/app/* app/

# Copy backend API routes
cp -r backend/app/api app/api

echo "✓ Files synced successfully!"
echo "Restart your dev server: npm run dev"
