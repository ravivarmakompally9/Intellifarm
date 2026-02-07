# File Structure for Deployment

This document shows the key files that were created/modified for separate frontend and backend deployments.

## New Files Created

### Backend (Render Deployment)
```
backend/
├── package.json              # Backend dependencies and scripts
├── next.config.js            # Next.js config for API-only server
├── tsconfig.json             # TypeScript config for backend
├── tsconfig.scripts.json     # TypeScript config for migration scripts
├── render.yaml               # Render deployment configuration
├── .gitignore                # Backend-specific gitignore
├── app/
│   ├── layout.tsx            # Minimal layout for API server
│   └── page.tsx              # Root page (health check)
└── (existing api routes, db, services, etc.)
```

### Frontend (Vercel Deployment)
```
frontend/
├── package.json              # Frontend dependencies and scripts
├── next.config.js            # Next.js config for frontend
├── tsconfig.json             # TypeScript config for frontend
├── tailwind.config.ts        # Tailwind CSS configuration
├── postcss.config.js         # PostCSS configuration
├── middleware.ts             # Clerk authentication middleware
├── vercel.json               # Vercel deployment configuration
├── .gitignore                # Frontend-specific gitignore
└── (existing app, components, lib, etc.)
```

### Documentation
```
DEPLOYMENT.md                 # Complete deployment guide
DEPLOYMENT_SUMMARY.md         # Quick reference summary
FILE_STRUCTURE.md             # This file
```

## Key Changes

1. **Separate package.json files** - Frontend and backend now have independent dependencies
2. **Independent configurations** - Each has its own Next.js, TypeScript, and build configs
3. **Environment variables** - Frontend uses `NEXT_PUBLIC_API_URL` to connect to backend
4. **Deployment configs** - `render.yaml` for backend, `vercel.json` for frontend

## How It Works

### Development (Local)
- Frontend runs on port 3000 (default)
- Backend runs on port 3001 (configured in backend/package.json)
- Set `NEXT_PUBLIC_API_URL=http://localhost:3001` in frontend `.env.local`

### Production
- Frontend deployed to Vercel
- Backend deployed to Render
- Frontend calls backend via `NEXT_PUBLIC_API_URL` environment variable

## Path Mappings

### Backend TypeScript Paths
- `@/*` → `./*` (backend root)
- `@/backend/*` → `./*` (same as above, for compatibility)
- `@/types/*` → `../types/*` (shared types from parent)

### Frontend TypeScript Paths
- `@/*` → `./*` (frontend root)
- `@/components/*` → `./components/*`
- `@/lib/*` → `./lib/*`
- `@/locales/*` → `./locales/*`
- `@/types/*` → `../types/*` (shared types from parent)

## Next Steps

1. Review the deployment guide: `DEPLOYMENT.md`
2. Set up your Render account and deploy backend
3. Set up your Vercel account and deploy frontend
4. Configure environment variables as documented
5. Test the deployed application

