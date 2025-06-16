# GitHub & Vercel Deployment Workflow

## Overview
This document outlines the complete workflow for setting up GitHub repository, implementing CI/CD pipelines, and deploying to Vercel for the FH Portal MVP. It integrates with our database refactoring plan and development standards.

## Repository Setup Strategy

### Phase 1: Repository Initialization (Day 1)

#### 1.1 GitHub Repository Creation
```bash
# Create new repository on GitHub
# Repository name: fh-portal
# Description: Frontend Horizon Portal - Business Management Platform
# Visibility: Private (initially)
# Initialize with: README, .gitignore (Node), License (MIT)
```

#### 1.2 Local Repository Setup
```bash
# Clone the repository
git clone https://github.com/Cravey7/fh-portal.git
cd fh-portal

# Set up development branch structure
git checkout -b develop
git checkout -b feature/database-refactoring
git checkout -b feature/design-system-setup

# Push initial branch structure
git push -u origin develop
git push -u origin feature/database-refactoring
git push -u origin feature/design-system-setup
```

#### 1.3 Repository Structure Setup
```
fh-portal/
├── .github/
│   ├── workflows/
│   │   ├── ci.yml
│   │   ├── deploy-staging.yml
│   │   └── deploy-production.yml
│   ├── ISSUE_TEMPLATE/
│   │   ├── bug_report.md
│   │   ├── feature_request.md
│   │   └── database_migration.md
│   └── pull_request_template.md
├── docs/
│   ├── mvp-features.md
│   ├── mvp-roadmap.md
│   ├── dependency-mapping.md
│   ├── database-refactoring-plan.md
│   └── [all other .md files]
├── scripts/
│   ├── database/
│   │   ├── migrate.js
│   │   ├── validate.js
│   │   └── rollback.js
│   ├── deployment/
│   │   ├── pre-deploy.js
│   │   └── post-deploy.js
│   └── development/
│       ├── setup.js
│       └── reset.js
├── src/
├── public/
├── .env.example
├── .env.local.example
├── package.json
├── next.config.js
├── tailwind.config.js
├── tsconfig.json
└── vercel.json
```

### Phase 2: Environment Configuration (Day 1-2)

#### 2.1 Environment Variables Setup
Create `.env.example`:
```env
# Supabase Configuration
NEXT_PUBLIC_SUPABASE_URL=your_supabase_url
NEXT_PUBLIC_SUPABASE_ANON_KEY=your_supabase_anon_key
SUPABASE_SERVICE_ROLE_KEY=your_service_role_key

# NextAuth Configuration
NEXTAUTH_SECRET=your_nextauth_secret
NEXTAUTH_URL=http://localhost:3000

# Database Configuration
DATABASE_URL=your_database_url

# Vercel Configuration
VERCEL_TOKEN=your_vercel_token

# Feature Flags
NEXT_PUBLIC_ENABLE_ANALYTICS=false
NEXT_PUBLIC_ENABLE_DEBUG=true

# External Services
STRIPE_SECRET_KEY=your_stripe_secret
STRIPE_PUBLISHABLE_KEY=your_stripe_publishable
```

#### 2.2 GitHub Secrets Configuration
```bash
# Required GitHub Secrets for CI/CD
SUPABASE_ACCESS_TOKEN
SUPABASE_PROJECT_ID
VERCEL_TOKEN
VERCEL_ORG_ID
VERCEL_PROJECT_ID
NEXTAUTH_SECRET
DATABASE_URL
STRIPE_SECRET_KEY
```

### Phase 3: CI/CD Pipeline Setup (Day 2-3)

#### 3.1 Continuous Integration Workflow
Create `.github/workflows/ci.yml`:
```yaml
name: Continuous Integration

on:
  push:
    branches: [ develop, main ]
  pull_request:
    branches: [ develop, main ]

jobs:
  lint-and-type-check:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      
      - name: Setup Node.js
        uses: actions/setup-node@v4
        with:
          node-version: '18'
          cache: 'npm'
          
      - name: Install dependencies
        run: npm ci
        
      - name: Run ESLint
        run: npm run lint
        
      - name: Run TypeScript check
        run: npm run type-check
        
      - name: Run Prettier check
        run: npm run format:check

  design-system-validation:
    runs-on: ubuntu-latest
    needs: lint-and-type-check
    steps:
      - uses: actions/checkout@v4
      
      - name: Setup Node.js
        uses: actions/setup-node@v4
        with:
          node-version: '18'
          cache: 'npm'
          
      - name: Install dependencies
        run: npm ci
        
      - name: Validate design system compliance
        run: npm run design-system:validate
        
      - name: Check component patterns
        run: npm run components:validate

  database-validation:
    runs-on: ubuntu-latest
    if: contains(github.event.head_commit.message, '[db]') || github.event_name == 'pull_request'
    steps:
      - uses: actions/checkout@v4
      
      - name: Setup Node.js
        uses: actions/setup-node@v4
        with:
          node-version: '18'
          cache: 'npm'
          
      - name: Install dependencies
        run: npm ci
        
      - name: Validate database migrations
        run: npm run db:validate
        env:
          DATABASE_URL: ${{ secrets.DATABASE_URL }}
          
      - name: Check RLS policies
        run: npm run db:check-rls
        env:
          SUPABASE_ACCESS_TOKEN: ${{ secrets.SUPABASE_ACCESS_TOKEN }}
          SUPABASE_PROJECT_ID: ${{ secrets.SUPABASE_PROJECT_ID }}

  test:
    runs-on: ubuntu-latest
    needs: [lint-and-type-check, design-system-validation]
    steps:
      - uses: actions/checkout@v4
      
      - name: Setup Node.js
        uses: actions/setup-node@v4
        with:
          node-version: '18'
          cache: 'npm'
          
      - name: Install dependencies
        run: npm ci
        
      - name: Run unit tests
        run: npm run test:unit
        
      - name: Run integration tests
        run: npm run test:integration
        env:
          DATABASE_URL: ${{ secrets.DATABASE_URL }}
          
      - name: Upload coverage reports
        uses: codecov/codecov-action@v3
        with:
          file: ./coverage/lcov.info

  build:
    runs-on: ubuntu-latest
    needs: [test, database-validation]
    steps:
      - uses: actions/checkout@v4
      
      - name: Setup Node.js
        uses: actions/setup-node@v4
        with:
          node-version: '18'
          cache: 'npm'
          
      - name: Install dependencies
        run: npm ci
        
      - name: Build application
        run: npm run build
        env:
          NEXT_PUBLIC_SUPABASE_URL: ${{ secrets.NEXT_PUBLIC_SUPABASE_URL }}
          NEXT_PUBLIC_SUPABASE_ANON_KEY: ${{ secrets.NEXT_PUBLIC_SUPABASE_ANON_KEY }}
          
      - name: Upload build artifacts
        uses: actions/upload-artifact@v3
        with:
          name: build-files
          path: .next/
```

#### 3.2 Staging Deployment Workflow
Create `.github/workflows/deploy-staging.yml`:
```yaml
name: Deploy to Staging

on:
  push:
    branches: [ develop ]
  workflow_dispatch:

jobs:
  deploy-staging:
    runs-on: ubuntu-latest
    environment: staging
    steps:
      - uses: actions/checkout@v4
      
      - name: Setup Node.js
        uses: actions/setup-node@v4
        with:
          node-version: '18'
          cache: 'npm'
          
      - name: Install dependencies
        run: npm ci
        
      - name: Run database migrations (staging)
        run: npm run db:migrate:staging
        env:
          DATABASE_URL: ${{ secrets.STAGING_DATABASE_URL }}
          SUPABASE_ACCESS_TOKEN: ${{ secrets.SUPABASE_ACCESS_TOKEN }}
          
      - name: Deploy to Vercel (staging)
        uses: amondnet/vercel-action@v25
        with:
          vercel-token: ${{ secrets.VERCEL_TOKEN }}
          vercel-org-id: ${{ secrets.VERCEL_ORG_ID }}
          vercel-project-id: ${{ secrets.VERCEL_PROJECT_ID }}
          vercel-args: '--prod'
          scope: ${{ secrets.VERCEL_ORG_ID }}
          
      - name: Run post-deployment tests
        run: npm run test:e2e:staging
        env:
          STAGING_URL: ${{ steps.deploy.outputs.preview-url }}
          
      - name: Notify team
        uses: 8398a7/action-slack@v3
        with:
          status: ${{ job.status }}
          channel: '#fh-portal-dev'
          webhook_url: ${{ secrets.SLACK_WEBHOOK }}
```

#### 3.3 Production Deployment Workflow
Create `.github/workflows/deploy-production.yml`:
```yaml
name: Deploy to Production

on:
  push:
    branches: [ main ]
  release:
    types: [ published ]

jobs:
  deploy-production:
    runs-on: ubuntu-latest
    environment: production
    steps:
      - uses: actions/checkout@v4
      
      - name: Setup Node.js
        uses: actions/setup-node@v4
        with:
          node-version: '18'
          cache: 'npm'
          
      - name: Install dependencies
        run: npm ci
        
      - name: Run full test suite
        run: npm run test:all
        env:
          DATABASE_URL: ${{ secrets.DATABASE_URL }}
          
      - name: Database backup (production)
        run: npm run db:backup:production
        env:
          SUPABASE_ACCESS_TOKEN: ${{ secrets.SUPABASE_ACCESS_TOKEN }}
          SUPABASE_PROJECT_ID: ${{ secrets.SUPABASE_PROJECT_ID }}
          
      - name: Run database migrations (production)
        run: npm run db:migrate:production
        env:
          DATABASE_URL: ${{ secrets.PRODUCTION_DATABASE_URL }}
          SUPABASE_ACCESS_TOKEN: ${{ secrets.SUPABASE_ACCESS_TOKEN }}
          
      - name: Deploy to Vercel (production)
        uses: amondnet/vercel-action@v25
        with:
          vercel-token: ${{ secrets.VERCEL_TOKEN }}
          vercel-org-id: ${{ secrets.VERCEL_ORG_ID }}
          vercel-project-id: ${{ secrets.VERCEL_PROJECT_ID }}
          vercel-args: '--prod'
          scope: ${{ secrets.VERCEL_ORG_ID }}
          
      - name: Run smoke tests
        run: npm run test:smoke:production
        env:
          PRODUCTION_URL: https://fh-portal.vercel.app
          
      - name: Update monitoring
        run: npm run monitoring:update
        env:
          SENTRY_AUTH_TOKEN: ${{ secrets.SENTRY_AUTH_TOKEN }}
          
      - name: Notify stakeholders
        uses: 8398a7/action-slack@v3
        with:
          status: ${{ job.status }}
          channel: '#fh-portal-releases'
          webhook_url: ${{ secrets.SLACK_WEBHOOK }}
```

### Phase 4: Vercel Configuration (Day 3)

#### 4.1 Vercel Project Setup
```json
// vercel.json
{
  "framework": "nextjs",
  "buildCommand": "npm run build:vercel",
  "devCommand": "npm run dev",
  "installCommand": "npm ci",
  "outputDirectory": ".next",
  "functions": {
    "app/api/**/*.ts": {
      "runtime": "nodejs18.x",
      "maxDuration": 30
    }
  },
  "env": {
    "NEXT_PUBLIC_SUPABASE_URL": "@supabase_url",
    "NEXT_PUBLIC_SUPABASE_ANON_KEY": "@supabase_anon_key",
    "NEXTAUTH_SECRET": "@nextauth_secret",
    "NEXTAUTH_URL": "@nextauth_url"
  },
  "build": {
    "env": {
      "SKIP_ENV_VALIDATION": "false",
      "ANALYZE": "false"
    }
  },
  "headers": [
    {
      "source": "/api/(.*)",
      "headers": [
        {
          "key": "Access-Control-Allow-Origin",
          "value": "*"
        },
        {
          "key": "Access-Control-Allow-Methods",
          "value": "GET, POST, PUT, DELETE, OPTIONS"
        },
        {
          "key": "Access-Control-Allow-Headers",
          "value": "Content-Type, Authorization"
        }
      ]
    }
  ],
  "redirects": [
    {
      "source": "/",
      "destination": "/dashboard",
      "permanent": false
    }
  ],
  "rewrites": [
    {
      "source": "/api/health",
      "destination": "/api/health-check"
    }
  ]
}
```

#### 4.2 Environment-Specific Configurations
```bash
# Staging Environment Variables (Vercel)
NEXT_PUBLIC_SUPABASE_URL=https://staging-project.supabase.co
NEXT_PUBLIC_SUPABASE_ANON_KEY=staging_anon_key
NEXTAUTH_URL=https://fh-portal-staging.vercel.app
NEXT_PUBLIC_ENABLE_ANALYTICS=false
NEXT_PUBLIC_ENABLE_DEBUG=true

# Production Environment Variables (Vercel)
NEXT_PUBLIC_SUPABASE_URL=https://production-project.supabase.co
NEXT_PUBLIC_SUPABASE_ANON_KEY=production_anon_key
NEXTAUTH_URL=https://fh-portal.vercel.app
NEXT_PUBLIC_ENABLE_ANALYTICS=true
NEXT_PUBLIC_ENABLE_DEBUG=false
```

### Phase 5: Development Workflow Integration (Day 4)

#### 5.1 Branch Strategy
```markdown
## Branch Structure
main (production)
├── develop (staging)
│   ├── feature/database-refactoring
│   ├── feature/authentication-system
│   ├── feature/company-management
│   ├── feature/campaign-management
│   ├── feature/project-management
│   ├── feature/task-management
│   ├── feature/apple-interface
│   └── feature/dashboard-search
├── hotfix/critical-bug-fix
└── release/v1.0.0
```

#### 5.2 Pull Request Workflow
```markdown
## PR Requirements
- [ ] All CI checks pass
- [ ] Design system validation passes
- [ ] Database migrations tested (if applicable)
- [ ] Test coverage maintained or improved
- [ ] Documentation updated
- [ ] Feature checklist completed
- [ ] Code review approved by 2+ team members
- [ ] QA testing completed (for features)
```

#### 5.3 Deployment Triggers
```markdown
## Automatic Deployments
- Push to `develop` → Deploy to staging
- Push to `main` → Deploy to production
- PR creation → Deploy preview environment

## Manual Deployments
- Database migrations → Manual approval required
- Production hotfixes → Emergency deployment process
- Feature flags → Gradual rollout process
```

## Development Scripts & Automation

### 6.1 Package.json Scripts
```json
{
  "scripts": {
    "dev": "next dev",
    "build": "next build",
    "build:vercel": "npm run db:generate-types && next build",
    "start": "next start",
    "lint": "next lint",
    "lint:fix": "next lint --fix",
    "type-check": "tsc --noEmit",
    "format": "prettier --write .",
    "format:check": "prettier --check .",

    "test": "jest",
    "test:watch": "jest --watch",
    "test:unit": "jest --testPathPattern=unit",
    "test:integration": "jest --testPathPattern=integration",
    "test:e2e": "playwright test",
    "test:e2e:staging": "STAGING=true playwright test",
    "test:smoke:production": "PRODUCTION=true playwright test --grep smoke",
    "test:all": "npm run test:unit && npm run test:integration && npm run test:e2e",

    "db:generate-types": "supabase gen types typescript --project-id $SUPABASE_PROJECT_ID > src/types/database.types.ts",
    "db:migrate": "node scripts/database/migrate.js",
    "db:migrate:staging": "ENVIRONMENT=staging node scripts/database/migrate.js",
    "db:migrate:production": "ENVIRONMENT=production node scripts/database/migrate.js",
    "db:validate": "node scripts/database/validate.js",
    "db:check-rls": "node scripts/database/check-rls.js",
    "db:backup:production": "node scripts/database/backup.js",
    "db:rollback": "node scripts/database/rollback.js",

    "design-system:validate": "node scripts/development/validate-design-system.js",
    "components:validate": "node scripts/development/validate-components.js",
    "monitoring:update": "node scripts/deployment/update-monitoring.js",

    "setup": "node scripts/development/setup.js",
    "reset": "node scripts/development/reset.js",
    "pre-commit": "lint-staged",
    "prepare": "husky install"
  }
}
```

### 6.2 Database Migration Scripts
Create `scripts/database/migrate.js`:
```javascript
const { createClient } = require('@supabase/supabase-js');
const fs = require('fs');
const path = require('path');

class DatabaseMigrator {
  constructor() {
    this.supabase = createClient(
      process.env.NEXT_PUBLIC_SUPABASE_URL,
      process.env.SUPABASE_SERVICE_ROLE_KEY
    );
    this.environment = process.env.ENVIRONMENT || 'development';
  }

  async runMigrations() {
    console.log(`🔄 Running migrations for ${this.environment} environment...`);

    try {
      // Read migration files
      const migrationsDir = path.join(__dirname, '../../migrations');
      const migrationFiles = fs.readdirSync(migrationsDir)
        .filter(file => file.endsWith('.sql'))
        .sort();

      for (const file of migrationFiles) {
        await this.runMigration(file);
      }

      console.log('✅ All migrations completed successfully');
    } catch (error) {
      console.error('❌ Migration failed:', error);
      process.exit(1);
    }
  }

  async runMigration(filename) {
    const filePath = path.join(__dirname, '../../migrations', filename);
    const sql = fs.readFileSync(filePath, 'utf8');

    console.log(`📝 Running migration: ${filename}`);

    const { error } = await this.supabase.rpc('exec_sql', { sql });

    if (error) {
      throw new Error(`Migration ${filename} failed: ${error.message}`);
    }

    console.log(`✅ Migration ${filename} completed`);
  }
}

// Run migrations
const migrator = new DatabaseMigrator();
migrator.runMigrations();
```

### 6.3 Design System Validation Script
Create `scripts/development/validate-design-system.js`:
```javascript
const fs = require('fs');
const path = require('path');
const glob = require('glob');

class DesignSystemValidator {
  constructor() {
    this.errors = [];
    this.warnings = [];
  }

  async validate() {
    console.log('🎨 Validating design system compliance...');

    await this.validateColorUsage();
    await this.validateComponentPatterns();
    await this.validateTypography();
    await this.validateSpacing();

    this.reportResults();
  }

  async validateColorUsage() {
    const files = glob.sync('src/**/*.{ts,tsx}');
    const forbiddenPatterns = [
      /text-red-\d+/,
      /bg-blue-\d+/,
      /border-green-\d+/,
      /#[0-9a-fA-F]{3,6}/  // Hex colors
    ];

    files.forEach(file => {
      const content = fs.readFileSync(file, 'utf8');

      forbiddenPatterns.forEach(pattern => {
        if (pattern.test(content)) {
          this.errors.push({
            file,
            type: 'color-violation',
            message: 'Use design system color tokens instead of arbitrary colors'
          });
        }
      });
    });
  }

  async validateComponentPatterns() {
    const componentFiles = glob.sync('src/components/**/*.tsx');

    componentFiles.forEach(file => {
      const content = fs.readFileSync(file, 'utf8');

      // Check for proper component structure
      if (!content.includes('interface') && !content.includes('type')) {
        this.warnings.push({
          file,
          type: 'component-props',
          message: 'Component should have TypeScript interface for props'
        });
      }

      // Check for className prop handling
      if (content.includes('className') && !content.includes('cn(')) {
        this.warnings.push({
          file,
          type: 'className-handling',
          message: 'Use cn() utility for className merging'
        });
      }
    });
  }

  reportResults() {
    if (this.errors.length === 0 && this.warnings.length === 0) {
      console.log('✅ Design system validation passed');
      return;
    }

    if (this.errors.length > 0) {
      console.log('\n❌ Design System Errors:');
      this.errors.forEach(error => {
        console.log(`  ${error.file}: ${error.message}`);
      });
    }

    if (this.warnings.length > 0) {
      console.log('\n⚠️  Design System Warnings:');
      this.warnings.forEach(warning => {
        console.log(`  ${warning.file}: ${warning.message}`);
      });
    }

    if (this.errors.length > 0) {
      process.exit(1);
    }
  }
}

const validator = new DesignSystemValidator();
validator.validate();
```

### 6.4 Pre-deployment Validation
Create `scripts/deployment/pre-deploy.js`:
```javascript
const { execSync } = require('child_process');

class PreDeployValidator {
  async validate() {
    console.log('🚀 Running pre-deployment validation...');

    try {
      await this.checkEnvironmentVariables();
      await this.validateBuild();
      await this.checkDatabaseConnection();
      await this.runSecurityChecks();

      console.log('✅ Pre-deployment validation passed');
    } catch (error) {
      console.error('❌ Pre-deployment validation failed:', error.message);
      process.exit(1);
    }
  }

  async checkEnvironmentVariables() {
    const required = [
      'NEXT_PUBLIC_SUPABASE_URL',
      'NEXT_PUBLIC_SUPABASE_ANON_KEY',
      'NEXTAUTH_SECRET'
    ];

    const missing = required.filter(env => !process.env[env]);

    if (missing.length > 0) {
      throw new Error(`Missing environment variables: ${missing.join(', ')}`);
    }
  }

  async validateBuild() {
    console.log('📦 Validating build...');
    execSync('npm run build', { stdio: 'inherit' });
  }

  async checkDatabaseConnection() {
    console.log('🗄️  Checking database connection...');
    // Add database connection check logic
  }

  async runSecurityChecks() {
    console.log('🔒 Running security checks...');
    execSync('npm audit --audit-level moderate', { stdio: 'inherit' });
  }
}

const validator = new PreDeployValidator();
validator.validate();
```

## Feature Development Integration

### 7.1 Feature Branch Workflow
```bash
# Start new feature
git checkout develop
git pull origin develop
git checkout -b feature/campaign-management

# Development cycle
git add .
git commit -m "feat(campaigns): add campaign CRUD operations

- Implement campaign creation form
- Add campaign listing with filters
- Include campaign status management
- Add campaign-project relationship

Closes #123"

# Push and create PR
git push -u origin feature/campaign-management
gh pr create --title "Feature: Campaign Management" --body "Implements campaign CRUD operations as defined in MVP features"
```

### 7.2 Database Migration Workflow
```bash
# Create new migration
mkdir -p migrations
echo "-- Migration: Add campaigns table
CREATE TABLE campaigns (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  company_id UUID REFERENCES companies(id) ON DELETE CASCADE,
  name VARCHAR(255) NOT NULL,
  status VARCHAR(50) DEFAULT 'draft',
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);" > migrations/$(date +%Y%m%d_%H%M%S)_add_campaigns_table.sql

# Test migration locally
npm run db:migrate

# Commit migration with feature
git add migrations/
git commit -m "db: add campaigns table migration

- Create campaigns table with company relationship
- Add status and audit fields
- Include proper constraints and indexes"
```

### 7.3 Deployment Checklist Integration
```markdown
## Pre-Deployment Checklist (Automated)
- [ ] All tests pass (CI/CD)
- [ ] Design system validation passes
- [ ] Database migrations tested
- [ ] Environment variables configured
- [ ] Security audit passes
- [ ] Build succeeds
- [ ] Performance benchmarks met

## Manual Deployment Checklist
- [ ] Feature checklist completed
- [ ] Code review approved
- [ ] QA testing completed
- [ ] Documentation updated
- [ ] Stakeholder approval (for major features)
- [ ] Rollback plan prepared
- [ ] Monitoring alerts configured
```

This comprehensive workflow ensures smooth development, testing, and deployment processes while maintaining code quality and system reliability throughout the MVP development cycle.
