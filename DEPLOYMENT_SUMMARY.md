# Quick Deployment Summary

## What Changed

The project has been reorganized for separate deployments:

### Frontend (Vercel)
- Location: `frontend/` directory
- Has its own `package.json`, `next.config.js`, `tsconfig.json`
- Configured to call backend via `NEXT_PUBLIC_API_URL` environment variable

### Backend (Render)
- Location: `backend/` directory  
- Has its own `package.json`, `next.config.js`, `tsconfig.json`
- Configured as a Next.js API-only server
- Uses `render.yaml` for Render deployment configuration

## Quick Start

### Backend Setup (Render)
1. Go to Render dashboard
2. New → Web Service
3. Connect repository, set Root Directory to `backend`
4. Build: `npm install && npm run build`
5. Start: `npm start`
6. Add environment variables (see DEPLOYMENT.md)

### Frontend Setup (Vercel)
1. Go to Vercel dashboard
2. New Project → Import repository
3. Set Root Directory to `frontend`
4. Add environment variable: `NEXT_PUBLIC_API_URL=https://your-backend.onrender.com`
5. Deploy

## Key Files

- `DEPLOYMENT.md` - Complete step-by-step deployment guide
- `backend/package.json` - Backend dependencies
- `frontend/package.json` - Frontend dependencies
- `backend/render.yaml` - Render configuration template
- `frontend/vercel.json` - Vercel configuration

## Important Notes

1. **Environment Variables**: Both services need Clerk keys. Frontend needs `NEXT_PUBLIC_API_URL` pointing to your Render backend.

2. **Database**: Set up PostgreSQL on Render before deploying backend.

3. **Migrations**: Run database migrations after backend deployment.

4. **CORS**: May need to configure CORS in backend if you see CORS errors.

5. **Types**: If you encounter type errors, you may need to copy `types/` directory to `backend/types/` or adjust path mappings.

See `DEPLOYMENT.md` for detailed instructions.

