# Scheduled Alert System Setup

This document explains how to set up the scheduled alert system that generates one alert per farm every 5 minutes and sends it via SMS.

## Overview

The scheduled alert system:
- Generates one alert for each farm in every account
- Sends the alert via SMS to the user's phone number
- Runs every 5 minutes
- Can be triggered manually or via cron job

## API Endpoint

**Endpoint:** `GET /api/alerts/scheduled`

**Optional Security:**
- Add `?secret=YOUR_SECRET_KEY` to protect the endpoint
- Set `ALERT_CRON_SECRET` environment variable

**Example:**
```bash
# Without secret
curl http://localhost:3000/api/alerts/scheduled

# With secret
curl "http://localhost:3000/api/alerts/scheduled?secret=your-secret-key"
```

## Setup Options

### Option 1: Using a Cron Service (Recommended for Production)

#### Vercel Cron Jobs
If deploying on Vercel, add to `vercel.json`:
```json
{
  "crons": [
    {
      "path": "/api/alerts/scheduled",
      "schedule": "*/5 * * * *"
    }
  ]
}
```

#### External Cron Services
Use services like:
- **cron-job.org**: https://cron-job.org
- **EasyCron**: https://www.easycron.com
- **Cronitor**: https://cronitor.io

Configure to call: `https://your-domain.com/api/alerts/scheduled` every 5 minutes.

### Option 2: Using System Cron (Linux/Mac)

Add to your crontab (`crontab -e`):
```bash
# Run every 5 minutes
*/5 * * * * curl -X GET "http://localhost:3000/api/alerts/scheduled?secret=your-secret-key" > /dev/null 2>&1
```

### Option 3: Using Node.js Scheduler (Development)

Create a simple scheduler script:

```javascript
// scripts/schedule-alerts.js
const cron = require('node-cron');

// Run every 5 minutes
cron.schedule('*/5 * * * *', async () => {
  try {
    const response = await fetch('http://localhost:3000/api/alerts/scheduled');
    const data = await response.json();
    console.log('Scheduled alerts completed:', data);
  } catch (error) {
    console.error('Error running scheduled alerts:', error);
  }
});

console.log('Scheduled alert system started. Running every 5 minutes...');
```

Then run: `node scripts/schedule-alerts.js`

### Option 4: Manual Testing

You can manually trigger the alerts:
```bash
curl http://localhost:3000/api/alerts/scheduled
```

Or use the API route directly in your browser when running locally.

## Environment Variables

Optional environment variable for endpoint security:
```env
ALERT_CRON_SECRET=your-secret-key-here
```

## How It Works

1. **Fetches All Farms**: Gets all farms from the database with their associated user information
2. **Generates Alert**: Creates one alert per farm based on farm health score
3. **Sends SMS**: Sends the alert via SMS to the user's phone number (if available)
4. **Logs Results**: Logs the number of alerts generated and SMS messages sent

## Alert Types

The system generates alerts based on farm health score:
- **Critical** (health < 50): "Farm Health Alert" - Immediate attention needed
- **Warning** (health 50-69): "Farm Status Update" - Monitor closely
- **Info** (health ≥ 70): "Farm Monitoring" - Regular status update

## Response Format

```json
{
  "success": true,
  "timestamp": "2024-01-01T12:00:00.000Z",
  "duration": "1234ms",
  "totalFarms": 10,
  "alertsGenerated": 10,
  "smsSent": 8,
  "errors": 0,
  "results": [
    {
      "farmId": "farm-123",
      "farmName": "My Farm",
      "userId": "user-456",
      "alertGenerated": true,
      "smsSent": true
    }
  ]
}
```

## Troubleshooting

1. **Database errors**: Ensure database is properly configured and accessible
2. **Alert generation errors**: Check logs for specific error messages

## Notes

- The system processes all farms sequentially to avoid overwhelming the system
- SMS sending is asynchronous and won't block alert creation
- Failed SMS sends are logged but don't prevent alert creation
- The endpoint can be called manually for testing purposes
