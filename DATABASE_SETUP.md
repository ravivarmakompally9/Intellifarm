# Database Setup Guide

This guide will help you set up PostgreSQL for the Farmsight project.

## Quick Setup Options

### Option 1: Using Docker (Recommended - Easiest)

If you have Docker installed:

```bash
docker-compose up -d
```

This will:
- Start PostgreSQL in a container
- Create the `farmsight` database
- Expose it on port 5432
- Persist data in a Docker volume

Then run:
```bash
npm run setup:db
```

### Option 2: Local PostgreSQL Installation

#### Windows Installation

1. **Download PostgreSQL:**
   - Visit: https://www.postgresql.org/download/windows/
   - Download the installer
   - Run the installer and follow the setup wizard
   - Remember the password you set for the `postgres` user

2. **Or use a package manager:**
   ```powershell
   # Using Chocolatey
   choco install postgresql
   
   # Using winget
   winget install PostgreSQL.PostgreSQL
   ```

3. **Start PostgreSQL service:**
   ```powershell
   # Run the setup script
   .\scripts\setup-postgres.ps1
   
   # Or manually start the service
   net start postgresql-x64-15  # Replace 15 with your version
   ```

4. **Configure environment variables:**
   Create or update `.env.local`:
   ```env
   DB_HOST=localhost
   DB_PORT=5432
   DB_NAME=farmsight
   DB_USER=postgres
   DB_PASSWORD=your_postgres_password_here
   DB_SSL=false
   ```

5. **Run database setup:**
   ```bash
   npm run setup:db
   ```

## Manual Database Creation

If you prefer to create the database manually:

```bash
# Connect to PostgreSQL
psql -U postgres

# Create the database
CREATE DATABASE farmsight;

# Exit psql
\q

# Run migrations
npm run migrate
```

## Troubleshooting

### Connection Refused Error

**Problem:** `ECONNREFUSED` error when running setup

**Solutions:**
1. Ensure PostgreSQL service is running:
   ```powershell
   Get-Service "*postgresql*"
   Start-Service postgresql-x64-15  # Replace with your service name
   ```

2. Check if PostgreSQL is listening on port 5432:
   ```powershell
   netstat -an | findstr 5432
   ```

3. Verify firewall isn't blocking the connection

### Authentication Failed

**Problem:** Password authentication failed

**Solutions:**
1. Check your `.env.local` file has the correct password
2. Reset PostgreSQL password:
   ```bash
   psql -U postgres
   ALTER USER postgres PASSWORD 'new_password';
   ```
3. Update `.env.local` with the new password

### Database Already Exists

**Problem:** Database creation fails because it already exists

**Solution:** This is fine! The setup script will detect existing databases and skip creation. Just run:
```bash
npm run setup:db
```

### Port Already in Use

**Problem:** Port 5432 is already in use

**Solutions:**
1. Find what's using the port:
   ```powershell
   netstat -ano | findstr :5432
   ```
2. Either stop the other service or change the port in `.env.local`:
   ```env
   DB_PORT=5433
   ```

## Verify Setup

After setup, verify everything works:

```bash
# Test connection
npm run setup:db

# Or manually test
psql -U postgres -d farmsight -c "SELECT COUNT(*) FROM information_schema.tables WHERE table_schema = 'public';"
```

You should see a count of tables (should be 9 tables after migrations).

## Database Schema

The database includes these tables:
- `users` - User accounts
- `farms` - Farm locations and details
- `alerts` - Generated alerts
- `activities` - Activity logs
- `scheduled_actions` - Scheduled tasks
- `ml_results` - ML analysis results
- `weather_data` - Cached weather data
- `satellite_data` - Cached satellite/NDVI data
- `irrigation_data` - Irrigation records

## Need Help?

If you encounter issues:
1. Check the error message carefully
2. Verify PostgreSQL is running
3. Check your `.env.local` configuration
4. Review the troubleshooting section above

