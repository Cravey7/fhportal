# Deployment Quick Start Guide

## Overview
This guide provides step-by-step instructions to set up GitHub repository and Vercel deployment for the FH Portal MVP, integrating with our database refactoring plan and development workflow.

## Prerequisites
- GitHub account with repository access
- Vercel account connected to GitHub
- Supabase project (Frontend Horizon) access
- Node.js 18+ installed locally

## Phase 1: Repository Setup (30 minutes)

### Step 1: Create GitHub Repository
```bash
# 1. Create repository on GitHub
# Name: fh-portal
# Description: Frontend Horizon Portal - Business Management Platform
# Visibility: Private
# Initialize with README

# 2. Clone and setup locally
git clone https://github.com/Cravey7/fh-portal.git
cd fh-portal

# 3. Create branch structure
git checkout -b develop
git checkout -b feature/database-refactoring
git push -u origin develop
git push -u origin feature/database-refactoring
```

### Step 2: Add Documentation
```bash
# Copy all .md files to docs/ directory
mkdir docs
cp *.md docs/

# Commit documentation
git add docs/
git commit -m "docs: add MVP planning documentation

- Add feature specifications and roadmap
- Include database refactoring plan
- Add design system and development standards
- Include dependency mapping and workflows"

git push origin feature/database-refactoring
```

### Step 3: Setup Project Structure
```bash
# Initialize Next.js project
npx create-next-app@latest . --typescript --tailwind --eslint --app --src-dir --import-alias "@/*"

# Install additional dependencies
npm install @supabase/supabase-js @tanstack/react-query zustand
npm install -D husky lint-staged @types/node

# Setup development tools
npx husky install
npm pkg set scripts.prepare="husky install"
```

## Phase 2: Environment Configuration (20 minutes)

### Step 4: Environment Variables
```bash
# Create environment files
cp .env.example .env.local

# Edit .env.local with your values:
NEXT_PUBLIC_SUPABASE_URL=https://iymmsrexwwqwilmbpvna.supabase.co
NEXT_PUBLIC_SUPABASE_ANON_KEY=your_anon_key
SUPABASE_SERVICE_ROLE_KEY=your_service_role_key
NEXTAUTH_SECRET=your_nextauth_secret
NEXTAUTH_URL=http://localhost:3000
```

### Step 5: GitHub Secrets
Add these secrets to your GitHub repository (Settings → Secrets and variables → Actions):

```
SUPABASE_ACCESS_TOKEN=your_access_token
SUPABASE_PROJECT_ID=iymmsrexwwqwilmbpvna
VERCEL_TOKEN=your_vercel_token
VERCEL_ORG_ID=your_org_id
VERCEL_PROJECT_ID=your_project_id
NEXTAUTH_SECRET=your_nextauth_secret
NEXT_PUBLIC_SUPABASE_URL=https://iymmsrexwwqwilmbpvna.supabase.co
NEXT_PUBLIC_SUPABASE_ANON_KEY=your_anon_key
```

## Phase 3: Vercel Setup (15 minutes)

### Step 6: Connect Vercel to GitHub
1. Go to [vercel.com](https://vercel.com) and sign in
2. Click "New Project"
3. Import your `fh-portal` repository
4. Configure project settings:
   - Framework Preset: Next.js
   - Root Directory: ./
   - Build Command: `npm run build`
   - Output Directory: `.next`

### Step 7: Configure Vercel Environment Variables
In Vercel dashboard → Project Settings → Environment Variables, add:

```
NEXT_PUBLIC_SUPABASE_URL=https://iymmsrexwwqwilmbpvna.supabase.co
NEXT_PUBLIC_SUPABASE_ANON_KEY=your_anon_key
NEXTAUTH_SECRET=your_nextauth_secret
NEXTAUTH_URL=https://your-project.vercel.app
```

### Step 8: Setup Deployment Environments
1. **Production**: Connected to `main` branch
2. **Staging**: Connected to `develop` branch
3. **Preview**: Automatic for all PRs

## Phase 4: CI/CD Pipeline (25 minutes)

### Step 9: Add GitHub Workflows
```bash
# Create workflow directory
mkdir -p .github/workflows

# Copy workflow files from github-vercel-workflow.md
# - ci.yml (continuous integration)
# - deploy-staging.yml (staging deployment)
# - deploy-production.yml (production deployment)
```

### Step 10: Add Development Scripts
```bash
# Create scripts directory
mkdir -p scripts/{database,deployment,development}

# Add package.json scripts (see github-vercel-workflow.md section 6.1)
# Add database migration scripts
# Add validation scripts
```

### Step 11: Test Deployment Pipeline
```bash
# Commit and push changes
git add .
git commit -m "feat: setup deployment pipeline

- Add GitHub Actions workflows
- Configure Vercel integration
- Add development and deployment scripts
- Setup environment configurations"

git push origin feature/database-refactoring

# Create PR to develop branch
gh pr create --title "Setup: Deployment Pipeline" --body "Initial deployment pipeline setup"
```

## Phase 5: Database Integration (30 minutes)

### Step 12: Database Refactoring Setup
```bash
# Switch to database refactoring branch
git checkout feature/database-refactoring

# Follow database-refactoring-plan.md
# Execute Phase 1: Schema Harmonization (Day 1-3)
# This is critical before any feature development
```

### Step 13: Generate Database Types
```bash
# Install Supabase CLI
npm install -g supabase

# Login to Supabase
supabase login

# Generate TypeScript types
supabase gen types typescript --project-id iymmsrexwwqwilmbpvna > src/types/database.types.ts
```

### Step 14: Test Database Connection
```bash
# Create basic database test
npm run dev

# Verify connection to Frontend Horizon database
# Test basic queries and RLS policies
```

## Phase 6: Validation & Launch (20 minutes)

### Step 15: Run Full Validation
```bash
# Run all checks
npm run lint
npm run type-check
npm run build

# Test deployment
vercel --prod
```

### Step 16: Setup Monitoring
1. **Vercel Analytics**: Enable in project settings
2. **Error Tracking**: Configure Sentry (optional)
3. **Performance Monitoring**: Setup Core Web Vitals tracking

### Step 17: Team Access
1. **GitHub**: Add team members to repository
2. **Vercel**: Add team members to project
3. **Supabase**: Ensure team has appropriate access

## Quick Reference Commands

### Daily Development
```bash
# Start development
npm run dev

# Run tests
npm run test

# Check code quality
npm run lint && npm run type-check

# Deploy to staging
git push origin develop
```

### Database Operations
```bash
# Generate types
npm run db:generate-types

# Run migrations
npm run db:migrate

# Validate database
npm run db:validate
```

### Deployment
```bash
# Deploy to staging (automatic)
git push origin develop

# Deploy to production (automatic)
git push origin main

# Manual deployment
vercel --prod
```

## Troubleshooting

### Common Issues
1. **Environment Variables**: Ensure all required variables are set in both local and Vercel
2. **Database Connection**: Verify Supabase project ID and keys
3. **Build Failures**: Check TypeScript errors and dependency issues
4. **Deployment Errors**: Review Vercel function logs and build output

### Support Resources
- [Vercel Documentation](https://vercel.com/docs)
- [Supabase Documentation](https://supabase.com/docs)
- [Next.js Documentation](https://nextjs.org/docs)
- Team Slack: #fh-portal-dev

## Next Steps

After completing this setup:
1. **Follow database-refactoring-plan.md** for Week 1 database work
2. **Use feature-development-workflow.md** for feature development
3. **Reference mvp-roadmap.md** for timeline and milestones
4. **Track progress** using project-tracking-system.md

This setup provides a solid foundation for the FH Portal MVP development with automated testing, deployment, and monitoring.
