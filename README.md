# IntelliFarm

A complete application for FarmSight - Early signals. Better decisions.

## Table of Contents

- [Project Overview](#project-overview)
- [Features](#features)
- [Tech Stack](#tech-stack)
- [Project Structure](#project-structure)
- [Getting Started](#getting-started)
- [Backend Setup](#backend-setup)
- [Database Setup](#database-setup)
- [API Endpoints](#api-endpoints)
- [ML Models](#ml-models)
- [Real-Time Data Integration](#real-time-data-integration)
- [Alerts System](#alerts-system)
- [Development Guide](#development-guide)
- [Production Checklist](#production-checklist)

## Project Overview

IntelliFarm is a comprehensive farm management system that provides:
- Real-time weather and satellite data monitoring
- ML-powered crop recommendations and disease detection
- Automated alerts for weather, pests, and crop health
- Activity logging and irrigation scheduling
- Market price insights and agricultural resources

## Features

- **Landing Page** with hero, how it works, and demo sections
- **Authentication** with phone number signup and OTP verification
- **Onboarding Flow** for adding farms with map integration
- **Farm Management** with health scores, alerts, and analytics
- **Photo Upload** with AI-powered ML analysis
- **Activity Logging** for irrigation, fertilizer, and other activities
- **Action Scheduling** for irrigation and inspections
- **Alerts Center** with filtering and bulk actions
- **Insights Dashboard** with aggregated analytics
- **Resources** with help articles and video demos
- **Settings** with language, notifications, and accessibility options
- **PWA Support** with offline capabilities
- **Internationalization** (English, Hindi, Telugu)
- **Error Handling** for edge cases

## Tech Stack

- **Frontend**: Next.js 14+ with App Router, TypeScript, Tailwind CSS, shadcn/ui components
- **State Management**: Zustand
- **Maps**: React Leaflet for maps
- **Charts**: Recharts for data visualization
- **PWA**: next-pwa for PWA support
- **Backend**: Next.js API routes, PostgreSQL database
- **ML**: Python with scikit-learn, YOLO for disease detection
- **External APIs**: Tavily (web search), OpenWeatherMap, Google Earth Engine, SoilGrids

## Project Structure

```
DatanyxHack/
├── backend/              # All backend source code
│   ├── app/
│   │   └── api/          # API routes (source files)
│   ├── db/               # Database configuration & queries
│   ├── services/         # Backend services (ML, soil)
│   ├── middleware/       # Authentication middleware
│   ├── migrations/       # Database migrations
│   ├── models/           # ML model files
│   └── utils/            # Backend utilities (OTP, upload)
│
├── frontend/             # All frontend source code
│   ├── app/              # Next.js pages (source files)
│   ├── components/       # React components
│   ├── lib/              # Frontend libraries (API client, hooks, store)
│   ├── public/           # Public assets
│   ├── locales/          # Translation files
│   └── assets/           # Image assets
│
├── app/                  # ⚠️ SYMLINKS ONLY (Next.js requirement)
│   ├── api -> ../backend/app/api
│   └── * -> ../frontend/app/*
│
├── scripts/              # ML training and utility scripts
│   ├── train_crop_model.py
│   ├── train_disease_model.py
│   └── detect_disease.py
│
└── types/                # Shared TypeScript types
```

**Important Notes:**
1. The `app/` directory at root contains ONLY symlinks - all actual source files are in `backend/` and `frontend/`
2. Edit files in `backend/` and `frontend/` - never edit files directly in the root `app/` directory
3. Next.js requires `app/` at root - this is a framework requirement, so we use symlinks to maintain clean organization

## Getting Started

### Prerequisites

- Node.js 18+ installed
- PostgreSQL 12+ installed and running
- npm or yarn package manager
- Python 3.8+ (for ML models)

### Installation

1. **Install dependencies:**
```bash
npm install
```

2. **Set up environment variables:**
```bash
cp .env.local.example .env.local
```

Update `.env.local` with your configuration:
```env
# Database
DB_HOST=localhost
DB_PORT=5432
DB_NAME=farmsight
DB_USER=postgres
DB_PASSWORD=your_password_here
DB_SSL=false

# Authentication
JWT_SECRET=your_jwt_secret_key_here_change_in_production

# External APIs (optional - for real-time data)
OPENWEATHERMAP_API_KEY=your_key_here
GOOGLE_EARTH_ENGINE_SERVICE_ACCOUNT_KEY=path/to/service-account-key.json
GOOGLE_CLOUD_PROJECT_ID=your-gcp-project-id
TAVILY_API_KEY=your_tavily_key_here

# File Uploads
UPLOAD_DIR=public/uploads
```

3. **Run the development server:**
```bash
npm run dev
```

4. **Open [http://localhost:3000](http://localhost:3000)** in your browser.

## Backend Setup

### Database Setup

1. **Create PostgreSQL Database:**
```bash
createdb farmsight
```

2. **Run Database Migrations:**
```bash
npm run migrate
```

Or manually:
```bash
psql -d farmsight -f backend/migrations/001_initial_schema.sql
```

### Database Schema

The database includes 9 main tables:
- `users` - User accounts and authentication
- `farms` - Farm locations and details
- `alerts` - Generated alerts for farms
- `activities` - Activity logs (irrigation, fertilizer, etc.)
- `scheduled_actions` - Scheduled irrigation and inspections
- `ml_results` - ML analysis results for photos
- `weather_data` - Cached weather data
- `satellite_data` - Cached satellite/NDVI data
- `irrigation_data` - Irrigation records

## API Endpoints

### Authentication
- `POST /api/auth/signup` - Sign up with phone number
- `POST /api/auth/verify` - Verify OTP
- `GET /api/auth/me` - Get current user (requires auth)

### Farms
- `GET /api/farms` - List all farms (requires auth)
- `POST /api/farms` - Create new farm (requires auth)
- `GET /api/farms/[id]` - Get farm by ID (requires auth)
- `PATCH /api/farms/[id]` - Update farm (requires auth)
- `DELETE /api/farms/[id]` - Delete farm (requires auth)

### Alerts
- `GET /api/alerts?farmId=<id>` - Get alerts (optional farm filter)
- `GET /api/alerts/[id]` - Get alert by ID
- `PATCH /api/alerts/[id]` - Resolve alert
- `POST /api/alerts/bulk` - Bulk resolve alerts
- `GET /api/alerts/generate?farmId=<id>` - Generate alerts for farm
- `GET /api/alerts/generate` - Generate alerts for all farms

### Photos
- `POST /api/photos/upload` - Upload photo and get ML analysis
- `GET /api/photos/[id]` - Get ML result by ID

### Weather
- `GET /api/weather?farmId=<id>&days=<n>` - Get weather data for farm
- `GET /api/weather/forecast?lat=<lat>&lng=<lng>&days=<n>` - Get forecast by location
- `GET /api/weather/current?lat=<lat>&lng=<lng>` - Get current weather

### Satellite
- `GET /api/satellite?farmId=<id>&days=<n>` - Get satellite data for farm
- `GET /api/satellite/trend?lat=<lat>&lng=<lng>` - Get NDVI trend by location

### Activities
- `GET /api/activities?farmId=<id>` - Get activities for farm
- `POST /api/activities` - Create activity
- `GET /api/activities/[id]` - Get activity by ID
- `PATCH /api/activities/[id]` - Update activity
- `DELETE /api/activities/[id]` - Delete activity

### Scheduled Actions
- `GET /api/scheduled-actions?farmId=<id>` - Get scheduled actions
- `POST /api/scheduled-actions` - Create scheduled action
- `GET /api/scheduled-actions/[id]` - Get action by ID
- `PATCH /api/scheduled-actions/[id]` - Update action
- `DELETE /api/scheduled-actions/[id]` - Delete action

### Irrigation
- `GET /api/irrigation?farmId=<id>` - Get irrigation data
- `GET /api/irrigation?stats=true` - Get irrigation statistics

### Crop Recommendations
- `GET /api/crop-recommendations?lat=<lat>&lng=<lng>` - Get crop recommendations

### Market Prices
- `GET /api/market-prices?crop=<crop_name>` - Get market prices

### Search (Tavily Integration)
- `GET /api/search?query=<query>&type=<type>&maxResults=<n>` - Web search
- `POST /api/search` - Web search with advanced options

### Chat
- `POST /api/chat` - Chat with AI assistant

### Text-to-Speech
- `POST /api/tts` - Convert text to speech

## ML Models

### Crop Recommendation Model

The system uses a machine learning model to predict crop suitability based on soil properties and weather conditions.

**Training:**
```bash
npm run train:model
```

Or directly:
```bash
python scripts/train_crop_model.py
```

**Model Location:** `backend/models/crop-recommendation-model.json`

**Features:**
- Predicts suitability scores (0-100) for crops
- Predicts yield and sustainability scores
- Uses Random Forest algorithm
- Trained on `farmer_advisor_dataset.csv`

**Testing:**
```bash
source venv/bin/activate
python scripts/test_model.py
```

### Disease Detection Model

YOLO-based model for detecting plant diseases from uploaded images.

**Training:**
```bash
./venv/bin/python scripts/train_disease_model.py --epochs 50 --model-size s
```

**Testing:**
```bash
./venv/bin/python scripts/detect_disease.py image.jpg
```

**Model Location:** `backend/models/disease_detection_best.pt`

**Dataset:** `PlantDiseases100x100/` (30 disease classes, 2,330 training images)

**Features:**
- Detects 30 different plant diseases
- Returns bounding boxes and confidence scores
- Provides suggested actions for each detection

## Real-Time Data Integration

### Weather APIs

**OpenWeatherMap** (Recommended)
- Free tier: 1,000 calls/day
- Features: Current weather, forecasts, alerts
- Setup: Sign up at https://openweathermap.org/api
- Add to `.env.local`: `OPENWEATHERMAP_API_KEY=your_key`

**WeatherAPI.com** (Alternative)
- Free tier: 1 million calls/month
- Good for high volume usage

### Satellite APIs

**Google Earth Engine** (Recommended)
- Free for research, education, and non-commercial use
- Features: Sentinel-2, Landsat, MODIS, extensive historical archives, high-quality NDVI calculations
- Setup:
  1. Create a Google Cloud project at https://console.cloud.google.com/
  2. Enable Earth Engine API in your project
  3. Create a service account:
     - Go to IAM & Admin > Service Accounts
     - Create a new service account
     - Grant it "Earth Engine User" role
     - Create and download a JSON key file
  4. Add to `.env.local`:
     - `GOOGLE_EARTH_ENGINE_SERVICE_ACCOUNT_KEY=path/to/service-account-key.json` (relative to project root or absolute path)
     - `GOOGLE_CLOUD_PROJECT_ID=your-gcp-project-id`
- Documentation: https://developers.google.com/earth-engine/guides/rest_api
- Benefits: Better data quality, extensive historical data, reliable NDVI calculations, better coverage

**AgroMonitoring** (Optional)
- Real-time soil moisture and temperature data
- Requires API key: `AGROMONITORING_API_KEY`
- Get API key from: https://agromonitoring.com/
- Note: Currently used as a fallback option (doesn't provide texture data)

### Tavily API Integration

Tavily provides real-time web search capabilities for:
- Current market prices
- Latest agricultural news
- Real-time information
- Market trends

**Setup:**
1. Get API key from Tavily
2. Add to `.env.local`: `TAVILY_API_KEY=your_key`
3. The chat assistant automatically uses Tavily for real-time queries

**Usage:**
```typescript
// Via API
GET /api/search?query=current+rice+prices&type=market

// In code
import { TavilyService } from '@/backend/services/tavily-service';
const tavilyService = new TavilyService();
const result = await tavilyService.search({ query: 'latest agricultural techniques' });
```

## Alerts System

The alerts system automatically monitors real-time data and generates intelligent alerts for farms.

### Alert Types

- **Weather**: Heatwaves, frost, extreme temperatures
- **Water Stress**: Drought, excessive rainfall, irrigation issues
- **Pest**: High pest probability based on ML predictions
- **Disease**: Crop health decline, disease risk
- **Nutrient**: Nutrient deficiency, soil degradation
- **Other**: General crop health issues

### Alert Severity Levels

- **info**: Informational - Monitor conditions
- **warn**: Warning - Action recommended soon
- **critical**: Critical - Immediate action required

### Alert Generation

Alerts are automatically generated when:
1. Farm dashboard is loaded
2. Real-time data is updated
3. Manual trigger via API: `GET /api/alerts/generate?farmId=<id>`

### Alert Rules

**Weather Alerts:**
- Heatwave: 2+ days with temp > 35°C
- Frost: 2+ days with temp < 10°C
- Excessive Rainfall: 2+ days with >50mm rain
- Drought: <20mm rainfall over 7+ days

**Satellite Alerts:**
- Crop Health Declining: NDVI trend decreasing AND current < average - 0.1
- Low Health Score: Health score < 50

**Water Stress:**
- High Water Stress: Risk > 60%
- Drought Risk: Risk = high

**Soil Alerts:**
- Soil Degradation: Index > 60
- Low Soil Moisture: Moisture level = Dry

**Risk-Based:**
- Pest Risk: Probability > 60%
- Nutrient Deficiency: Likelihood > 60%
- Temperature Stress: > 60%

## Development Guide

### Running the Project

**Important: Run from Root Directory!**

```bash
# From the root directory (DatanyxHack/)
npm run dev
```

This single command starts:
- Frontend (Next.js pages)
- Backend API routes
- Database connections
- Everything together

### Development Workflow

1. **Start dev server** (from root):
```bash
npm run dev
```

2. **Make changes:**
   - Frontend code: Edit files in `frontend/`
   - Backend code: Edit files in `backend/`
   - API routes: Edit files in `backend/app/api/`

3. **Hot reload**: Next.js automatically reloads on file changes

4. **Database**: Already connected via `.env.local`

### Testing

**Test Signup Flow:**
```bash
# 1. Sign up
curl -X POST http://localhost:3000/api/auth/signup \
  -H "Content-Type: application/json" \
  -d '{"phone": "9876543210", "name": "Test User"}'

# 2. Verify OTP (use OTP from response in dev mode)
curl -X POST http://localhost:3000/api/auth/verify \
  -H "Content-Type: application/json" \
  -d '{"phone": "9876543210", "otp": "123456"}'

# 3. Use token for authenticated requests
curl http://localhost:3000/api/farms \
  -H "Authorization: Bearer <token>"
```

**Test ML Models:**
```bash
# Test crop recommendation model
source venv/bin/activate
python scripts/test_model.py

# Test disease detection
./venv/bin/python scripts/detect_disease.py image.jpg
```

### File Uploads

Photo uploads are saved to `frontend/public/uploads/` directory. Make sure this directory exists and is writable.

### Troubleshooting

**Database Connection Errors:**
- Check PostgreSQL is running: `brew services list | grep postgresql`
- Start PostgreSQL: `brew services start postgresql`
- Verify `.env.local` has correct credentials

**Import Errors:**
- Make sure TypeScript paths in `tsconfig.json` are correct
- Restart the dev server after changing `tsconfig.json`

**API Routes Don't Work:**
- Check symlinks: `ls -la app/api`
- Verify backend files exist: `ls backend/app/api`

**404 Errors:**
- Clear Next.js cache: `rm -rf .next`
- Restart dev server: `npm run dev`

**Model Not Loading:**
- Check model file exists: `ls -lh backend/models/crop-recommendation-model.json`
- Verify virtual environment: `source venv/bin/activate`
- Check Python dependencies: `pip install -r requirements-ml.txt`

## Production Checklist

Before deploying to production:

- [ ] Change `JWT_SECRET` in `.env.local` to a strong random value
- [ ] Remove OTP from API responses (currently shown in dev mode)
- [ ] Set up real SMS service for OTP delivery
- [ ] Configure cloud storage for file uploads (S3, Cloudinary)
- [ ] Integrate real ML model for photo analysis
- [ ] Set up real weather/satellite API integrations
- [ ] Add rate limiting
- [ ] Configure CORS properly
- [ ] Set up database backups
- [ ] Use environment-specific database credentials
- [ ] Enable HTTPS
- [ ] Set up monitoring and logging
- [ ] Configure CDN for static assets
- [ ] Set up CI/CD pipeline

## Notes

- This is a full-stack implementation with real database and ML models
- Map integration uses React Leaflet (OpenStreetMap)
- ML results use trained models when available, fallback to mock data
- All data persists in PostgreSQL database
- PWA features are configured but may require HTTPS in production
- OTP is shown in API responses in development mode (remove in production)

## License

[Add your license here]

## Contributing

[Add contributing guidelines here]
#   z e n i t h  
 