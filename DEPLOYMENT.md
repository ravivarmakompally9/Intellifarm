# Deployment Guide

This guide explains how to deploy the FarmSight application with:
- **Frontend** on Vercel
- **Backend** on Render

## Project Structure

After reorganization, the project has two separate deployable applications:

```
DatanyxHack/
├── backend/          # Backend API (deploy to Render)
│   ├── app/
│   │   ├── api/      # API routes
│   │   ├── layout.tsx
│   │   └── page.tsx
│   ├── db/           # Database queries
│   ├── services/     # Business logic services
│   ├── middleware/   # Auth middleware
│   ├── migrations/   # Database migrations
│   ├── package.json
│   ├── next.config.js
│   ├── tsconfig.json
│   └── render.yaml   # Render configuration
│
└── frontend/         # Frontend app (deploy to Vercel)
    ├── app/          # Next.js pages
    ├── components/   # React components
    ├── lib/          # Frontend libraries
    ├── public/       # Static assets
    ├── locales/      # Translations
    ├── package.json
    ├── next.config.js
    ├── tsconfig.json
    ├── tailwind.config.ts
    └── vercel.json   # Vercel configuration
```

---

## Part 1: Backend Deployment (Render)

### Prerequisites
1. A Render account (sign up at https://render.com)
2. A PostgreSQL database (can be created on Render)
3. All API keys (OpenWeatherMap, Tavily, Google Earth Engine, etc.)

### Step 1: Prepare the Backend

1. **Navigate to the backend directory:**
   ```bash
   cd backend
   ```

2. **Install dependencies:**
   ```bash
   npm install
   ```

3. **Copy types directory to backend (if needed for builds):**
   ```bash
   # From project root
   cp -r types backend/types
   ```
   
   Or update `backend/tsconfig.json` to reference parent types directory (already configured).

### Step 2: Set Up PostgreSQL Database on Render

1. **Create a new PostgreSQL database:**
   - Go to Render Dashboard → New → PostgreSQL
   - Choose a name (e.g., `farmsight-db`)
   - Select a plan (Free tier available for testing)
   - Note the connection details (host, port, database, user, password)

2. **Copy the Internal Database URL** from Render dashboard (you'll need this later)

### Step 3: Run Database Migrations

**Option A: Run migrations locally before deployment:**
```bash
cd backend
npm run migrate
```

**Option B: Run migrations on Render (recommended):**
- After deploying, use Render's Shell or create a migration service
- Or use the migration script in the build command

### Step 4: Deploy Backend to Render

1. **Connect your repository to Render:**
   - Go to Render Dashboard → New → Web Service
   - Connect your GitHub/GitLab repository
   - Select the repository and branch

2. **Configure the service:**
   - **Name:** `farmsight-backend` (or your preferred name)
   - **Root Directory:** `backend`
   - **Environment:** `Node`
   - **Build Command:** `npm install && npm run build`
   - **Start Command:** `npm start`

3. **Set Environment Variables:**
   Add the following in Render's Environment section:

   ```env
   # Database Configuration
   DB_HOST=your-database-host.onrender.com
   DB_PORT=5432
   DB_NAME=farmsight
   DB_USER=farmsight_user
   DB_PASSWORD=your-database-password
   DB_SSL=true

   # Authentication
   JWT_SECRET=your-very-secure-jwt-secret-key-min-32-chars

   # Clerk Authentication (get from Clerk dashboard)
   NEXT_PUBLIC_CLERK_PUBLISHABLE_KEY=pk_live_...
   CLERK_SECRET_KEY=sk_live_...

   # External APIs (optional but recommended)
   OPENWEATHERMAP_API_KEY=your_openweathermap_key
   TAVILY_API_KEY=your_tavily_key
   GOOGLE_CLOUD_PROJECT_ID=your-gcp-project-id
   GOOGLE_EARTH_ENGINE_SERVICE_ACCOUNT_KEY=path/to/service-account-key.json

   # Server Configuration
   PORT=10000
   NODE_ENV=production
   ```

   **Important Notes:**
   - Get database credentials from your PostgreSQL service dashboard
   - Use `DB_SSL=true` for Render PostgreSQL
   - Generate a strong `JWT_SECRET` (use `openssl rand -base64 32`)
   - Get Clerk keys from https://dashboard.clerk.com

4. **Configure Google Earth Engine Service Account:**
   - Upload your service account JSON to Render
   - Set `GOOGLE_EARTH_ENGINE_SERVICE_ACCOUNT_KEY` to the file path
   - Or store the JSON content as an environment variable and read it in code

5. **Deploy:**
   - Click "Create Web Service"
   - Render will build and deploy your backend
   - Note the service URL (e.g., `https://farmsight-backend.onrender.com`)

### Step 5: Verify Backend Deployment

1. **Test the API:**
   ```bash
   curl https://your-backend-url.onrender.com/
   ```
   Should return: "FarmSight Backend API - API server is running"

2. **Test an API endpoint:**
   ```bash
   curl https://your-backend-url.onrender.com/api/farms
   ```
   Should return authentication error (which is expected without auth token)

---

## Part 2: Frontend Deployment (Vercel)

### Prerequisites
1. A Vercel account (sign up at https://vercel.com)
2. Your backend URL from Render deployment

### Step 1: Prepare the Frontend

1. **Navigate to the frontend directory:**
   ```bash
   cd frontend
   ```

2. **Install dependencies:**
   ```bash
   npm install
   ```

3. **Verify the API client is configured:**
   - Check `frontend/lib/api/client.ts`
   - It should use `process.env.NEXT_PUBLIC_API_URL`

### Step 2: Deploy Frontend to Vercel

#### Option A: Deploy via Vercel Dashboard (Recommended)

1. **Connect your repository:**
   - Go to https://vercel.com/dashboard
   - Click "Add New Project"
   - Import your GitHub/GitLab repository

2. **Configure the project:**
   - **Framework Preset:** Next.js (auto-detected)
   - **Root Directory:** `frontend` (important!)
   - **Build Command:** `npm run build` (or leave default)
   - **Output Directory:** `.next` (default)

3. **Set Environment Variables:**
   Add the following in Vercel's Environment Variables section:

   ```env
   # Backend API URL - YOUR RENDER BACKEND URL
   NEXT_PUBLIC_API_URL=https://your-backend-name.onrender.com

   # Clerk Authentication (same as backend, use publishable key)
   NEXT_PUBLIC_CLERK_PUBLISHABLE_KEY=pk_live_...

   # Node Environment
   NODE_ENV=production
   ```

   **Important:**
   - Replace `your-backend-name.onrender.com` with your actual Render backend URL
   - Use the same `NEXT_PUBLIC_CLERK_PUBLISHABLE_KEY` as your backend
   - Make sure to set these for Production, Preview, and Development environments

4. **Deploy:**
   - Click "Deploy"
   - Vercel will build and deploy your frontend
   - Note your frontend URL (e.g., `https://farmsight.vercel.app`)

#### Option B: Deploy via Vercel CLI

1. **Install Vercel CLI:**
   ```bash
   npm i -g vercel
   ```

2. **Login:**
   ```bash
   vercel login
   ```

3. **Navigate to frontend directory:**
   ```bash
   cd frontend
   ```

4. **Deploy:**
   ```bash
   vercel
   ```
   Follow the prompts and set environment variables when asked.

5. **Set environment variables:**
   ```bash
   vercel env add NEXT_PUBLIC_API_URL
   # Enter: https://your-backend-name.onrender.com

   vercel env add NEXT_PUBLIC_CLERK_PUBLISHABLE_KEY
   # Enter: pk_live_...
   ```

### Step 3: Configure CORS (if needed)

If you encounter CORS errors, update your backend to allow requests from your Vercel domain:

In `backend/app/api/*/route.ts` files, add CORS headers:

```typescript
// Example in a route handler
const response = NextResponse.json(data);
response.headers.set('Access-Control-Allow-Origin', 'https://your-frontend.vercel.app');
response.headers.set('Access-Control-Allow-Methods', 'GET, POST, PUT, DELETE, OPTIONS');
response.headers.set('Access-Control-Allow-Headers', 'Content-Type, Authorization');
return response;
```

Or create a middleware file for CORS handling.

### Step 4: Verify Frontend Deployment

1. **Visit your Vercel URL:**
   - Should load the landing page
   - Check browser console for any API errors

2. **Test authentication:**
   - Try signing up/logging in
   - Verify API calls are going to your Render backend

3. **Test API connectivity:**
   - Open browser DevTools → Network tab
   - Verify API requests are going to `your-backend-url.onrender.com`

---

## Part 3: Post-Deployment Configuration

### 1. Update Clerk Configuration

1. **Go to Clerk Dashboard:** https://dashboard.clerk.com
2. **Navigate to API Keys** and verify your keys are set
3. **Update Allowed Origins:**
   - Add your Vercel frontend URL: `https://your-frontend.vercel.app`
   - Add your Render backend URL: `https://your-backend.onrender.com`

### 2. Database Migrations

If you haven't run migrations yet:

**Option A: Using Render Shell:**
1. Go to your Render backend service
2. Click "Shell"
3. Run:
   ```bash
   npm run migrate
   ```

**Option B: Using local connection:**
```bash
# Connect to Render database from local machine
psql "postgresql://user:password@host:5432/database?sslmode=require"
# Then run migrations
\i backend/migrations/001_initial_schema.sql
```

### 3. File Uploads Configuration

For production, consider using cloud storage:
- **AWS S3**
- **Cloudinary**
- **Google Cloud Storage**

Update `backend/utils/upload.ts` to use cloud storage instead of local filesystem.

### 4. Environment-Specific Configuration

**Development (local):**
- Frontend: `NEXT_PUBLIC_API_URL=http://localhost:3001`
- Backend: Runs on port 3001

**Production:**
- Frontend: `NEXT_PUBLIC_API_URL=https://your-backend.onrender.com`
- Backend: Runs on port assigned by Render (usually 10000)

---

## Troubleshooting

### Backend Issues

**Build fails:**
- Check that all dependencies are in `backend/package.json`
- Verify TypeScript paths are correct
- Check build logs in Render dashboard

**Database connection errors:**
- Verify `DB_SSL=true` for Render PostgreSQL
- Check database credentials are correct
- Ensure database is accessible from Render

**API routes return 404:**
- Verify `app/api` directory structure is correct
- Check that routes are exported correctly
- Review Render logs for errors

### Frontend Issues

**API calls fail:**
- Verify `NEXT_PUBLIC_API_URL` is set correctly in Vercel
- Check CORS settings in backend
- Review browser console for errors

**Build fails:**
- Check that all dependencies are in `frontend/package.json`
- Verify TypeScript configuration
- Review Vercel build logs

**Authentication doesn't work:**
- Verify Clerk keys match between frontend and backend
- Check Clerk dashboard for allowed origins
- Ensure environment variables are set in Vercel

### Common Errors

**"Module not found" errors:**
- Ensure all dependencies are listed in respective `package.json`
- Run `npm install` in both frontend and backend directories

**CORS errors:**
- Add CORS headers in backend API routes
- Verify frontend URL is allowed in backend CORS configuration

**Database connection timeout:**
- Check database is running on Render
- Verify SSL mode is enabled (`DB_SSL=true`)
- Check database credentials

---

## Continuous Deployment

Both Render and Vercel support automatic deployments:

- **Render:** Automatically deploys on push to connected branch
- **Vercel:** Automatically deploys on push to main/master branch

To set up:
1. Ensure your repository is connected
2. Push changes to your repository
3. Both services will automatically build and deploy

---

## Monitoring and Logs

### Render Logs
- Go to your service dashboard
- Click "Logs" tab to view real-time logs

### Vercel Logs
- Go to your project dashboard
- Click on a deployment
- View "Build Logs" and "Function Logs"

### Database Monitoring
- Render PostgreSQL dashboard shows connection stats
- Monitor database size and connections

---

## Security Checklist

Before going to production:

- [ ] Change all default passwords and secrets
- [ ] Use production Clerk keys (not test keys)
- [ ] Enable SSL for database connections
- [ ] Set up proper CORS policies
- [ ] Configure rate limiting
- [ ] Set up error monitoring (Sentry, etc.)
- [ ] Enable database backups
- [ ] Use environment variables for all secrets
- [ ] Review and update security headers
- [ ] Test authentication flows thoroughly

---

## Cost Considerations

### Render (Free Tier)
- **Web Service:** 750 hours/month free (sleeps after 15 min inactivity)
- **PostgreSQL:** 90 days free trial, then paid

### Vercel (Free Tier)
- **Hobby Plan:** Unlimited deployments
- **Bandwidth:** 100GB/month
- **Serverless Functions:** 100GB-hours/month

For production, consider upgrading plans for:
- Always-on backend (Render)
- More database storage
- Higher bandwidth limits

---

## Next Steps

1. Set up monitoring and alerts
2. Configure custom domains
3. Set up CI/CD pipelines
4. Add error tracking (Sentry)
5. Set up database backups
6. Configure CDN for static assets
7. Set up automated testing

---

## Support

For issues specific to:
- **Render:** https://render.com/docs
- **Vercel:** https://vercel.com/docs
- **Clerk:** https://clerk.com/docs

For project-specific issues, check the main README.md or open an issue in the repository.

