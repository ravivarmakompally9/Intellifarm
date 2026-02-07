# PWA Setup Documentation

## Overview
IntelliFarm has been configured as a Progressive Web App (PWA) that can be installed on mobile devices and provides an app-like experience.

## Features Implemented

### 1. PWA Manifest
- Complete manifest.json with all required icons and shortcuts
- App shortcuts for quick access to Farms, Alerts, Insights, and Add Farm
- Configured for standalone display mode

### 2. Icons
- Generated icons in multiple sizes: 72x72, 96x96, 128x128, 144x144, 152x152, 192x192, 384x384, 512x512
- Apple touch icon (180x180) for iOS
- Favicon for browser tabs

### 3. Install Prompt
- Custom install prompt component that detects installability
- iOS-specific installation instructions
- User preference storage to avoid repeated prompts

### 4. Service Worker & Offline Support
- Automatic service worker registration via next-pwa
- Network-first caching strategy
- Offline banner with retry functionality
- Update prompt for new versions

### 5. Mobile UI Enhancements
- Bottom navigation bar for mobile devices
- Safe area support for notched devices
- Minimum 44x44px touch targets
- Enhanced mobile menu with animations
- Improved form inputs (prevents iOS zoom)

### 6. iOS Support
- Apple-specific meta tags
- Standalone mode configuration
- Status bar styling
- Splash screen support

## Installation Instructions

### For Users

#### Android/Chrome:
1. Visit the website on your Android device
2. Look for the install prompt banner (appears after 3 seconds)
3. Tap "Install Now" or use browser menu → "Add to Home Screen"

#### iOS/Safari:
1. Visit the website on your iOS device
2. Tap the Share button (📤)
3. Scroll down and tap "Add to Home Screen"
4. Tap "Add" to confirm

### For Developers

#### Generating Icons
If you need to regenerate icons:
```bash
npm run generate:icons
```

This requires the `sharp` package (already installed as dev dependency).

#### Testing PWA
1. Build the production version:
   ```bash
   npm run build
   npm start
   ```

2. Test on mobile device or use Chrome DevTools:
   - Open DevTools → Application → Manifest
   - Check "Add to Home Screen" simulation
   - Test service worker in Application → Service Workers

#### PWA Checklist
- ✅ Manifest.json configured
- ✅ Icons in all required sizes
- ✅ Service worker registered
- ✅ Install prompt implemented
- ✅ Offline support
- ✅ Mobile UI optimizations
- ✅ iOS meta tags
- ✅ App shortcuts

## Configuration Files

- `frontend/public/manifest.json` - PWA manifest
- `frontend/public/icons/` - App icons
- `next.config.js` - PWA configuration
- `frontend/components/pwa/` - PWA components
- `frontend/lib/hooks/use-pwa-*.ts` - PWA hooks

## Notes

- Service worker is disabled in development mode (next-pwa configuration)
- Icons are generated from `frontend/public/icons/icon.svg`
- Install prompt respects user dismissal preference
- Update prompts appear when new service worker is available

