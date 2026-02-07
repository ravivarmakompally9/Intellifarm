# Deployment Checklist

## ✅ What Has Been Done

- [x] Created separate `backend/package.json` for Render deployment
- [x] Created separate `frontend/package.json` for Vercel deployment
- [x] Created `backend/next.config.js` for API-only server
- [x] Created `frontend/next.config.js` for frontend app
- [x] Created `backend/tsconfig.json` with proper path mappings
- [x] Created `frontend/tsconfig.json` with proper path mappings
- [x] Created `backend/render.yaml` for Render configuration
- [x] Created `frontend/vercel.json` for Vercel configuration
- [x] Created backend `app/layout.tsx` and `app/page.tsx` (minimal)
- [x] Created `frontend/middleware.ts` for Clerk auth
- [x] Verified frontend API client uses `NEXT_PUBLIC_API_URL`
- [x] Created comprehensive deployment documentation

## 📋 What You Need to Do

### 1. Backend Setup (Render)

- [ ] Create Render account
- [ ] Create PostgreSQL database on Render
- [ ] Note database connection details
- [ ] Deploy backend to Render:
  - [ ] Connect GitHub repository
  - [ ] Set root directory to `backend`
  - [ ] Configure build command: `npm install && npm run build`
  - [ ] Configure start command: `npm start`
  - [ ] Add environment variables (see DEPLOYMENT.md)
- [ ] Run database migrations
- [ ] Test backend API endpoint
- [ ] Note your backend URL (e.g., `https://your-backend.onrender.com`)

### 2. Frontend Setup (Vercel)

- [ ] Create Vercel account
- [ ] Deploy frontend to Vercel:
  - [ ] Import GitHub repository
  - [ ] Set root directory to `frontend`
  - [ ] Add environment variable: `NEXT_PUBLIC_API_URL` = your Render backend URL
  - [ ] Add Clerk keys: `NEXT_PUBLIC_CLERK_PUBLISHABLE_KEY`
- [ ] Test frontend deployment
- [ ] Verify API calls are going to backend

### 3. Configuration

- [ ] Update Clerk dashboard with allowed origins:
  - [ ] Frontend URL (Vercel)
  - [ ] Backend URL (Render)
- [ ] Verify all environment variables are set correctly
- [ ] Test authentication flow
- [ ] Test API connectivity

### 4. Testing

- [ ] Test user signup/login
- [ ] Test API endpoints
- [ ] Test file uploads (if applicable)
- [ ] Test database operations
- [ ] Check for CORS errors
- [ ] Verify error handling

### 5. Security & Production

- [ ] Use production Clerk keys (not test keys)
- [ ] Set strong JWT secret
- [ ] Enable SSL for database
- [ ] Review CORS settings
- [ ] Set up error monitoring
- [ ] Configure database backups
- [ ] Test in production environment

## 🔧 Quick Reference

### Environment Variables Needed

**Backend (Render):**
- `DB_HOST`, `DB_PORT`, `DB_NAME`, `DB_USER`, `DB_PASSWORD`, `DB_SSL`
- `JWT_SECRET`
- `NEXT_PUBLIC_CLERK_PUBLISHABLE_KEY`
- `CLERK_SECRET_KEY`
- `OPENWEATHERMAP_API_KEY` (optional)
- `TAVILY_API_KEY` (optional)
- `GOOGLE_CLOUD_PROJECT_ID` (optional)
- `PORT=10000`
- `NODE_ENV=production`

**Frontend (Vercel):**
- `NEXT_PUBLIC_API_URL` (your Render backend URL)
- `NEXT_PUBLIC_CLERK_PUBLISHABLE_KEY`
- `NODE_ENV=production`

### Important URLs

- Backend URL: `https://your-backend-name.onrender.com`
- Frontend URL: `https://your-frontend-name.vercel.app`
- Clerk Dashboard: https://dashboard.clerk.com
- Render Dashboard: https://dashboard.render.com
- Vercel Dashboard: https://vercel.com/dashboard

## 📚 Documentation

- **Full Guide:** See `DEPLOYMENT.md` for detailed step-by-step instructions
- **Quick Summary:** See `DEPLOYMENT_SUMMARY.md` for quick reference
- **File Structure:** See `FILE_STRUCTURE.md` for file organization details

## 🆘 Troubleshooting

If you encounter issues:
1. Check the "Troubleshooting" section in `DEPLOYMENT.md`
2. Review build logs in Render/Vercel dashboards
3. Check environment variables are set correctly
4. Verify database connection settings
5. Test API endpoints directly using curl or Postman

## 🎉 Success Criteria

Your deployment is successful when:
- ✅ Backend API responds to requests
- ✅ Frontend loads without errors
- ✅ Authentication works (signup/login)
- ✅ API calls from frontend reach backend
- ✅ Database operations work
- ✅ No CORS errors in browser console

Good luck with your deployment! 🚀

